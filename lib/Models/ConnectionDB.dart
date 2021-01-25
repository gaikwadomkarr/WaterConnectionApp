// To parse this JSON data, do
//
//     final connectionDb = connectionDbFromJson(jsonString);

import 'dart:convert';

// ConnectionDb connectionDbFromJson(String str) => ConnectionDb.fromJson(json.decode(str));

// String connectionDbToJson(ConnectionDb data) => json.encode(data.toJson());

class ConnectionDb {
  ConnectionDb(
      {this.id,
      this.consumerName,
      this.consumerPhoto,
      this.contractor,
      this.saddle,
      this.zone,
      this.consumerMobile,
      this.consumerAddress,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.ferrule,
      this.roadCrossing,
      this.mdpePipeLength,
      this.zoneId,
      this.saddleId,
      this.contractorId,
      this.branchId,
      this.createdBy,
      this.uploadStatus});

  int id;
  String consumerName;
  String consumerPhoto;
  String contractor;
  String saddle;
  String zone;
  String consumerMobile;
  String consumerAddress;
  String latitude;
  String longitude;
  String createdAt;
  String ferrule;
  String roadCrossing;
  String mdpePipeLength;
  int zoneId;
  int saddleId;
  int contractorId;
  int branchId;
  int createdBy;
  String uploadStatus;

  ConnectionDb.fromJson(Map<String, dynamic> json) {
    id = json["id"] == null ? null : json["id"];
    consumerName = json["consumerName"] == null ? null : json["consumerName"];
    consumerPhoto =
        json["consumerPhoto"] == null ? null : json["consumerPhoto"];
    contractor = json["contractor"] == null ? null : json["contractor"];
    saddle = json["saddle"] == null ? null : json["saddle"];
    zone = json["zone"] == null ? null : json["zone"];
    consumerMobile =
        json["consumerMobile"] == null ? null : json["consumerMobile"];
    consumerAddress =
        json["consumerAddress"] == null ? null : json["consumerAddress"];
    latitude = json["latitude"] == null ? null : json["latitude"];
    longitude = json["longitude"] == null ? null : json["longitude"];
    createdAt = json["created_at"] == null ? null : json["created_at"];
    ferrule = json["ferrule"] == null ? null : json["ferrule"];
    roadCrossing = json["roadCrossing"] == null ? null : json["roadCrossing"];
    mdpePipeLength =
        json["mdpePipeLength"] == null ? null : json["mdpePipeLength"];
    zoneId = json["zoneId"] == null ? null : json["zoneId"];
    saddleId = json["saddleId"] == null ? null : json["saddleId"];
    contractorId = json["contractorId"] == null ? null : json["contractorId"];
    branchId = json["branchId"] == null ? null : json["branchId"];
    createdBy = json["created_by"] == null ? null : json["created_by"];
    uploadStatus = json["uploadStatus"] == null ? null : json["uploadStatus"];
  }

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "consumerName": consumerName == null ? null : consumerName,
        "consumerPhoto": consumerPhoto == null ? null : consumerPhoto,
        "contractor": contractor == null ? null : contractor,
        "saddle": saddle == null ? null : saddle,
        "zone": zone == null ? null : zone,
        "consumerMobile": consumerMobile == null ? null : consumerMobile,
        "consumerAddress": consumerAddress == null ? null : consumerAddress,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "created_at": createdAt == null ? null : createdAt,
        "ferrule": ferrule == null ? null : ferrule,
        "roadCrossing": roadCrossing == null ? null : roadCrossing,
        "mdpePipeLength": mdpePipeLength == null ? null : mdpePipeLength,
        "zoneId": zoneId == null ? null : zoneId,
        "saddleId": saddleId == null ? null : saddleId,
        "contractorId": contractorId == null ? null : contractorId,
        "branchId": branchId == null ? null : branchId,
        "created_by": createdBy == null ? null : createdBy,
        "uploadStatus": uploadStatus == null ? null : uploadStatus,
      };
}
