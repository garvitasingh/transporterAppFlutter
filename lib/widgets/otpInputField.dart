import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/hudController.dart';
import 'package:liveasy/controller/isOtpInvalidController.dart';
import 'package:liveasy/functions/authFunctions.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:visibility_aware_state/visibility_aware_state.dart';
import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPInputField extends StatefulWidget {
  String _verificationCode = '';
  // String autoVerificationCode = '';

  OTPInputField(this._verificationCode);
  @override
  _OTPInputFieldState createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OTPInputField> {
  HudController hudController = Get.put(HudController());
  AuthService authService = AuthService();
  IsOtpInvalidController isOtpInvalidController =
      Get.put(IsOtpInvalidController());
  TextEditingController textEditingController = TextEditingController();
  String _comingSms = 'Unknown';

  Future<void> initSmsListener() async {
    String? comingSms;
    try {
      comingSms = await AltSmsAutofill().listenForSms;
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;
    setState(() {
      textEditingController.clear();
      _comingSms = comingSms!;

      textEditingController.text = _comingSms[0] +
          _comingSms[1] +
          _comingSms[2] +
          _comingSms[3] +
          _comingSms[4] +
          _comingSms[
              5]; //used to set the code in the message to a string and setting it to a textcontroller. message length is 38. so my code is in string index 32-37.
    });
  }

  @override
  void dispose() {
    //textEditingController.dispose();
    AltSmsAutofill().unregisterListener();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initSmsListener();
  }

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: PinCodeTextField(
        cursorColor: Colors.black,
        appContext: context,
        controller: textEditingController,
        pastedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat'),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10),
          activeFillColor: Colors.white,
          activeColor: Colors.black,
          inactiveColor: Colors.black,
          selectedFillColor: Colors.white,
          selectedColor: Colors.black,
          inactiveFillColor: Colors.white,
          fieldHeight: 48,
          fieldWidth: 48,
        ),
        length: 6,
        enableActiveFill: true,
        keyboardType: TextInputType.phone,
        onCompleted: (pin) {
          hudController.updateHud(true);
          providerData.updateSmsCode(pin);
          // isOtpInvalidController.updateIsOtpInvalid(false);
          authService.manualVerification(
              smsCode: providerData.smsCode,
              verificationId: widget._verificationCode);

          providerData.updateInputControllerLengthCheck(true);
          providerData.clearAll();
        },
        onChanged: (value) {
          setState(() {});
          // if (value.length == 6) {
          //   isOtpInvalidController.updateIsOtpInvalid(false);
          // }
          print("changed to - $value");
        },
      ),
    );
  }
}
