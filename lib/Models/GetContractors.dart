// To parse this JSON data, do
//
//     final getContractors = getContractorsFromJson(jsonString);

import 'dart:convert';

GetContractors getContractorsFromJson(String str) =>
    GetContractors.fromJson(json.decode(str));

String getContractorsToJson(GetContractors data) => json.encode(data.toJson());

class GetContractors {
  GetContractors({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  int code;
  String status;
  String message;
  List<Contractor> data;

  factory GetContractors.fromJson(Map<String, dynamic> json) => GetContractors(
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Contractor>.from(
                json["data"].map((x) => Contractor.fromJson(x))),
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

class Contractor {
  Contractor({
    this.id,
    this.name,
    this.address,
  });

  int id;
  String name;
  String address;

  factory Contractor.fromJson(Map<String, dynamic> json) => Contractor(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        address: json["address"] == null ? null : json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "address": address == null ? null : address,
      };
}
