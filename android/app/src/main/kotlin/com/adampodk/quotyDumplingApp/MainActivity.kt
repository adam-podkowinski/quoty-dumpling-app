package com.adampodk.quotyDumplingApp

import androidx.annotation.NonNull
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.Auth
import com.google.android.gms.auth.api.signin.GoogleSignInAccount
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.auth.api.signin.GoogleSignInResult
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val CHANNEL = "quotyDumplingChannel"
    private var googleSignInClient: GoogleSignInClient? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "initGoogleClientAndSignIn") {
                initGoogleClientAndSignIn();
                result.success(1);
            }
        }
    }

    private fun initGoogleClientAndSignIn() {
        val signInClient = GoogleSignIn.getClient(this, GoogleSignInOptions.DEFAULT_GAMES_SIGN_IN);
        val intent = signInClient.signInIntent;
        print("\n\nOPENING ACTIVITY\n\n")
        startActivityForResult(intent, 0);
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: android.content.Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        val result: GoogleSignInResult? = Auth.GoogleSignInApi.getSignInResultFromIntent(data)
        if (requestCode == 0 && result != null) {
            if (result.isSuccess()) {
                // The signed in account is stored in the result.
                val signedInAccount: GoogleSignInAccount = result.getSignInAccount()!!
                print("\n\nSuccess!!!\n\n\n")
            } else {
                print("\n\nERROR!\n\n")
                print(result.status)
//                    var message: kotlin.String = result.getStatus().getStatusMessage()
//                    if (message == null || message.isEmpty()) {
//                        print(message)
//                    }
            }
        }

    }
}
