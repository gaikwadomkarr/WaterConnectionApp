// To parse this JSON data, do
//
//     final MeterReadingDb = MeterReadingDbFromJson(jsonString);

import 'dart:convert';

// MeterReadingDb MeterReadingDbFromJson(String str) => MeterReadingDb.fromJson(json.decode(str));

// String MeterReadingDbToJson(MeterReadingDb data) => json.encode(data.toJson());

class MeterReadingDb {
  MeterReadingDb(
      {this.id,
      this.consumerName,
      this.consumerPhoto,
      this.meterNumber,
      this.meterReading,
      this.consumerAddress,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.branchId,
      this.uploadStatus});

  int id;
  String consumerName;
  String consumerPhoto;
  int meterNumber;
  int meterReading;
  String consumerAddress;
  String latitude;
  String longitude;
  String createdAt;
  int branchId;
  String uploadStatus;

  MeterReadingDb.fromJson(Map<String, dynamic> json) {
    id = json["id"] == null ? null : json["id"];
    consumerName = json["consumerName"] == null ? null : json["consumerName"];
    consumerPhoto =
        json["consumerPhoto"] == null ? null : json["consumerPhoto"];
    meterNumber = json["meterNumber"] == null ? null : json["meterNumber"];
    branchId = json["meterReading"] == null ? null : json["meterReading"];
    consumerAddress =
        json["consumerAddress"] == null ? null : json["consumerAddress"];
    latitude = json["latitude"] == null ? null : json["latitude"];
    longitude = json["longitude"] == null ? null : json["longitude"];
    createdAt = json["created_at"] == null ? null : json["created_at"];
    branchId = json["branchId"] == null ? null : json["branchId"];
    uploadStatus = json["uploadStatus"] == null ? null : json["uploadStatus"];
  }

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "consumerName": consumerName == null ? null : consumerName,
        "consumerPhoto": consumerPhoto == null ? null : consumerPhoto,
        "meterNumber": meterNumber == null ? null : meterNumber,
        "meterReading": meterReading == null ? null : meterReading,
        "consumerAddress": consumerAddress == null ? null : consumerAddress,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "created_at": createdAt == null ? null : createdAt,
        "branchId": branchId == null ? null : branchId,
        "uploadStatus": uploadStatus == null ? null : uploadStatus,
      };
}
