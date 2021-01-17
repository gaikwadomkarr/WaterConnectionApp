class SessionData {
  int code;
  String status;
  String message;
  Data data;

  SessionData._internal();

  static final SessionData _instance = SessionData._internal();

  factory SessionData() => _instance;

  setData(code, status, meesage, data) {
    this.code = code;
    this.status = status;
    this.message = message;
    this.data = data;
  }

  settoken(String token) {
    this.data.token = token;
  }

  clear() {
    this.code = null;
    this.status = null;
    this.message = null;
    this.data = null;
  }

  factory SessionData.fromJson(Map<String, dynamic> json) {
    int code = json["code"] == null ? null : json["code"];
    String status = json["status"] == null ? null : json["status"];
    String message = json["message"] == null ? null : json["message"];
    Data data = json["data"] == null ? null : Data.fromJson(json["data"]);

    return _instance.setData(code, status, message, data);
  }

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.username,
    this.name,
    this.address,
    this.isActive,
    this.branchId,
    this.token,
  });

  int id;
  String username;
  String name;
  String address;
  String isActive;
  int branchId;
  String token;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        username: json["username"] == null ? null : json["username"],
        name: json["name"] == null ? null : json["name"],
        address: json["address"] == null ? null : json["address"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        branchId: json["branchId"] == null ? null : json["branchId"],
        token: json["token"] == null ? null : json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "username": username == null ? null : username,
        "name": name == null ? null : name,
        "address": address == null ? null : address,
        "is_active": isActive == null ? null : isActive,
        "branchId": branchId == null ? null : branchId,
        "token": token == null ? null : token,
      };
}
