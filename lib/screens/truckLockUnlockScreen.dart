import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/lockUnlockController.dart';
import 'package:liveasy/screens/TruckScreens/myTrucksScreen.dart';
import 'package:liveasy/screens/navigationScreen.dart';
import 'package:liveasy/screens/trackScreen.dart';
import 'package:liveasy/widgets/alertDialog/truckLockDialog.dart';

class TruckLockUnlock extends StatefulWidget {
  final int? deviceId;
  final List gpsData;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var lockStatus;
  final String? TruckNo;
  //final String? driverNum;
  //final String? driverName;
  //var truckId;

  TruckLockUnlock({
    required this.gpsData,
    required this.gpsDataHistory,
    required this.gpsStoppageHistory,
    //required this.routeHistory,
    required this.lockStatus,
    this.TruckNo,
    //this.driverName,
    //this.driverNum,
    this.deviceId,
    //this.truckId,
  });

  @override
  _TruckLockUnlockState createState() => _TruckLockUnlockState();
}

class _TruckLockUnlockState extends State<TruckLockUnlock> {
  var value = ["Unlock", "Lock"];
  final lockStorage = GetStorage();
  var lockState;

  LockUnlockController lockUnlockController = Get.put(LockUnlockController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //lockState = parseResult();
    //lockState = true;
    print(
        "-----------------------------------------THE STATUS IS ${lockStorage.read('lockState')}");
    //lockState = lockStorage.read('lockState');
    if (lockStorage.read('lockState') == null) {
      //lockState = parseResult();
      lockState = true;
      lockUnlockController.updateLockUnlockStatus(lockState);
      lockStorage.write('lockState', lockState);
      print("object");
    } else {
      lockState = lockStorage.read('lockState');
      lockUnlockController.updateLockUnlockStatus(lockState);
      lockStorage.write('lockState', lockState);
    }
    print(lockState);

    ///lockUnlockController.updateLockUnlockStatus(lockState);
    //lockState = lockUnlockController.lockUnlockStatus.value;
    print("INSIDE INIT OF LOCK");
    print(
        "THE CONTROLLER VALUE IS ${lockUnlockController.lockUnlockStatus.value}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // margin: EdgeInsets.only(bottom: space_10),
                width: MediaQuery.of(context).size.width,
                height: space_13,
                color: white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(space_3, 0, space_3, 0),
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back_ios_rounded),
                      ),
                    ),
                  ],
                ),
              ),
              lockUnlockController.lockUnlockStatus.value
                  ? Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              space_18, space_14, space_18, space_0),
                          child: Text.rich(
                            TextSpan(
                                text: "Abhi aapka truck ".tr,
                                style: TextStyle(fontSize: 20),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "unlocked".tr,
                                      style: TextStyle(
                                          fontWeight: boldWeight,
                                          fontSize: 20)),
                                  TextSpan(
                                      text: " Hai".tr,
                                      style: TextStyle(fontSize: 20)),
                                ]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: space_12,
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(
                                space_18, space_0, space_18, space_0),
                            child: Image.asset(
                                "assets/icons/unlockTruckLightIcon.png")),
                        SizedBox(height: space_7),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              space_16, space_0, space_16, space_0),
                          child: Text.rich(
                            TextSpan(
                                text: "Truck ".tr,
                                style: TextStyle(fontSize: 18),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Lock".tr,
                                      style: TextStyle(fontWeight: boldWeight)),
                                  TextSpan(
                                      text: " krne ke liye button press kijiye!"
                                          .tr,
                                      style: TextStyle(fontSize: 18)),
                                ]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: space_10,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              space_18, space_14, space_18, space_0),
                          child: Text.rich(
                            TextSpan(
                                text: "Abhi aapka truck ".tr,
                                style: TextStyle(fontSize: 20),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Locked".tr,
                                      style: TextStyle(
                                          fontWeight: boldWeight,
                                          fontSize: 20)),
                                  TextSpan(
                                      text: " Hai".tr,
                                      style: TextStyle(fontSize: 20)),
                                ]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: space_12,
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(
                                space_18, space_0, space_18, space_0),
                            child: Image.asset(
                                "assets/icons/lockTruckDarkIcon.png")),
                        SizedBox(height: space_7),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              space_16, space_0, space_16, space_0),
                          child: Text.rich(
                            TextSpan(
                                text: "Truck ".tr,
                                style: TextStyle(fontSize: 18),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "unlock".tr,
                                      style: TextStyle(fontWeight: boldWeight)),
                                  TextSpan(
                                      text: " krne ke liye button press kijiye!"
                                          .tr,
                                      style: TextStyle(fontSize: 18)),
                                ]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: space_10,
                        ),
                      ],
                    ),
              lockUnlockController.lockUnlockStatus.value
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: activeButtonColor,
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        side:
                                            BorderSide(color: darkBlueColor)))),
                            child: Text(
                              "Lock Kijiye".tr,
                              style: TextStyle(
                                color: white,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                lockState = lockStorage.read('lockState');
                                //lockState =
                                //lockUnlockController.lockUnlockStatus.value;
                                print(
                                    "------------------------------Device Id:${widget.deviceId}");
                                print(
                                    "------------------------------value:${value[1]}");
                              });
                              showDialog(
                                  context: context,
                                  builder: (context) => TruckLockDialog(
                                        deviceId: widget.deviceId,
                                        gpsData: widget.gpsData,
                                        // position: position,
                                        TruckNo: widget.TruckNo,
                                        //driverName: widget.driverName,
                                        //driverNum: widget.driverNum,
                                        gpsDataHistory: widget.gpsDataHistory,
                                        gpsStoppageHistory:
                                            widget.gpsStoppageHistory,
                                        //routeHistory: widget.routeHistory,
                                        //truckId: widget.truckId,
                                        value: value[1],
                                      ));
                              //         )).then((value) {
                              //   if (value) {
                              //     setState(() {
                              //       lockState = lockStorage.read('lockState');
                              //       //lockState = lockUnlockController
                              //       //.lockUnlockStatus.value;
                              //       print("SETHEEREEEEEEE");
                              //     });
                              //   }
                              // });
                            }),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: deactiveButtonColor,
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(color: darkBlueColor)))),
                          child: Text(
                            "Unlock Kijiye".tr,
                            style: TextStyle(
                              color: darkBlueColor,
                            ),
                          ),
                          onPressed: null,
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: deactiveButtonColor,
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        side:
                                            BorderSide(color: darkBlueColor)))),
                            child: Text(
                              "Lock Kijiye".tr,
                              style: TextStyle(
                                color: darkBlueColor,
                              ),
                            ),
                            onPressed: null),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: activeButtonColor,
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(color: darkBlueColor)))),
                          child: Text(
                            "Unlock Kijiye".tr,
                            style: TextStyle(
                              color: white,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              lockState = lockStorage.read('lockState');
                              //lockState =
                              //lockUnlockController.lockUnlockStatus.value;
                              print("SETSTATEEEEEEEEEEEEE");
                            });
                            showDialog(
                                context: context,
                                builder: (context) => TruckLockDialog(
                                      deviceId: widget.deviceId,
                                      gpsData: widget.gpsData,
                                      // position: position,
                                      TruckNo: widget.TruckNo,
                                      //driverName: widget.driverName,
                                      //driverNum: widget.driverNum,
                                      gpsDataHistory: widget.gpsDataHistory,
                                      gpsStoppageHistory:
                                          widget.gpsStoppageHistory,
                                      //routeHistory: widget.routeHistory,
                                      //truckId: widget.truckId,
                                      value: value[0],
                                    )).then((value) {
                              if (value) {
                                setState(() {
                                  lockState = lockStorage.read('lockState');
                                  //lockState = lockUnlockController
                                  //.lockUnlockStatus.value;
                                  print("SETHEEREEEEEEE");
                                });
                              }
                            });
                          },
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    ));
  }

  bool parseResult() {
    print("INTO PARSING ${widget.lockStatus}");
    if (widget.lockStatus == "Restore fuel supply:Success!") {
      return true;
      // lockState = true;
      // lockUnlockController.updateLockUnlockStatus(lockState);
      // print("Restore fuel success");
      // lockStorage.write('lockState', true);
      // lockUnlockController.lockUnlockStatus.value = true;
      // lockUnlockController.updateLockUnlockStatus(true);

    } else if (widget.lockStatus == "Cut off the fuel supply: Success!") {
      return false;
      // lockState = false;
      // lockUnlockController.updateLockUnlockStatus(lockState);
      // print("Cutoff supply successful");
      // lockStorage.write('lockState', false);
      // lockUnlockController.lockUnlockStatus.value = false;
      // lockUnlockController.updateLockUnlockStatus(false);
    } else if (widget.lockStatus ==
        "Already in the state of  fuel supply cut off, the command is not running!") {
      return false;
      // lockState = false;
      // lockUnlockController.updateLockUnlockStatus(lockState);
      // lockStorage.write('lockState', false);
      // lockUnlockController.lockUnlockStatus.value = false;
      // lockUnlockController.updateLockUnlockStatus(false);
    } else if (widget.lockStatus ==
        "Already in the state of fuel supply to resume,the command is not running!") {
      return true;
      // lockState = true;
      // lockUnlockController.updateLockUnlockStatus(lockState);
      // lockStorage.write('lockState', true);
      // lockUnlockController.lockUnlockStatus.value = true;
      // lockUnlockController.updateLockUnlockStatus(true);
    } else {
      return true;
      //lockState = true;
    }
  }
}
