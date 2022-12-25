import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

class DeviceModel {
  int? deviceId;
  Attributes? attributes;
  int? groupId;
  String? truckno;
  String? imei;
  String? status;
  String? lastUpdate;
  int? positionId;
  List<Null>? geofenceIds;
  String? phone;
  String? model;
  String? contact;
  String? category;
  bool? disabled;

  DeviceModel(
      {this.deviceId,
        this.attributes,
        this.groupId,
        this.truckno,
        this.imei,
        this.status,
        this.lastUpdate,
        this.positionId,
        this.geofenceIds,
        this.phone,
        this.model,
        this.contact,
        this.category,
        this.disabled});

  DeviceModel.fromJson(Map<String, dynamic> json) {
    deviceId = json['id'];
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
    groupId = json['groupId'];
    truckno = json['name'];
    imei = json['uniqueId'];
    status = json['status'];
    lastUpdate = json['lastUpdate'];
    positionId = json['positionId'];
    // if (json['geofenceIds'] != null) {
    //   geofenceIds = <Null>[];
    //   json['geofenceIds'].forEach((v) {
    //     geofenceIds!.add(new Null.fromJson(v));
    //   });
    // }
    phone = json['phone'];
    model = json['model'];
    contact = json['contact'];
    category = json['category'];
    disabled = json['disabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.deviceId;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    data['groupId'] = this.groupId;
    data['name'] = this.truckno;
    data['uniqueId'] = this.imei;
    data['status'] = this.status;
    data['lastUpdate'] = this.lastUpdate;
    data['positionId'] = this.positionId;
    // if (this.geofenceIds != null) {
    //   data['geofenceIds'] = this.geofenceIds!.map((v) => v.toJson()).toList();
    // }
    data['phone'] = this.phone;
    data['model'] = this.model;
    data['contact'] = this.contact;
    data['category'] = this.category;
    data['disabled'] = this.disabled;
    return data;
  }
}

class Attributes {
  double? speedLimit;
  int? deviceInactivityStart;
  int? deviceInactivityPeriod;
  String? engineStatus;
  String? passingWeight;
  String? isSubscribed;
  String? expirationTime;

  Attributes(
      {this.speedLimit,
        this.deviceInactivityStart,
        this.deviceInactivityPeriod,
        this.engineStatus,
        this.passingWeight,
        this.isSubscribed,
        this.expirationTime});

  Attributes.fromJson(Map<String, dynamic> json) {
    speedLimit = json['speedLimit'];
    deviceInactivityStart = json['deviceInactivityStart'];
    deviceInactivityPeriod = json['deviceInactivityPeriod'];
    engineStatus = json['engine_status'];
    passingWeight = json['Passing Weight '];
    isSubscribed = json['isSubscribed'];
    expirationTime = json['expirationTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['speedLimit'] = this.speedLimit;
    data['deviceInactivityStart'] = this.deviceInactivityStart;
    data['deviceInactivityPeriod'] = this.deviceInactivityPeriod;
    data['engine_status'] = this.engineStatus;
    data['Passing Weight '] = this.passingWeight;
    data['isSubscribed'] = this.isSubscribed;
    data['expirationTime'] = this.expirationTime;
    return data;
  }
}

