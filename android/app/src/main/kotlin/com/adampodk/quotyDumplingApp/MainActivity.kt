package com.adampodk.quotyDumplingApp

import android.app.AlertDialog
import android.content.Intent
import android.content.SharedPreferences
import android.util.Log
import android.view.Gravity
import androidx.annotation.NonNull
import com.google.android.gms.auth.api.Auth
import com.google.android.gms.auth.api.signin.*
import com.google.android.gms.common.Scopes
import com.google.android.gms.common.api.Scope
import com.google.android.gms.games.Games
import com.google.android.gms.games.SnapshotsClient
import com.google.android.gms.games.snapshot.Snapshot
import com.google.android.gms.games.snapshot.SnapshotMetadataChange
import com.google.android.gms.tasks.Task
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import kotlin.math.sign
import kotlin.system.exitProcess


class MainActivity : FlutterActivity() {
    private val mainChannelName: String = "quotyDumplingChannel"
    private val mainSaveName = "main.quoty"
    private val globalSettingsChannelName: String = "globalSettingsChannel"
    private val mainDartChannelName: String = "mainChannel"
    private lateinit var globalSettingsChannel: MethodChannel
    private lateinit var mainDartChannel: MethodChannel

    private var isSignedIn: Boolean = false
    private var isBusy: Boolean = false;
    private var isLoading: Boolean = false

    private lateinit var signInOption: GoogleSignInOptions

