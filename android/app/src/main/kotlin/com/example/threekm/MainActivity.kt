package com.example.threekm

import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
//new imports

import io.flutter.Log
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine



class MainActivity: FlutterActivity() {
override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
     GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

        val soundUri: Uri = Uri.parse(
                "android.resource://" +
                        applicationContext.packageName +
                        "/" +
                        R.raw.alert_tone)

        val audioAttributes = AudioAttributes.Builder()
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
                .build()

        val channel = NotificationChannel("3kmcustom_notification_push_app_1",
                "noti_push_app",
                NotificationManager.IMPORTANCE_HIGH)
        channel.setSound(soundUri, audioAttributes)

        val notificationManager = getSystemService(NotificationManager::class.java)
        notificationManager.createNotificationChannel(channel)

        }
   
    }

}