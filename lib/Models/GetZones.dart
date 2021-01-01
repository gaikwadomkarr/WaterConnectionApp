// To parse this JSON data, do
//
//     final getZones = getZonesFromJson(jsonString);

import 'dart:convert';

GetZones getZonesFromJson(String str) => GetZones.fromJson(json.decode(str));

String getZonesToJson(GetZones data) => json.encode(data.toJson());

class GetZones {
  GetZones({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  int code;
  String status;
  String message;
  List<Zone> data;

  factory GetZones.fromJson(Map<String, dynamic> json) => GetZones(
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Zone>.from(json["data"].map((x) => Zone.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Zone {
  Zone({
    this.id,
    this.zoneName,
  });

  int id;
  String zoneName;

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
        id: json["id"] == null ? null : json["id"],
        zoneName: json["zone_name"] == null ? null : json["zone_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "zone_name": zoneName == null ? null : zoneName,
      };
}