    private lateinit var signInClient: GoogleSignInClient


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        signInOption =
            GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_GAMES_SIGN_IN)
                .requestScopes(Scope(Scopes.DRIVE_APPFOLDER))
                .build()
        signInClient = GoogleSignIn.getClient(this, signInOption)
        globalSettingsChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            globalSettingsChannelName
        )
        mainDartChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            mainDartChannelName
        )
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            mainChannelName
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "signIn" -> {
                    signIn(result)
                }
                "signOut" -> {
                    if (!isBusy) {
                        if (call.argument<String>("database") != null) {
                            val saveJSON: String =
                                call.argument<String>("database").toString()
                            signOut(result, saveJSON)
                        } else {
                            signOut(result, null)
                        }
                    }
                }
                "isUserSignedIn" -> {
                    isUserSignedIn(result)
                }
                "loadSaveFromGooglePlay" -> {
                    loadSaveFromGooglePlay(result)
                }
                "saveToGooglePlay" -> {
                    if (!isLoading) {
                        if (call.argument<String>("database") != null) {
                            val saveJSON: String =
                                call.argument<String>("database").toString()
                            saveToGooglePlay(result, saveJSON)
                        } else {
                            Log.d(
                                "SAVES",
                                "ERROR: call.argument<String>('database') is null"
                            )
                            result.error(
                                "0",
                                "ERROR: call.argument<String>('database') is null",
                                ""
                            )
                        }
                    }
                }
            }
        }
    }

    private fun signIn(result: MethodChannel.Result) {
        isBusy = true
        signInClient.silentSignIn()?.addOnCompleteListener(
            this
        ) { task ->
            if (task.isSuccessful) {
                isBusy = false
                isSignedIn = true

                Games.getGamesClient(this, task.result)
                    .setGravityForPopups(Gravity.TOP or Gravity.CENTER_HORIZONTAL)
                val gamesClient =
                    Games.getGamesClient(this@MainActivity, task.result)
                gamesClient.setViewForPopups(
                    window.decorView.findViewById(
                        android.R.id.content
                    )
                )

                val prefs: SharedPreferences = getSharedPreferences(
                    "FlutterSharedPreferences",
                    MODE_PRIVATE
                )
                prefs.edit().putBoolean("flutter.loginOnStartup", true).apply()

                result.success(true)
                if (task.result.email != null) {
                    Log.d(
                        "SIGNING",
                        "Signed client object email: " + task.result.email!!.toString()
                    )
                } else {
                    Log.d(
                        "SIGNING",
                        "Signed client object (email==null): " + task.result.toString()
                    )
                }
            } else {
                val intent = signInClient.signInIntent
                Log.d(
                    "SIGNING",
                    "Failed to sign silently, trying explicit signing"
                )
                Log.d("SIGNING", "OPENING ACTIVITY")
                startActivityForResult(intent, 0)
                result.success(false)
            }
        }
    }

    private fun signOut(result: MethodChannel.Result, jsonData: String?) {
        fun signOutHelper() {
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

        val task: Task<SnapshotsClient.DataOrConflict<Snapshot>>?
        if (jsonData != null) {
            task = saveToGooglePlay(null, jsonData)
            task?.addOnCompleteListener(this) {
                signOutHelper()
            }
        } else {
            signOutHelper()
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

    private fun saveToGooglePlay(
        result: MethodChannel.Result?,
        jsonData: String
    ): Task<SnapshotsClient.DataOrConflict<Snapshot>>? {
        isBusy = true
        val user = GoogleSignIn.getLastSignedInAccount(this)

        if (user != null) {
            val snapshotsClient: SnapshotsClient =
                Games.getSnapshotsClient(this, user)
            return snapshotsClient.open(mainSaveName, true)
                .addOnCompleteListener(this) { task ->
                    if (!task.result.isConflict) {
                        val snapshot = task.result.data
                        if (snapshot != null) {
                            snapshot.snapshotContents.writeBytes(jsonData.toByteArray())

                            snapshotsClient.commitAndClose(
                                snapshot,
                                SnapshotMetadataChange.EMPTY_CHANGE
                            )
                            Log.d("SAVES", "Saved game successfully")
                            result?.success(true)
                        } else {
                            Log.d("SAVES", "ERROR snapshot is null")
                            result?.error("0", "ERROR snapshot is null", "")
                        }
                        isBusy = false
                    } else {
                        isBusy = false
                        //TODO: resolve conflicts (occur very often!)
                        Log.d(
                            "SAVES",
                            "ERROR task.result.isConflict is true from saveJSONToGooglePlay"
                        )
                        result?.error(
                            "0",
                            "ERROR task.result.isConflict is true from saveJSONToGooglePlay",
                            ""
                        )
                    }
                }
        }

        result?.error("0", "ERROR (user == null) from saveJSONToGooglePlay", "")
        Log.d("SAVES", "ERROR (user == null) from saveJSONToGooglePlay")

        return null
    }

    private fun loadSaveFromGooglePlay(result: MethodChannel.Result?) {
        isBusy = true
        isLoading = true
        val user = GoogleSignIn.getLastSignedInAccount(this)
        if (user != null) {
            val snapshotsClient = Games.getSnapshotsClient(this, user)
            val conflictResolutionPolicy =
                SnapshotsClient.RESOLUTION_POLICY_MOST_RECENTLY_MODIFIED

            snapshotsClient.open(mainSaveName, true, conflictResolutionPolicy)
                .continueWith { task ->
                    val snapshot: Snapshot? = task.result.data
                    if (snapshot != null) {
                        try {
                            val contents =
                                String(snapshot.snapshotContents.readFully())
                            mainDartChannel.invokeMethod(
                                "loadDataFromGooglePlay",
                                contents
                            )
                            result?.success(contents)
                        } catch (e: IOException) {
                            Log.d("SAVES", "Error while reading Snapshot.", e)
                            result?.success("ERROR while loading data from google play")
                        }
                    }
                    isBusy = false
                    isLoading = false
                }
            } else {
                isBusy = false
                isLoading = false
            }
    }

    override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?
    ) {
        super.onActivityResult(requestCode, resultCode, data)
        val result: GoogleSignInResult? =
            Auth.GoogleSignInApi.getSignInResultFromIntent(data)
        if (requestCode == 0 && result != null) {
            if (result.isSuccess) {
                // The signed in account is stored in the result.
                val signedInAccount: GoogleSignInAccount? = result.signInAccount
                isSignedIn = true

                globalSettingsChannel.invokeMethod(
                    "changeIsSignedInToTrue",
                    null
                )

                val prefs: SharedPreferences = getSharedPreferences(
                    "FlutterSharedPreferences",
                    MODE_PRIVATE
                )
                prefs.edit().putBoolean("flutter.loginOnStartup", true).apply()

                if (signedInAccount != null) {
                    Games.getGamesClient(this, signedInAccount)
                        .setGravityForPopups(Gravity.TOP or Gravity.CENTER_HORIZONTAL)
                    val gamesClient =
                        Games.getGamesClient(this@MainActivity, signedInAccount)
                    gamesClient.setViewForPopups(
                        window.decorView.findViewById(
                            android.R.id.content
                        )
                    )

                    if (signedInAccount.email != null) {
                        Log.d(
                            "SIGNING",
                            "Signed in account email: " + signedInAccount.email!!.toString()
                        )
                    } else {
                        Log.d(
                            "SIGNING",
                            "Signed in account email==null: $signedInAccount"
                        )
                    }
                } else {
                    isSignedIn = false
                    Log.d("SIGNING", "Signed in Account is null")
                    prefs.edit().putBoolean("flutter.loginOnStartup", false)
                        .apply()
                }
                val user = GoogleSignIn.getLastSignedInAccount(this)
                if (user != null) {

                    val snapshotsClient: SnapshotsClient =
                        Games.getSnapshotsClient(
                            this,
                            user
                        )
                    snapshotsClient.open(mainSaveName, false).addOnFailureListener() {
                        Log.d("SAVES", "No saved game located.")
                    }.addOnSuccessListener {
                        val dialog = AlertDialog.Builder(this)
                        dialog.setTitle("Found game save")
                        dialog.setMessage("Do you want to load google play save from this account?\nYour current progress will be replaced and game will restart!")
                        dialog.setPositiveButton("Yes") { _, _ ->
                            this.loadSaveFromGooglePlay(null)
                        }
                        dialog.setNegativeButton("No, start new save", null)
                        dialog.show()

                    }
                }
            } else {
                isSignedIn = false
                Log.d("SIGNING", "ERROR ${result.status}")
                val prefs: SharedPreferences = getSharedPreferences(
                    "FlutterSharedPreferences",
                    MODE_PRIVATE
                )
                prefs.edit().putBoolean("flutter.loginOnStartup", false).apply()
            }
        }
    }
}
