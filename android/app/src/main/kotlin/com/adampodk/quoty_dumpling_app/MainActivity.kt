package com.adampodk.quoty_dumpling_app

import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "quotyDumplingChannel"
    private var googleSignInClient: GoogleSignInClient? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "initGoogleClientAndSignIn") {
                initGoogleClientAndSignIn();
                result.success(1);
            }
        }
    }

    private fun initGoogleClientAndSignIn() {
        googleSignInClient = GoogleSignIn.getClient(this, GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_GAMES_SIGN_IN).build())
        googleSignInClient?.silentSignIn()?.addOnCompleteListener{ task ->
            if (task.isSuccessful) {

            } else {
                Log.e("Error", "signInError", task.exception)
            }
        };
    }
}
