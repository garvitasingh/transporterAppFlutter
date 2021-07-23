import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/loadPosterModel.dart';
//duplicate file ig can be deleted later
getLoadPosterDetailsFromApi({required String loadPosterId}) async {

  var jsonData;

  final String transporterApiUrl = FlutterConfig.get('transporterApiUrl').toString();
  final String shipperApiUrl = FlutterConfig.get('shipperApiUrl').toString();

  // loadPosterId = loadPosterId;
  try {
    if (loadPosterId.contains("transporter")) {
      http.Response response =  await http.get(Uri.parse(transporterApiUrl + "/$loadPosterId"));

      jsonData = json.decode(response.body);

      LoadPosterModel loadPosterModel = LoadPosterModel();
      loadPosterModel.loadPosterId = jsonData["transporterId"] != null ? jsonData["transporterId"] : 'NA' ;
      loadPosterModel.loadPosterPhoneNo = jsonData["phoneNo"] != null ? jsonData["phoneNo"] : 'NA' ;
      loadPosterModel.loadPosterLocation = jsonData["transporterLocation"] != null ? jsonData["transporterLocation"] : 'NA' ;
      loadPosterModel.loadPosterName = jsonData["transporterName"] != null ? jsonData["transporterName"] : 'NA' ;
      loadPosterModel.loadPosterCompanyName = jsonData["companyName"] != null ? jsonData["companyName"] : 'NA' ;
      loadPosterModel.loadPosterKyc = jsonData["kyc"] != null ? jsonData["kyc"] : 'NA' ;
      loadPosterModel.loadPosterCompanyApproved =   jsonData["companyApproved"];
      loadPosterModel.loadPosterApproved = jsonData["transporterApproved"];
      loadPosterModel.loadPosterAccountVerificationInProgress =  jsonData["accountVerificationInProgress"];
      return loadPosterModel;
    }
    if (loadPosterId.contains("shipper")) {
      http.Response response =  await http.get(Uri.parse(shipperApiUrl + "/$loadPosterId"));

      jsonData = json.decode(response.body);

      LoadPosterModel loadPosterModel = LoadPosterModel();
      loadPosterModel.loadPosterId = jsonData["shipperId"] != null ? jsonData["shipperId"] : 'NA' ;
      loadPosterModel.loadPosterName = jsonData["shipperName"] != null ? jsonData["shipperName"] : 'NA' ;
      loadPosterModel.loadPosterCompanyName = jsonData["companyName"] != null ? jsonData["companyName"] : 'NA' ;
      loadPosterModel.loadPosterPhoneNo = jsonData["phoneNo"] != null ? jsonData["phoneNo"] : 'NA' ;
      loadPosterModel.loadPosterKyc = jsonData["kyc"] != null ? jsonData["kyc"] : 'NA' ;
      loadPosterModel.loadPosterLocation = jsonData["shipperLocation"];
      loadPosterModel.loadPosterCompanyApproved = jsonData["companyApproved"];
      loadPosterModel.loadPosterAccountVerificationInProgress =  jsonData["accountVerificationInProgress"];
      return loadPosterModel;
    }
  } catch (e) {
    print(e);
  }
}
