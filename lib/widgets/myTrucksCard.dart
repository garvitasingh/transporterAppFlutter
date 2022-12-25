import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/models/deviceModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/trackScreen.dart';
import 'package:liveasy/variables/truckFilterVariables.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../functions/deviceApiCalls.dart';
import 'alertDialog/CompletedDialog.dart';

// ignore: must_be_immutable
class MyTruckCard extends StatefulWidget {
  var truckno;
  var gpsData;
  String status;
  var imei;
  DeviceModel device;

  MyTruckCard(
      {required this.truckno,
      required this.status,
      this.gpsData,
      this.imei,
      required this.device});

  @override
  _MyTruckCardState createState() => _MyTruckCardState();
}

class _MyTruckCardState extends State<MyTruckCard> {
  TruckFilterVariables truckFilterVariables = TruckFilterVariables();
  bool online = true;
  bool lastUpdate = false;
  Position? userLocation;
  bool driver = false;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var gpsRoute;
  var totalDistance;
  var lastupdated;
  var lastupdated2;
  var no_stoppages;
  bool expired = false;
  DateTime timeNow = DateTime.now();
  late DateTime expiryDate;
  DateTime yesterday =
      DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));
  late String from = yesterday.toIso8601String();
  late String to = now.toIso8601String();
  late   var _razorpay;

  @override
  void initState() {
    // subscribeDevice();
    super.initState();
    try {
      initfunction();
    } catch (e) {print("errrrrrorrrr");}
  }


  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  subscribeDevice() async{
    DeviceApiCalls DeviceApi=DeviceApiCalls();
    var devices = await DeviceApi.AddDeviceExpire(
        truckId: widget.device.deviceId.toString(),
        duration: "1 year");
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_yidaXokSvDVva8',
      'amount':2000 * 100,
      'name': 'Liveasy',
      'description': 'Payment',
      'prefill': {'contact': transporterIdController.mobileNum.value, 'email' : "yourEmail@gmail.com"},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  Widget ExpiredTruckCard() {
    return Column(
      children: [
        Row(children: [
          Image.asset(
            'assets/icons/box-truck.png',
            width: 29,
            height: 29,
          ),
          SizedBox(
            width: 13,
          ),
          Column(
            children: [
              Text(
                '${widget.truckno}',
                style: TextStyle(
                  fontSize: 20,
                  color: black,
                ),
              ),
            ],
          ),
        ]),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your plan has been ",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              "EXPIRED",
              style: TextStyle(
                color: red,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "2000",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              "/year",
              style: TextStyle(
                fontSize: 14,
              ),
            )
          ],
        ),
        SizedBox(height: 10,),
        Container(
          width: space_20,
          height: space_7,
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )),
              backgroundColor: MaterialStateProperty.all<Color>(truckGreen),
            ),
            onPressed: () {
              openCheckout();
            },
            child: Text(
              "Buy Now",
              // AppLocalizations.of(context)!.addTruck,
              style: TextStyle(
                fontWeight: mediumBoldWeight,
                fontSize: 14,
                color: white,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget TruckCard() {
    return Column(
      children: [
        online
            ? Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      child: Icon(
                        Icons.circle,
                        color: const Color(0xff09B778),
                        size: 6,
                      ),
                    ),
                    Text(
                      'online'.tr,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - space_28,
                      child:
                      Text(
                        ' (${'lastupdated'.tr} $lastupdated ${'ago'.tr})  $lastupdated2',
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )
                    )
                  ],
                ),
              )
            : Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      child: Icon(
                        Icons.circle,
                        color: const Color(0xffFF4D55),
                        size: 6,
                      ),
                    ),
                    Text(
                      'offline'.tr,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - space_28,
                      child:
                      Text(
                        ' (${'lastupdated'.tr} $lastupdated ${'ago'.tr})  $lastupdated2',
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )
                    )
                  ],
                ),
              ),
        Row(
          children: [
            Image.asset(
              'assets/icons/box-truck.png',
              width: 29,
              height: 29,
            ),
            SizedBox(
              width: 13,
            ),
            Column(
              children: [
                Text(
                  '${widget.truckno}',
                  style: TextStyle(
                    fontSize: 20,
                    color: black,
                  ),
                ),
                /*   Text(
                                'time date ',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: black,
                                  ),

                              ),*/
              ],
            ),
            Spacer(),
            (widget.gpsData.speed < 5)
                ? Container(
              child: Column(
                children: [
                  Text("0 km/h",
                      style: TextStyle(
                          color: red,
                          fontSize: size_10,
                          fontStyle: FontStyle.normal,
                          fontWeight: regularWeight)),
                  Text('stopped'.tr,
                      // "Status",
                      style: TextStyle(
                          color: black,
                          fontSize: size_6,
                          fontStyle: FontStyle.normal,
                          fontWeight: regularWeight))
                ],
              ),
            )
                : Container(
              child: Column(
                children: [
                  Text("${(widget.gpsData.speed).round()} km/h",
                      style: TextStyle(
                          color: liveasyGreen,
                          fontSize: size_10,
                          fontStyle: FontStyle.normal,
                          fontWeight: regularWeight)),
                  Text('running'.tr,
                      // "Status",
                      style: TextStyle(
                          color: black,
                          fontSize: size_6,
                          fontStyle: FontStyle.normal,
                          fontWeight: regularWeight))
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Container(
        //         margin: EdgeInsets.all(3),
        //         decoration: BoxDecoration(
        //           color: truckGreen,
        //           borderRadius: BorderRadius.circular(10),
        //           boxShadow: [
        //             BoxShadow(
        //                 color: Colors.black12,
        //                 offset: Offset(3.0, 6.0),
        //                 blurRadius: 10.0),
        //           ],
        //         ),
        //         // color: truckGreen,
        //         child: Row(
        //           children: [
        //             Padding(
        //               padding: const EdgeInsets.all(3),
        //               child: Text(
        //                 "Active",
        //                 style:
        //                     TextStyle(color: white, fontSize: 9),
        //               ),
        //             ),
        //             Container(
        //               margin: EdgeInsets.all(2.0),
        //               height: 12,
        //               width: 12,
        //               decoration: BoxDecoration(
        //                   color: white, shape: BoxShape.circle),
        //             )
        //           ],
        //         )),
        //     Container(
        //       alignment: Alignment.center,
        //       height: 15,
        //       width: 100,
        //       // margin: EdgeInsets.all(10),
        //       decoration: BoxDecoration(
        //         color: red,
        //         borderRadius: BorderRadius.circular(10),
        //         boxShadow: [
        //           BoxShadow(
        //               color: Colors.black12,
        //               offset: Offset(3.0, 6.0),
        //               blurRadius: 10.0),
        //         ],
        //       ),
        //       child: Text(
        //         "Expired",
        //         style: TextStyle(color: white, fontSize: 9),
        //       ),
        //     )
        //   ],
        // ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(
              Icons.place_outlined,
              color: const Color(0xFFCDCDCD),
              size: 16,
            ),
            SizedBox(width: 8),
            Container(
              width: 200,
              child:
              Text(
                "${widget.gpsData.address}",
                maxLines: 3,
                style: TextStyle(
                    color: black,
                    fontSize: 12,
                    fontStyle: FontStyle.normal,
                    fontWeight: normalWeight),
              ),
            ),
          ]),
        ),
        SizedBox(
          height: 6,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: const Color(0xFFCDCDCD),
              ),
              SizedBox(width: 8),
              Text('truckTravelled'.tr,
                  // "Truck Travelled : ",
                  softWrap: true,
                  style: TextStyle(
                      color: black,
                      fontSize: size_6,
                      fontStyle: FontStyle.normal,
                      fontWeight: regularWeight)),
              Text("$totalDistance " + 'Km in last 24 hours'.tr,
                  // "km Today",
                  softWrap: true,
                  style: TextStyle(
                      color: black,
                      fontSize: size_6,
                      fontStyle: FontStyle.normal,
                      fontWeight: regularWeight)),
            ],
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 0, 0, 0),
          child:
          Row(
            children: [
              Image.asset(
                'assets/icons/circle-outline-with-a-central-dot.png',
                color: const Color(0xFFCDCDCD),
                width: 12,
                height: 12,
              ),
              SizedBox(
                width: 8,
              ),
              Text('ignition'.tr,
                  // 'Ignition  :',
                  style: TextStyle(
                      color: black,
                      fontSize: size_6,
                      fontStyle: FontStyle.normal,
                      fontWeight: regularWeight)),
              (widget.gpsData.ignition)
                  ? Text('on'.tr,
                      // "ON",
                      style: TextStyle(
                          color: black,
                          fontSize: size_6,
                          fontStyle: FontStyle.normal,
                          fontWeight: regularWeight))
                  : Text('off'.tr,
                      // "OFF",
                      style: TextStyle(
                          color: black,
                          fontSize: size_6,
                          fontStyle: FontStyle.normal,
                          fontWeight: regularWeight)),
              Spacer(),
              Container(
                height: 30,
                width: 40,
                alignment: Alignment.centerLeft,
                child: (widget.gpsData.rssi == -1)
                    ? Image(
                        width: 30,
                        image: AssetImage("assets/icons/signalIconNothing.png"),
                      )
                    : (widget.gpsData.rssi == 0)
                        ? Image(
                            width: 40,
                            image:
                                AssetImage("assets/icons/signalIconZero.png"),
                          )
                        : (widget.gpsData.rssi == 1)
                            ? Image(
                                width: 30,
                                image: AssetImage(
                                    "assets/icons/signalIconOne.png"),
                              )
                            : (widget.gpsData.rssi == 2)
                                ? Image(
                                    width: 30,
                                    image: AssetImage(
                                        "assets/icons/signalIconTwo.png"),
                                  )
                                : (widget.gpsData.rssi == 3)
                                    ? Image(
                                        width: 30,
                                        image: AssetImage(
                                            "assets/icons/signalIconThree.png"),
                                      )
                                    : (widget.gpsData.rssi == 4 ||
                                            widget.gpsData.rssi == 5)
                                        ? Image(
                                            width: 30,
                                            image: AssetImage(
                                                "assets/icons/signalIconFour.png"),
                                          )
                                        : Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.device.attributes!.expirationTime == null) {
      expired = true;
    } else {
      expiryDate =
          DateFormat('y-M-d').parse(widget.device.attributes!.expirationTime!);
      expired = expiryDate.isBefore(timeNow);
    }
    print(expired);
    if (widget.status == 'Online') {
      online = true;
    } else {
      online = false;
    }
    if(widget.device.lastUpdate != null){
      lastupdated =
          getStopDuration(widget.device.lastUpdate!, now.toIso8601String());
      lastupdated2 =
          getStopDuration2(widget.device.lastUpdate!, now.toIso8601String());
    }else{
      lastUpdate = false;
    }
    return Container(
      color: Color(0xffF7F8FA),
      margin: EdgeInsets.only(bottom: space_2),
      child: GestureDetector(
        onTap: () async {
          expired ? openCheckout()
          : Get.to(
            TrackScreen(
              deviceId: widget.gpsData.deviceId,
              gpsData: widget.gpsData,
              truckNo: widget.truckno,
              totalDistance: totalDistance,
              active: online,
              online: online,
              // imei: widget.imei,
            ),
          );
        },
        child: Card(
          elevation: 5,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(space_3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                  ),
                  child:TruckCard(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  initfunction() async {
    var gpsRoute1 = await mapUtil.getTraccarSummary(
        deviceId: widget.gpsData.deviceId, from: from, to: to);
    setState(() {
      totalDistance = (gpsRoute1[0].distance / 1000).toStringAsFixed(2);
    });
    print('in init');
  }
}
