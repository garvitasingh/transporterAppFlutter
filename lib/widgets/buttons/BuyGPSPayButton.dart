import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/buyGPSboolController.dart';
import 'package:liveasy/functions/buyGPSApiCalls.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:liveasy/screens/buyGpsScreen.dart';
import 'package:liveasy/screens/home.dart';
import 'package:liveasy/widgets/alertDialog/CompletedDialog.dart';
import 'package:liveasy/widgets/alertDialog/sameTruckAlertDialogBox.dart';
import 'package:liveasy/controller/transporterIdController.dart';

import '../../functions/deviceApiCalls.dart';

class BuyGPSPayButton extends StatefulWidget {
  String? groupValue;
  String? durationGroupValue;
  bool locationPermissionis;
  String? currentAddress;
  String? truckID;
  var truckDataList =[];
  var context;

  BuyGPSPayButton({
    Key? key,
    required this.groupValue,
    required this.durationGroupValue,
    required this.locationPermissionis,
    required this.currentAddress,
    required this.truckID,
    required this.truckDataList,
    required this.context
  }) : super(key: key);

  @override
  State<BuyGPSPayButton> createState() => _BuyGPSPayButtonState();
}

class _BuyGPSPayButtonState extends State<BuyGPSPayButton> {
  bool isDisable = false;
  BuyGPSHudController updateButtonController = Get.put(BuyGPSHudController());
  final String buyGPSApiUrl = FlutterConfig.get('buyGPSApiUrl');
  BuyGPSApiCalls buyGPSApiCalls = BuyGPSApiCalls();
  String? gpsId;
  late   var _razorpay;
  TransporterIdController transporterIdController =
  Get.find<TransporterIdController>();

  @override
  void initState() {
    // TODO: implement initState
    // subscribeDevice();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  subscribeDevice() async{
    DeviceApiCalls DeviceApi=DeviceApiCalls();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_yidaXokSvDVva8',
      'amount':int.parse(widget.groupValue!) * 100,
      'description': 'Payment',
      'prefill': {'contact': transporterIdController.mobileNum.value,},
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
   subscribeDevice();
    showDialog(
        context: context,
        builder: (context) =>
            completedDialog(
              upperDialogText: "You’ve purchased GPS",
              lowerDialogText: "successfully!",
            )
    );
    Timer(Duration(seconds: 3),
            () => {Get.back()});
    print("Payment Done");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Fail");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: space_8,
      width: (space_20 + space_40),
      margin: EdgeInsets.only(bottom: space_2),
      child: Obx(() => TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      isDisable
                          ? bidBackground
                          : updateButtonController.updateButton.value
                          ? bidBackground
                          : solidLineColor
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radius_6)
                      )
                  )
              ),
              onPressed: updateButtonController.updateButton.value
                  ? (){
                openCheckout();
              }
                  // () => _payButtonFunction()
                  : null,
              child: updateButtonController.updateButton.value
                  ? Text(
                "Pay ${widget.groupValue}",
                style: TextStyle(
                  color: greyishWhiteColor,
                  fontWeight: mediumBoldWeight,
                  fontSize: size_9,
                ),
                textAlign: TextAlign.center,
              )
                  : Text(
                "Pay NA",
                style: TextStyle(
                  color: greyishWhiteColor,
                  fontWeight: mediumBoldWeight,
                  fontSize: size_9,
                ),
                textAlign: TextAlign.center,
              )
          ),
      ),
    );
  }

  _payButtonFunction() async {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..maskColor = darkBlueColor
      ..userInteractions = false
      ..backgroundColor = darkBlueColor
      ..dismissOnTap = false;
    EasyLoading.show(
      status: "Loading...",
    );
    gpsId = await buyGPSApiCalls.postByGPSData(
        rate: widget.groupValue,
        duration: widget.durationGroupValue,
        address: widget.locationPermissionis
            ? widget.currentAddress
            : "Location not Available",
        truckId: widget.truckID);
    if (gpsId != null) {
      EasyLoading.dismiss();
      showDialog(
          context: context,
          builder: (context) =>
              completedDialog(
            upperDialogText: "You’ve purchased GPS",
            lowerDialogText: "successfully!",
          )
      );
      Timer(Duration(seconds: 3),
              () => {Get.back()});
    } else {
      EasyLoading.dismiss();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return SameTruckAlertDialogBox();
          });
    }
  }
}
