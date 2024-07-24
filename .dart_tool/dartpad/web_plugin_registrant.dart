// Flutter web plugin registrant file.
//
// Generated file. Do not edit.
//

// @dart = 2.13
// ignore_for_file: type=lint

import 'package:awesome_notifications/awesome_notifications_web.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:connectivity_for_web/connectivity_for_web.dart';
import 'package:device_info_plus/src/device_info_plus_web.dart';
import 'package:firebase_app_check_web/firebase_app_check_web.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:firebase_database_web/firebase_database_web.dart';
import 'package:firebase_messaging_web/firebase_messaging_web.dart';
import 'package:firebase_storage_web/firebase_storage_web.dart';
import 'package:flutter_timezone/flutter_timezone_web.dart';
import 'package:permission_handler_html/permission_handler_html.dart';
import 'package:url_launcher_web/url_launcher_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins([final Registrar? pluginRegistrar]) {
  final Registrar registrar = pluginRegistrar ?? webPluginRegistrar;
  AwesomeNotificationsWeb.registerWith(registrar);
  FirebaseFirestoreWeb.registerWith(registrar);
  ConnectivityPlugin.registerWith(registrar);
  DeviceInfoPlusWebPlugin.registerWith(registrar);
  FirebaseAppCheckWeb.registerWith(registrar);
  FirebaseAuthWeb.registerWith(registrar);
  FirebaseCoreWeb.registerWith(registrar);
  FirebaseDatabaseWeb.registerWith(registrar);
  FirebaseMessagingWeb.registerWith(registrar);
  FirebaseStorageWeb.registerWith(registrar);
  FlutterTimezonePlugin.registerWith(registrar);
  WebPermissionHandler.registerWith(registrar);
  UrlLauncherPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
