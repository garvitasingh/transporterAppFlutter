import 'dart:async';

import 'package:device_info/device_info.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/PostIMEILatLangData.dart';

late Timer timer;
Position? _currentPosition;
double? latitude;
double? longitude;
String? device_Name;
double? speed;
double? heading;
int alarmId = 1;
TransporterIdController transporterIdController = Get.find<TransporterIdController>();

void backgroundTry() async {
  print("Background Try");
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "flutter_background example app",
    notificationText: "Background notification for keeping the example app running in the background",
    notificationImportance: AndroidNotificationImportance.Default,
    // notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );
  bool success = await FlutterBackground.initialize(androidConfig: androidConfig);
  print("Success in button is $success and it is in intialise");
  bool hasPermissions = await FlutterBackground.hasPermissions;
  print("Success in button is $hasPermissions and it is after initialise");
  bool BackExecute = await FlutterBackground.enableBackgroundExecution();
  print("BackExecute is $BackExecute");
  bool enabled = FlutterBackground.isBackgroundExecutionEnabled;
  print("Success in button is $enabled and it is after initialise");
  if (enabled == true) {
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _getUserAddress());
  } else {
    print("Please Enable It, It is disabled");
  }
}

void backgroundCancel() async {
  print("Background and timer canceled");
  await FlutterBackground.disableBackgroundExecution();
  timer.cancel();
}

void _getUserAddress() async {
  Geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
      .then((Position position) async {
      _currentPosition = position;
      speed = _currentPosition!.speed;
      latitude = _currentPosition!.latitude;
      longitude = _currentPosition!.longitude;
      heading  = _currentPosition!.heading;
      var now = new DateTime.now();
      var timeStamp = DateFormat('yyyyMMdd:HHmmss').format(now);
      postIMEILatLngData(
          lat: (latitude.toString()),
          trasnporterID: transporterIdController.transporterId.value,
          deviceName: device_Name,
          powerValue: '12',
          lng: (longitude.toString()),
          direction: heading.toString(),
          speed: speed.toString(),
          timestamp: timeStamp
      );
  }).catchError((e) {
    print("Error is $e");
  });
}

void getDeviceDetails() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  var brand = androidInfo.brand;
  device_Name = "$brand ${androidInfo.model}";
}
