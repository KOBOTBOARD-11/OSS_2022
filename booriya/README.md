# booriya Setting
## android/app/src/main/AndroidMenifest.xml  
<details>
<summary> AndroidMenifest.xml </summary>
<div markdown="1">

<manifest xmlns:android=“http://schemas.android.com/apk/res/android”
    package=“com.example.booriya”>
    <uses-permission android:name=“android.permission.ACCESS_NETWORK_STATE” />
    <uses-permission android:name=“android.permission.INTERNET” />
    <!-- local notification -->
    <uses-permission android:name=“android.permission.POST_NOTIFICATIONS”/>
    <uses-permission android:name=“android.permission.RECEIVE_BOOT_COMPLETED”/>
    <uses-permission android:name=“android.permission.VIBRATE” />
    <uses-permission android:name=“android.permission.WAKE_LOCK” />
    <uses-permission android:name=“android.permission.USE_FULL_SCREEN_INTENT” />
    <uses-permission android:name=“android.permission.FOREGROUND_SERVICE” />
    <application
        android:label=“booriya”
        android:name=“${applicationName}”
        android:icon=“@mipmap/ic_launcher”>

        <activity
            android:name=“.MainActivity”
            android:exported=“true”
            android:launchMode=“singleTop”
            android:theme=“@style/LaunchTheme”
            android:configChanges=“orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode”
            android:hardwareAccelerated=“true”
            android:windowSoftInputMode=“adjustResize”
            android:showWhenLocked=“true”
            android:turnScreenOn=“true”>

            <!-- Specifies an Android theme to apply to this Activity as soon as
                 the Android process has started. This theme is visible to the user
                 while the Flutter UI initializes. After that, this theme continues
                 to determine the Window background behind the Flutter UI. -->
            <meta-data
                android:name=“com.google.firebase.messaging.default_notification_channel_id”
                android:value=“high_importance_channel”
              android:resource=“@style/NormalTheme”
              />
            <intent-filter>
                <action android:name=“android.intent.action.MAIN”/>
                <category android:name=“android.intent.category.LAUNCHER”/>
            </intent-filter>
        </activity>
        <receiver android:name=“com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver” />
        <receiver android:name=“com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver”>
            <intent-filter>
                <action android:name=“FLUTTER_NOTIFICATION_CLICK” />
                <category android:name=“android.intent.category.DEFAULT” />
                <action android:name=“android.intent.action.BOOT_COMPLETED”/>
                <action android:name=“android.intent.action.MY_PACKAGE_REPLACED”/>
                <action android:name=“android.intent.action.QUICKBOOT_POWERON” />
                <action android:name=“com.htc.intent.action.QUICKBOOT_POWERON”/>
            </intent-filter>
        </receiver>
        <!-- Don’t delete the meta-data below.
             This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
        <meta-data
            android:name=“flutterEmbedding”
            android:value=“2” />

    </application>
</manifest>
</div>
</details>  

## pubspec.yaml
 - flutter_local_notifications: ^9.9.1  
 - cupertino_icons: ^1.0.2  
 - video_player: ^2.4.7  
 - firebase_core: ^1.21.1  
 - firebase_messaging: ^13.0.1  
 - cloud_firestore: ^3.4.6  
 - web_socket_channel: ^2.2.0  
 - stop_watch_timer: ^1.5.0  
 - cached_video_player: ^2.0.3  
 - cached_network_image: ^3.2.1  

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
