package com.adampodk.quotyDumplingApp

import android.util.Log
import androidx.annotation.NonNull
import com.google.android.gms.auth.api.Auth
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.auth.api.signin.GoogleSignInAccount
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.auth.api.signin.GoogleSignInResult
import com.google.android.gms.drive.Drive.SCOPE_APPFOLDER
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val CHANNEL = "quotyDumplingChannel"
    private var isSignedIn: Boolean = false

    private lateinit var signInOption: GoogleSignInOptions

    private lateinit var signInClient: GoogleSignInClient

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        signInOption = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_GAMES_SIGN_IN)
                .requestScopes(SCOPE_APPFOLDER)
                .build()
        signInClient = GoogleSignIn.getClient(this, signInOption)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "signIn") {
                signIn()
                result.success(isSignedIn)
            }
            if (call.method == "signInSilently") {
                signInSilently()
                result.success(isSignedIn)
            }
            if (call.method == "signOut") {
                signOut()
                result.success(isSignedIn)
            }
        }
    }

    private fun signInSilently() {
        signInClient.silentSignIn()?.addOnCompleteListener(this
        ) { task ->
            if (task.isSuccessful) {
                isSignedIn = true
                if (task.result.email != null) {
                    Log.d("SIGNING", "Signed client object email: " + task.result.email!!.toString())
                } else {
                    Log.d("SIGNING", "Signed client object (email==null): " + task.result.toString())
                }
            } else {
                isSignedIn = false
            }
        }
    }

    private fun signIn() {
        signInClient.silentSignIn()?.addOnCompleteListener(this
        ) { task ->
            if (task.isSuccessful) {
                isSignedIn = true
                if (task.result.email != null) {
                    Log.d("SIGNING", "Signed client object email: " + task.result.email!!.toString())
                } else {
                    Log.d("SIGNING", "Signed client object (email==null): " + task.result.toString())
                }
            } else {
                isSignedIn = true
                val intent = signInClient.signInIntent
                Log.d("SIGNING", "Failed to sign silently, trying explicit signing")
                Log.d("SIGNING", "OPENING ACTIVITY")
                startActivityForResult(intent, 0)
            }
        }
    }

    private fun signOut() {
        val signOutTask = signInClient.signOut()
        Log.d("SIGNING", signOutTask.exception.toString())
        isSignedIn = false
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: android.content.Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        val result: GoogleSignInResult? = Auth.GoogleSignInApi.getSignInResultFromIntent(data)
        if (requestCode == 0 && result != null) {
            if (result.isSuccess) {
                // The signed in account is stored in the result.
                val signedInAccount: GoogleSignInAccount? = result.signInAccount
                isSignedIn = true
                Log.d("SIGNING", "Success LOLL!!!")
                if (signedInAccount != null) {
                    if (signedInAccount.email != null) {
                        Log.d("SIGNING", "Signed in account email: " + signedInAccount.email!!.toString())
                    } else {
                        Log.d("SIGNING", "Signed in account email==null: $signedInAccount")
                    }
                } else {
                    isSignedIn = false
                    Log.d("SIGNING", "Signed in Account is null")
                    print("Signed in Account is null")
                }
            } else {
                isSignedIn = false
                Log.d("SIGNING", "ERROR")
                print(result.status)
            }
        }
    }
}
