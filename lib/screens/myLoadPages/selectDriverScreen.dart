import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/screens/myLoadPages/addNewDriver.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:flutter_config/flutter_config.dart';
import '../../constants/fontSize.dart';
import '../../constants/fontWeights.dart';
import '../../constants/radius.dart';
import '../../constants/spaces.dart';
import '../../functions/BackgroundAndLocation.dart';
import '../../models/biddingModel.dart';
import '../../models/loadDetailsScreenModel.dart';
import 'confirmBookingDetails.dart';

class SelectDriverScreen extends StatefulWidget {
  // const SelectDriverScreen({Key? key}) : super(key: key);

  LoadDetailsScreenModel loadDetailsScreenModel;
  BiddingModel? biddingModel;
  bool? directBooking;
  String? postLoadId;
  String? driverName, driverPhoneNo;
  String? selectedTruck;
  int? selectedDeviceId;

  SelectDriverScreen(
      {this.postLoadId,
      required this.loadDetailsScreenModel,
      this.biddingModel,
      this.selectedTruck,
      this.selectedDeviceId,
      required this.directBooking});

  @override
  State<SelectDriverScreen> createState() => _SelectDriverScreenState();
}

class _SelectDriverScreenState extends State<SelectDriverScreen> {
  bool isSelected = false;
  String searchedDriver = "";
  late String selectedDriver;
  int selectedIndex = -1;
  List driverList = [];
  List searchedDriverList = [];
  List searchedDriverListNumber = [];
  List driverNames = [];
  List driverMobileNumbers = [];
  late String selectedDriverPhoneNumber;

