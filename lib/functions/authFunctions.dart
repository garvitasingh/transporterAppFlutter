import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/controller/hudController.dart';
import 'package:liveasy/controller/isOtpInvalidController.dart';
import 'package:liveasy/controller/timerController.dart';
import 'package:liveasy/functions/trasnporterApis/runTransporterApiPost.dart';
import 'package:liveasy/screens/languageSelectionScreen.dart';
import 'package:liveasy/screens/LoginScreens/loginScreen.dart';
import 'package:liveasy/screens/navigationScreen.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';

class AuthService {
  HudController hudController = Get.put(HudController());
  TimerController timerController = Get.put(TimerController());
  IsOtpInvalidController isOtpInvalidController =
      Get.put(IsOtpInvalidController());

  Future signOut() async {
    try {
      Get.to(() => LoginScreen());
      return FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void manualVerification({String? verificationId, String? smsCode}) async {
    print('verificationId in manual func: $smsCode');
    try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verificationId!, smsCode: smsCode!))
          .then((value) async {
        if (value.user != null) {
          print('hud false due to try in manual verification');
          hudController.updateHud(false);
          timerController.cancelTimer();

          await runTransporterApiPost(
              mobileNum: value.user!.phoneNumber!.toString().substring(3, 13));

          Get.offAll(() => NavigationScreen());
        }
      });
    } on FirebaseAuthException catch (e) {
      // FocusScope.of(context).unfocus();
      print("---------------------->${e.code}");
      if (e.code == "session-expired") {
        hudController.updateHud(false);
        isOtpInvalidController.updateIsOtpInvalid(false);
        print("---------------------------------->hi");
      } else {
        print('hud false due to catch in manual verification');

        hudController.updateHud(false);
        // Get.to(() => NewLoginScreen());
        isOtpInvalidController.updateIsOtpInvalid(true);
      }
      // Get.snackbar('Invalid Otp', 'Please Enter the correct OTP',
      //     colorText: white, backgroundColor: black_87);
    }
  }
}
