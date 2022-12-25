import 'package:flutter/material.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/cityNameInputScreen.dart';
import 'package:get/get.dart';
import 'package:liveasy/widgets/cancelIconWidget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';

// ignore: must_be_immutable
class AddressInputMMIWidget extends StatelessWidget {
  final String page;
  final String hintText;
  final Widget icon;
  final TextEditingController controller;
  var onTap;

  AddressInputMMIWidget(
      {required this.page,
      required this.hintText,
      required this.icon,
      required this.controller,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    late String value;
    ProviderData providerData = Provider.of<ProviderData>(context);
    // return Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(space_6),
    //     border: Border.all(color: darkBlueColor, width: borderWidth_8),
    //     color: widgetBackGroundColor,
    //   ),
    //   padding: EdgeInsets.symmetric(horizontal: space_3),
    //   child: TextFormField(
    //     readOnly: true,
    //     onTap: () {
    //
    //       providerData.updateResetActive(true);
    //
    //       FocusScope.of(context).requestFocus(FocusNode());
    //       // MapBox api is used for autosuggestion but city data is too less for use in india
    //       // Navigator.push(
    //       //   context,
    //       //   MaterialPageRoute(
    //       //     builder: (context) => MapBoxAutoCompleteWidget(
    //       //       apiKey: "pk.eyJ1IjoiZ2Fydml0YTkzNiIsImEiOiJjbDg0ZWNwZXkwMmJmM3ZwNWFzbnJpcXNlIn0.8WpvYsCUf889t6-nGoc4cA",
    //       //       hint: 'enterCityName'.tr,
    //       //       onSelect: (place) {
    //       //         controller.text = place.placeName!;
    //       //       },
    //       //       country: "IND",
    //       //       limit: 10,
    //       //       // location: Location(78.96,20.59),
    //       //       closeOnSelect: true,
    //       //     ),
    //       //   ),
    //       // );
    //       Get.to(() => CityNameInputScreen(page,hintText));   // for MapMyIndia api
    //     },
    //     controller: controller,
    //     decoration: InputDecoration(
    //       hintText: hintText,
    //       icon: icon,
    //     suffixIcon: GestureDetector(onTap: onTap, child: CancelIconWidget()),
    //     ),
    //   ),
    // );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space_6),
        border: Border.all(color: darkBlueColor, width: borderWidth_8),
        color: widgetBackGroundColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: space_3),
      child: TextFormField(
        readOnly: true,
        onTap: () async {
          providerData.updateResetActive(true);
          FocusScope.of(context).requestFocus(FocusNode());
          value = await Get.to(
              () => CityNameInputScreen(page, hintText)); // for MapMyIndia api
        },
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          icon: icon,
          suffixIcon: GestureDetector(onTap: onTap, child: CancelIconWidget()),
        ),
      ),
    );
  }
}
