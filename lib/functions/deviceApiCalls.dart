import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';

import '../models/deviceModel.dart';

String traccarPass = FlutterConfig.get("traccarPass");
String? current_lang;
// String traccarUser = FlutterConfig.get("traccarUser");
TransporterIdController transporterIdController =
Get.find<TransporterIdController>();
String Usertraccar = transporterIdController.mobileNum.value;

//to change authorization from admin to user
// TransporterIdController transporterIdController =
// Get.find<TransporterIdController>();
String traccarUser = transporterIdController.mobileNum.value;

class DeviceApiCalls {
  String traccarApi = FlutterConfig.get("traccarApi");
  late String _truckId;

  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));
  String userAuth =
      'Basic ' + base64Encode(utf8.encode('$Usertraccar:$traccarPass'));

  late List jsonData;

  // Truck Model List used to  create cards
  List<DeviceModel> truckDataList = [];

  //GET---------------------------------------------------------------------------
   ///getDevices function in getLocationUsingImei.dart file

  //POST---------------------------------------------------------------------------
  Future<dynamic> PostDevice(
      {required String truckName, required String uniqueid}) async {

    var headers = {
      'Authorization': userAuth,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse("$traccarApi/devices"));
    request.body = json.encode({"name": truckName, "uniqueId": uniqueid});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res= await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final decodeData = json.decode(res);
      print(res);
      print(decodeData["id"]);
      _truckId = decodeData["id"].toString();
      return _truckId;    //this post method return id of device
    } else {
      print(response.reasonPhrase);
      return null;
    }
  }

  //PUT---------------------------------------------------------------------------
  Future<dynamic> UpdateDevice(
      {required String truckId, required String truckType, required String truckTyre,
        required String truckWeight, required String uniqueId, required String truckName}) async{

    var headers = {
      'accept': 'application/json',
      'Authorization': basicAuth,
      'Content-Type': 'application/json',
      'Cookie': 'JSESSIONID=node016u831n3bqeajjbhtb9ohpmcg26.node0'
    };
    var request = http.Request('PUT', Uri.parse('$traccarApi/devices/$truckId'));
    request.body = json.encode({
      "id": truckId,
      "attributes": {
        "truckType": truckType,
        "tyreNo": truckTyre,
        "weight": truckWeight
      },
      "name": truckName,
      "uniqueId": uniqueId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    // var res= await response.stream.bytesToString();
    if (response.statusCode == 200) {
      // final decodeData = json.decode(res);
      // _truckId = decodeData["id"].toString();
      print(await response.stream.bytesToString());
      // return _truckId;
      return truckId;
    }
    else {
      print(response.reasonPhrase);
      // return null;
    }

  }

  // PUT ---- ADD DEVICE EXPIRATION ---------------------------------------------------------------

  Future<dynamic> AddDeviceExpire(
      {required String truckId, required String duration}) async {

    int index=2;
    DateTime expireTime;
    int yearCount=5;
    List<DeviceModel> deviceDetails = [];
    final _currentDate = DateTime.now();

    deviceDetails = await mapUtil.getDevices();
    for(var device in deviceDetails){
      truckDataList.add(device);
    }
    for(int i=0 ; i<truckDataList.length ;i++){
      if(truckDataList[i].deviceId.toString()==truckId){
        index = i ;
        break;
      }
    }
    print(duration);
      expireTime= new DateTime(_currentDate.year, );

    var headers = {
      'Authorization': userAuth,
      'Content-Type': 'application/json'
    };
    var request = http.Request('PUT', Uri.parse('$traccarApi/devices/$truckId'));
    request.body = json.encode({
      "id":truckDataList[index].deviceId,
      "attributes": {
        "speedLimit": truckDataList[index].attributes!.speedLimit,
        "deviceInactivityStart": truckDataList[index].attributes!.deviceInactivityStart,
        "deviceInactivityPeriod": truckDataList[index].attributes!.deviceInactivityPeriod,
        "engine_status": truckDataList[index].attributes!.engineStatus,
        "Passing Weight ": truckDataList[index].attributes!.passingWeight,
        "isSubscribed": "yes",
        "expirationTime": new DateTime(_currentDate.year+yearCount, _currentDate.month, _currentDate.day, _currentDate.hour, _currentDate.minute).toString()
      },
      "groupId": truckDataList[index].groupId,
      "name": truckDataList[index].truckno,
      "uniqueId": truckDataList[index].imei,
      "status": truckDataList[index].status,
      "lastUpdate": truckDataList[index].lastUpdate,
      "positionId": truckDataList[index].positionId,
      "geofenceIds": [],
      "phone": truckDataList[index].phone,
      "model": truckDataList[index].model,
      "contact": truckDataList[index].contact,
      "category": truckDataList[index].category,
      "disabled": truckDataList[index].disabled
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(response.reasonPhrase);
    }
    else {
      print(response.reasonPhrase);
    }
  }
}
