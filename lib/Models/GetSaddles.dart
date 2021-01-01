// To parse this JSON data, do
//
//     final getSaddles = getSaddlesFromJson(jsonString);

import 'dart:convert';

GetSaddles getSaddlesFromJson(String str) =>
    GetSaddles.fromJson(json.decode(str));

String getSaddlesToJson(GetSaddles data) => json.encode(data.toJson());

class GetSaddles {
  GetSaddles({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  int code;
  String status;
  String message;
  List<Saddle> data;

  factory GetSaddles.fromJson(Map<String, dynamic> json) => GetSaddles(
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Saddle>.from(json["data"].map((x) => Saddle.fromJson(x))),
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

class Saddle {
  Saddle({
    this.id,
    this.saddleName,
  });

  int id;
  String saddleName;

  factory Saddle.fromJson(Map<String, dynamic> json) => Saddle(
        id: json["id"] == null ? null : json["id"],
        saddleName: json["saddle_name"] == null ? null : json["saddle_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "saddle_name": saddleName == null ? null : saddleName,
      };
}
