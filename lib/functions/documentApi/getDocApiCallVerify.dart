import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

getDocApiCallVerify(String bookingId, String docType) async {
  var jsonData;
  try {
    final String documentApiUrl =
        FlutterConfig.get('documentApiUrl').toString();
    final response = await http.get(Uri.parse("$documentApiUrl/$bookingId"));

    print(response.body);
    jsonData = json.decode(response.body);
    print(response.body);
    for (var jsondata in jsonData["documents"]) {
      print(jsondata["documentType"]);
      if (jsondata["documentType"][0] == docType) {
        if (jsondata["verified"] == false) {
          return false;
        }
      }
    }

    return true;
  } catch (e) {
    print(e.toString());
    return e.toString();
  }
}
