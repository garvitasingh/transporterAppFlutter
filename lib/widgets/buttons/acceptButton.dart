import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/bidApiCalls.dart';

// ignore: must_be_immutable
class AcceptButton extends StatelessWidget {

  String? bidId;

  AcceptButton({required this.bidId});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 31,
      // width: 80,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )),
          backgroundColor: MaterialStateProperty.all<Color>(liveasyGreen),
        ),
        onPressed: () {
          print('Accept Button Pressed');
          putBidForAccept(bidId);
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: space_1 , horizontal: space_3),
          child : Text(
            'Accept',
            style: TextStyle(
              letterSpacing: 0.7,
              fontWeight: mediumBoldWeight,
              color: white,
              fontSize: size_7,
            ),
          ),
        ),
      ),
    );
  }
}
