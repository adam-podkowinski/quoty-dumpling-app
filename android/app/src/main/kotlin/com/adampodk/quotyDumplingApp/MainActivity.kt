package com.adampodk.quotyDumplingApp

import android.util.Log
import android.view.Gravity
import androidx.annotation.NonNull
import com.google.android.gms.auth.api.Auth
import com.google.android.gms.auth.api.signin.*
import com.google.android.gms.common.Scopes
import com.google.android.gms.common.api.Scope
import com.google.android.gms.games.Games
import com.google.android.gms.games.SnapshotsClient
import com.google.android.gms.games.SnapshotsClient.DataOrConflict
import com.google.android.gms.games.snapshot.Snapshot
import com.google.android.gms.games.snapshot.SnapshotMetadataChange
import com.google.android.gms.tasks.Continuation
import com.google.android.gms.tasks.Task
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.IOException


class MainActivity : FlutterActivity() {
    private val channel: String = "quotyDumplingChannel"
    private val mainSaveName = "main.quoty"

    private var isSignedIn: Boolean = false

    private lateinit var signInOption: GoogleSignInOptions

    private lateinit var signInClient: GoogleSignInClient

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        signInOption = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_GAMES_SIGN_IN)
                .requestScopes(Scope(Scopes.DRIVE_APPFOLDER))
                .build()
        signInClient = GoogleSignIn.getClient(this, signInOption)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            if (call.method == "signIn") {
                signIn(result)
            }
            else if (call.method == "signOut") {
                signOut(result)
            }
            else if (call.method == "isUserSignedIn") {
                isUserSignedIn(result)
            }
        }
    }

    private fun signIn(result: MethodChannel.Result) {
        signInClient.silentSignIn()?.addOnCompleteListener(this
        ) { task ->
            if (task.isSuccessful) {
                isSignedIn = true

                Games.getGamesClient(this, task.result)
                        .setGravityForPopups(Gravity.TOP or Gravity.CENTER_HORIZONTAL)
                val gamesClient = Games.getGamesClient(this@MainActivity, task.result)
                gamesClient.setViewForPopups(window.decorView.findViewById(android.R.id.content))

                result.success(true)
                if (task.result.email != null) {
                    Log.d("SIGNING", "Signed client object email: " + task.result.email!!.toString())
                } else {
                    Log.d("SIGNING", "Signed client object (email==null): " + task.result.toString())
                }
            } else {
                val intent = signInClient.signInIntent
                Log.d("SIGNING", "Failed to sign silently, trying explicit signing")
                Log.d("SIGNING", "OPENING ACTIVITY")
                startActivityForResult(intent, 0)
                result.success(false)
            }
        }
    }

    private fun signOut(result: MethodChannel.Result) {
        signInClient.signOut()?.addOnCompleteListener(this) { task ->
            if (task.isSuccessful) {
                Log.d("SIGNING", "Signed out successfully")
                isSignedIn = false
                result.success(false)
            } else {
                Log.d("SIGNING", "ERROR: Couldn't sign out")
                result.success(true)
            }
        }
    }

    private fun isUserSignedIn(result: MethodChannel.Result): Boolean {
        val user = GoogleSignIn.getLastSignedInAccount(this)

        return if (user != null) {
            isSignedIn = true
            Log.d("SIGNING", "User is signed in")
            result.success(true)
            true
        } else {
            isSignedIn = false
            Log.d("SIGNING", "User is NOT signed in")
            result.success(false)
            false
        }
    }

    private fun saveJSONToGooglePlay(json: String): Boolean {
        val user = GoogleSignIn.getLastSignedInAccount(this)

        if (user != null) {
            val snapshotsClient: SnapshotsClient = Games.getSnapshotsClient(this, user)
            snapshotsClient.open(mainSaveName, true).addOnCompleteListener(this) { task ->
                if (!task.result.isConflict) {
                    val snapshot = task.result.data
                    snapshot.snapshotContents.writeBytes(json.toByteArray())

                    snapshotsClient.commitAndClose(snapshot, SnapshotMetadataChange.EMPTY_CHANGE)
                }
            }
            return true
        }

        return false
    }

    private fun loadJSONBytesFromGooglePlay(): Task<ByteArray>? {
        val user = GoogleSignIn.getLastSignedInAccount(this)
        if (user != null) {
            val snapshotsClient = Games.getSnapshotsClient(this, user)
            val conflictResolutionPolicy = SnapshotsClient.RESOLUTION_POLICY_MOST_RECENTLY_MODIFIED

            return snapshotsClient.open(mainSaveName, true, conflictResolutionPolicy).continueWith(
                    Continuation { task ->
                        val snapshot: Snapshot = task.result.data
                        try {
                            return@Continuation snapshot.snapshotContents.readFully()
                        } catch (e: IOException) {
                            Log.d("PLAY", "Error while reading Snapshot.", e)
                        }
                        return@Continuation null
                    }
            )
        }
        return null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: android.content.Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        val result: GoogleSignInResult? = Auth.GoogleSignInApi.getSignInResultFromIntent(data)
        if (requestCode == 0 && result != null) {
            if (result.isSuccess) {
                // The signed in account is stored in the result.
                val signedInAccount: GoogleSignInAccount? = result.signInAccount
                isSignedIn = true

                if (signedInAccount != null) {

                    Games.getGamesClient(this, signedInAccount)
                            .setGravityForPopups(Gravity.TOP or Gravity.CENTER_HORIZONTAL)
                    val gamesClient = Games.getGamesClient(this@MainActivity, signedInAccount)
                    gamesClient.setViewForPopups(window.decorView.findViewById(android.R.id.content))

                    if (signedInAccount.email != null) {
                        Log.d("SIGNING", "Signed in account email: " + signedInAccount.email!!.toString())
                    } else {
                        Log.d("SIGNING", "Signed in account email==null: $signedInAccount")
                    }
                } else {
                    isSignedIn = false
                    Log.d("SIGNING", "Signed in Account is null")
                }
            } else {
                isSignedIn = false
                Log.d("SIGNING", "ERROR ${result.status}")
            }
        }
    }
}
