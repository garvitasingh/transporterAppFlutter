import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';

// ignore: must_be_immutable
class AutoFillDataDisplayCard extends StatelessWidget {
  String placeMain;
  String placeName;
  String placeCity;
  String placeAddress;
  var onTap;

  AutoFillDataDisplayCard(
      this.placeMain,
      this.placeName,
    this.placeCity,
    this.placeAddress,
    this.onTap,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: space_12,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.symmetric(
            horizontal: BorderSide(
              width: 0.5,
              color: greyBorderColor,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: space_1),
                child: Icon(
                  Icons.location_on_outlined,
                  color: darkBlueColor,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // height: 170,
                      child: Text(
                        '''$placeAddress''',
                          maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: size_7, color: liveasyBlackColor),
                      ),
                    ),
                    Container(
                      child: Text(
                        '''$placeName''',
                        style: TextStyle(fontSize: size_6, color: darkGreyColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
