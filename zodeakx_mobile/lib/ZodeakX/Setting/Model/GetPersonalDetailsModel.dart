import 'dart:convert';

class GetPersonalDetailsClass {
  int? statusCode;
  String? statusMessage;
  GetPersonalDetails? result;
  String? typename;

  GetPersonalDetailsClass({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory GetPersonalDetailsClass.fromRawJson(String str) =>
      GetPersonalDetailsClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPersonalDetailsClass.fromJson(Map<String, dynamic> json) =>
      GetPersonalDetailsClass(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result: json["result"] == null
            ? null
            : GetPersonalDetails.fromJson(json["result"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "result": result?.toJson(),
        "__typename": typename,
      };
}

class GetPersonalDetails {
  String? firstName;
  String? middleName;
  String? lastName;
  String? dob;
  String? address;
  String? country;
  String? state;
  String? city;
  String? zip;
  String? typename;

  GetPersonalDetails({
    this.firstName,
    this.middleName,
    this.lastName,
    this.dob,
    this.address,
    this.country,
    this.state,
    this.city,
    this.zip,
    this.typename,
  });

  factory GetPersonalDetails.fromRawJson(String str) =>
      GetPersonalDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPersonalDetails.fromJson(Map<String, dynamic> json) =>
      GetPersonalDetails(
        firstName: json["first_name"],
        middleName: json["middle_name"],
        lastName: json["last_name"],
        dob: json["dob"],
        address: json["address"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        zip: json["zip"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
        "dob": dob,
        "address": address,
        "country": country,
        "state": state,
        "city": city,
        "zip": zip,
        "__typename": typename,
      };
}
