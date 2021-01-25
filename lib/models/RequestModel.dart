// To parse this JSON data, do
//
//     final requestModel = requestModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

RequestModel requestModelFromJson(String str) => RequestModel.fromJson(json.decode(str));

String requestModelToJson(RequestModel data) => json.encode(data.toJson());

class RequestModel {
  RequestModel({
    this.requesterId,
    this.requesterName,
    this.requesterImage,
    this.helperId,
    this.reqStatus,
    this.requesterCalledOff,
    this.expireDate,
    this.helperAndRequester,
  });

  String requesterId;
  String requesterName;
  String requesterImage;
  String helperId;
  String reqStatus;
  bool requesterCalledOff;
  Timestamp expireDate;
  List<String> helperAndRequester;

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
    requesterId: json["requester_id"],
    requesterName: json["requester_name"],
    requesterImage: json["requester_image"],
    helperId: json["helper_id"],
    reqStatus: json["req_status"],
    requesterCalledOff: json["requester_called_off"],
    expireDate: json["expire_date"],
    helperAndRequester: List<String>.from(json["helper_and_requester"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "requester_id": requesterId,
    "requester_name": requesterName,
    "requester_image": requesterImage,
    "helper_id": helperId,
    "req_status": reqStatus,
    "requester_called_off": requesterCalledOff,
    "expire_date": expireDate,
    "helper_and_requester": List<dynamic>.from(helperAndRequester.map((x) => x)),
  };
}