  getDriverData() async {
    print("HI");
    driverMobileNumbers.clear();
    driverNames.clear();
    String driverApiUrl = FlutterConfig.get("driverApiUrl").toString();
    var jsonData;
    String? traccarUser = transporterIdController.mobileNum.value;
    String traccarPass = FlutterConfig.get("traccarPass");
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));
    http.Response response = await http.get(
      Uri.parse("$driverApiUrl/api/drivers"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': basicAuth,
      },
    );
    jsonData = await jsonDecode(response.body);
    for (var json in jsonData) {
      setState(() {
        driverList.add(json);
        driverNames.add(json["name"]);
        driverMobileNumbers.add(json["uniqueId"]);
      });
    }
    print(driverList);
    print("hi");
    // print(driverNames);
    // print(driverMobileNumbers);
  }

  void searchoperation(String searchText) {
// searchresult. clear() ;
    if (searchText != null) {
      searchedDriverList.clear();
      for (int i = 0; i < driverList.length; i++) {
        String data = driverNames[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          setState(() {
            print(searchText);
            searchedDriverList.add(data);
            searchedDriverListNumber.add(driverMobileNumbers[i]);
          });
        }
        // else {
        //   searchedTruckList.add("");
        // }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getDriverData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: statusBarColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        width: 130,
        height: space_9 + 1,
        child: FloatingActionButton(
          child: Text(
            "Confirm",
            style: TextStyle(
                color: white,
                fontWeight: mediumBoldWeight,
                fontSize: size_8 + 2),
          ),
          onPressed: isSelected
              ? () => {
                    print(widget.loadDetailsScreenModel),
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: ((context) {
                      return ConfirmBookingDetails(
                        selectedTruck: widget.selectedTruck,
                        selectedDeviceId: widget.selectedDeviceId,
                        driverName: selectedDriver,
                        mobileNo: selectedDriverPhoneNumber,
                        loadDetailsScreenModel: widget.loadDetailsScreenModel,
                        directBooking: true,
                      );
                    }))),
                  }
              : () => {getDriverData()},
          backgroundColor: darkBlueColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius_4)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: space_2),
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: space_4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BackButtonWidget(),
                        SizedBox(
                          width: space_3,
                        ),
                        HeadingTextWidget("Select Driver"),
                        SizedBox(
                          width: space_6,
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddNewDriver(
                                  selectedTruck: widget.selectedTruck,
                                  selectedDeviceId: widget.selectedDeviceId,
                                  loadDetailsScreenModel:
                                      widget.loadDetailsScreenModel,
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.add,
                            color: const Color(0xFF152968),
                          ),
                          label: Text(
                            "Add Driver",
                            style: TextStyle(
                                color: const Color(0xFF152968),
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: space_3,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: space_3, horizontal: space_3),
                      child: Container(
                        height: space_11,
                        decoration: BoxDecoration(
                          color: widgetBackGroundColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 0.8, color: widgetBackGroundColor),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchedDriver = value;
                            });
                            print(value);
                            searchoperation(searchedDriver);
                            selectedDriver = "";
                            selectedIndex = -1;
                          },
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'searchByName',
                            icon: Padding(
                              padding: EdgeInsets.only(left: space_2),
                              child: Icon(
                                Icons.search,
                                color: grey,
                              ),
                            ),
                            hintStyle: TextStyle(
                              fontSize: size_8,
                              color: grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    searchedDriver.length != 0
                        ? SingleChildScrollView(
                            child: Container(
                              height: MediaQuery.of(context).size.height / 1.5,
                              child: ListView.builder(
                                itemCount: searchedDriverList.length,
                                itemBuilder: ((context, index) {
                                  return InkWell(
                                    splashColor: Colors.white,
                                    onTap: () {
                                      setState(() {
                                        isSelected = true;
                                        selectedIndex = index;
                                        selectedDriver =
                                            searchedDriverList[index];
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: space_8,
                                                  right: space_5,
                                                  bottom: space_4,
                                                  top: space_3),
                                              child: !(index == selectedIndex)
                                                  ? Container(
                                                      // color: grey,
                                                      height: 15,
                                                      width: 15,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              space_2,
                                                              space_2,
                                                              0,
                                                              0),
                                                      decoration: BoxDecoration(
                                                        // color: grey,
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/icons/deepbluecircle_ic.png"),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      // color: grey,
                                                      height: 25,
                                                      width: 25,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              space_2,
                                                              space_2,
                                                              0,
                                                              0),
                                                      decoration: BoxDecoration(
                                                        // color: grey,
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/icons/greencheckcircle_ic.png"),
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            // setState
                                            // changes(),
                                            Text(
                                              "${searchedDriverList[index]} - ${searchedDriverListNumber[index]}",
                                              style: TextStyle(
                                                fontSize: size_10,
                                                fontWeight: mediumBoldWeight,
                                                color: black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: space_5, right: space_5),
                                          child: Divider(
                                            height: size_10,
                                            color: grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Container(
                              height: MediaQuery.of(context).size.height / 1.5,
                              child: ListView.builder(
                                itemCount: driverList.length,
                                itemBuilder: ((context, index) {
                                  return InkWell(
                                    splashColor: Colors.white,
                                    onTap: () {
                                      setState(() {
                                        isSelected = true;
                                        selectedIndex = index;
                                        selectedDriver = driverNames[index];
                                        selectedDriverPhoneNumber =
                                            driverMobileNumbers[index];
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: space_8,
                                                  right: space_5,
                                                  bottom: space_4,
                                                  top: space_3),
                                              child: (index != selectedIndex)
                                                  ? Container(
                                                      // color: grey,
                                                      height: 15,
                                                      width: 15,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              space_2,
                                                              space_2,
                                                              0,
                                                              0),
                                                      decoration: BoxDecoration(
                                                        // color: grey,
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/icons/deepbluecircle_ic.png"),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      // color: grey,
                                                      height: 25,
                                                      width: 25,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              space_2,
                                                              space_2,
                                                              0,
                                                              0),
                                                      decoration: BoxDecoration(
                                                        // color: grey,
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/icons/greencheckcircle_ic.png"),
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            // setState
                                            // changes(),
                                            Text(
                                              "${driverNames[index]} - ${driverMobileNumbers[index]}",
                                              style: TextStyle(
                                                fontSize: size_10,
                                                fontWeight: mediumBoldWeight,
                                                color: black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: space_5, right: space_5),
                                          child: Divider(
                                            height: size_10,
                                            color: grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
