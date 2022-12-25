import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

putDocumentApiCall(Map datanew2, String bookingId) async {
  // TransporterIdController tIdController = Get.find<TransporterIdController>();
  // String now = DateFormat("dd-MM-yyyy").format(DateTime.now());
  // String now = DateFormat("dd-MM-yyyy").format(DateTime.now().subtract(Duration(hours: 5, minutes: 30))
  //     .toIso8601String());
  var jsonData;
  try {
    // Map datanew = {
    //   // "entityId": bookingId,
    //   "documents": [
    //     {"documentType": documentType, "data": photo64code}
    //   ],
    // };

    String body = json.encode(datanew2);
    print(body);
    final String documentApiUrl =
        FlutterConfig.get('documentApiUrl').toString();
    final response = await http.put(Uri.parse("$documentApiUrl/$bookingId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    print(response.body);
    jsonData = json.decode(response.body);

    // if (jsonData["bookingId"] != null) {
    //   Get.snackbar('Booking Successful', '', snackPosition: SnackPosition.TOP);
    // } else
    //   Get.snackbar('Booking Unsuccessful', '',
    //       snackPosition: SnackPosition.TOP);
    if (response.statusCode == 201 || response.statusCode == 200) {
      print(response);
      return "successful";
    } else if (response.statusCode == 409) {
      print("conflict");
      return "conflict";
    } else {
      return "unsuccessful";
    }
  } catch (e) {
    print(e.toString());
    return e.toString();
  }
}
