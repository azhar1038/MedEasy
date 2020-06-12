package com.az.medeasy;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.az.medeasy";
    private static final int GET_PHONE_PERMISSION_REQUEST_ID = 7235;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("callAmbulance")) {
                        callAmbulance();
                    }else if(call.method.equals("emeds")){
                        String file = call.argument("file");
                        String message = call.argument("message");
                        sendThroughWhatsApp(file, message);
                    }
                }
        );
    }

    private void callAmbulance() {
        if (ContextCompat.checkSelfPermission(MainActivity.this, Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.CALL_PHONE}, GET_PHONE_PERMISSION_REQUEST_ID);
        }else{
            Uri uri = Uri.parse("tel:7606998553");
            Intent intent = new Intent(Intent.ACTION_CALL, uri);
            if(intent.resolveActivity(getPackageManager()) != null){
                startActivity(Intent.createChooser(intent, "Call Using ..."));
            }
        }
    }

    private void sendThroughWhatsApp(String file, String message){
        Uri uri = Uri.parse(file);
        Intent intent = new Intent();
        intent.setAction(Intent.ACTION_SEND);
        intent.putExtra(Intent.EXTRA_TEXT, message);
        intent.setType("text/plain");
        intent.putExtra(Intent.EXTRA_STREAM, uri);
        intent.setType("image/*");
        intent.putExtra("jid", "918917289203@s.whatsapp.net");
        intent.setPackage("com.whatsapp");
        startActivity(intent);
    }
}
