import 'dart:convert';

import 'package:liveasy/functions/googleAutoCorrectionApi.dart';
import 'package:liveasy/models/autoFillMMIModel.dart';
import '../googleAutoCorrectionApi.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

String kGoogleApiKey = FlutterConfig.get('mapKey').toString();

Future<List<AutoFillMMIModel>> fillCityGoogle(String cityName) async{
  var request = http.Request('GET', Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?'
      'input=$cityName&types=establishment&language=en&components=country:in&key=$kGoogleApiKey'));

  http.StreamedResponse response = await request.send();
  List<AutoFillMMIModel> card = [];
  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    var res=await response.stream.bytesToString();
    var address = json.decode(res);
    address = address["predictions"];
// print(address);
    for (var json in address) {
      print(json["description"]);
      List<String> result=json["description"]!.split(",");
      int resultLength = 0;
      for (var r in result) {
        resultLength++;
        r = r.trimLeft();
        r = r.trimRight();
        print(r);
      }
      AutoFillMMIModel locationCardsModal = new AutoFillMMIModel(
        placeName: "${ result[0].toString()}",
          placeCityName:"${ result[resultLength - 3].toString()}",
          // placeStateName: json["placeAddress"]\
          placeStateName:  "${result[resultLength - 2].toString()}"
      );
      card.add(locationCardsModal);
    }
    return card;
  }else{
    List<AutoFillMMIModel> card = [];
    return card;
  }
}
