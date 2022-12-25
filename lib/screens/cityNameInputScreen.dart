import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/placeAutoFillUtils/autoFillGoogle.dart';
import 'package:liveasy/functions/placeAutoFillUtils/autoFillMMI.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/widgets/autoFillDataDisplayCard.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';
import 'package:liveasy/widgets/textFieldWidget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';

import '../functions/placeAutoFillUtils/autoFillRapidSpott.dart';
import 'package:liveasy/widgets/cancelIconWidget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CityNameInputScreen extends StatefulWidget {
  final String page;
  final String valueType;

  CityNameInputScreen(this.page, this.valueType);

  @override
  _CityNameInputScreenState createState() => _CityNameInputScreenState();
}

class _CityNameInputScreenState extends State<CityNameInputScreen> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    getMMIToken();
    _initSpeech();
  }

  var locationCard;
  TextEditingController controller = TextEditingController();

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      controller = TextEditingController(
          text: _lastWords);
      if (widget.page == "postLoad") {
        locationCard = fillCityGoogle(controller.text); //google place api is used in postLoad
      } else {
        locationCard = fillCity(controller.text);}
    });
  }

  @override
  Widget build(BuildContext context) {
    double keyboardLength = MediaQuery.of(context).viewInsets.bottom;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: space_4),
          child: ListView(
            children: [
              SizedBox(
                height: space_6,
              ),
              Container(
                child: Row(
                  children: [
                    BackButtonWidget(),
                    SizedBox(
                      width: space_2,
                    ),
                    Expanded(
                        // child: CustomTextField(
                        //   hintText: "Select starting point",
                        //   textController: controller,
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => MapBoxAutoCompleteWidget(
                        //           apiKey: "pk.eyJ1IjoiZ2Fydml0YTkzNiIsImEiOiJjbDg0ZWNwZXkwMmJmM3ZwNWFzbnJpcXNlIn0.8WpvYsCUf889t6-nGoc4cA",
                        //           hint: "Select starting point",
                        //           onSelect: (place) {
                        //             // TODO : Process the result gotten
                        //             controller.text = place.placeName!;
                        //           },
                        //           limit: 10,
                        //           country: "IN",
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   enabled: true,
                        // ),

                        child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: liveasyBlackColor, width: 0.8),
                        borderRadius: BorderRadius.circular(30),
                        color: widgetBackGroundColor,
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        autofocus: true,
                        controller: controller,
                        // onChanged: widget.onChanged,
                        onChanged: (String value) {
                          setState(() {
                            if (widget.page == "postLoad") {
                              locationCard = fillCityGoogle(
                                  value); //google place api is used in postLoad
                            } else {
                              locationCard = fillCity(
                                  value); //return auto suggested places using rapid api
                            }
                            // locationCard = fillCityName(value);    //return auto suggested places using MapMyIndia api
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: 'enterCityName'.tr,
                          prefixIcon: GestureDetector(
                              onTap: _speechToText.isNotListening
                                  ? _startListening
                                  : _stopListening,
                              child: Icon(_speechToText.isNotListening
                                  ? Icons.mic_off
                                  : Icons.mic)),
                          suffixIcon: IconButton(
                              onPressed: () {
                                controller.clear();
                              },
                              icon: CancelIconWidget()),
                        ),
                      ),
                    )
                        // child: TextFieldWidget(
                        //     onChanged: (String value) {
                        //       setState(() {
                        //         if(widget.page=="postLoad"){
                        //           locationCard=fillCityGoogle(value);    //google place api is used in postLoad
                        //         }else{
                        //           locationCard=fillCity(value);        //return auto suggested places using rapid api
                        //         }
                        //         // locationCard = fillCityName(value);    //return auto suggested places using MapMyIndia api
                        //       });
                        //     },
                        //     hintText: 'enterCityName'.tr
                        //     // AppLocalizations.of(context)!.enterCityName,
                        //     ),

                        ),
                  ],
                ),
              ),
              locationCard == null
                  ? Container()
                  : SizedBox(
                      height: space_4,
                    ),
              locationCard != null
                  ? Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      height: keyboardLength != 0
                          ? screenHeight - keyboardLength - 130
                          : screenHeight - 130, //TODO: to be modified
                      child: FutureBuilder(
                          future: locationCard,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return Container();
                            }
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              reverse: false,
                              // padding: EdgeInsets.symmetric(
                              //   horizontal: space_2,
                              // ),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) =>
                                  AutoFillDataDisplayCard(
                                    snapshot.data[index].placeMain,
                                    snapshot.data[index].placeName,
                                      snapshot.data[index].placeCityName,
                                      snapshot.data[index].placeStateName, () {
                                if (widget.valueType == "Loading Point") {
                                  Provider.of<ProviderData>(context,
                                          listen: false)
                                      .updateLoadingPointFindLoad(
                                    place: snapshot.data[index].placeName,
                                          city: snapshot
                                              .data[index].placeCityName,
                                          state: snapshot
                                              .data[index].placeStateName);
                                  Get.back();
                                } else if (widget.valueType ==
                                    "Unloading Point") {
                                  Provider.of<ProviderData>(context,
                                          listen: false)
                                      .updateUnloadingPointFindLoad(
                                      place: snapshot.data[index].placeName,
                                          city: snapshot
                                              .data[index].placeCityName,
                                          state: snapshot
                                              .data[index].placeStateName);
                                  // Get.off(FindLoadScreen());
                                  Get.back();
                                } else if (widget.valueType ==
                                    "Loading point") {
                                  Provider.of<ProviderData>(context,
                                          listen: false)
                                      .updateLoadingPointPostLoad(
                                      place: snapshot.data[index].placeName,
                                          city: snapshot
                                              .data[index].placeCityName,
                                          state: snapshot
                                              .data[index].placeStateName);
                                  Get.back();
                                } else if (widget.valueType ==
                                    "Unloading point") {
                                  Provider.of<ProviderData>(context,
                                          listen: false)
                                      .updateUnloadingPointPostLoad(
                                      place: snapshot.data[index].placeName,
                                          city: snapshot
                                              .data[index].placeCityName,
                                          state: snapshot
                                              .data[index].placeStateName);
                                  Get.back();
                                }
                              }),
                            );
                          }),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
