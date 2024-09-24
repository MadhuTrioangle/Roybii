// To parse this JSON data, do
//
//     final getUserByJwtModel = getUserByJwtModelFromJson(jsonString);

import 'dart:convert';

class GetUserByJwtModel {
  GetUserByJwtModel({
    this.data,
  });

  Data? data;

  factory GetUserByJwtModel.fromRawJson(String str) =>
      GetUserByJwtModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetUserByJwtModel.fromJson(Map<String, dynamic> json) =>
      GetUserByJwtModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data?.toJson(),
      };
}

class Data {
  Data({
    this.getUserByJwt,
  });

  GetUserByJwt? getUserByJwt;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        getUserByJwt: json["getUserByJWT"] == null
            ? null
            : GetUserByJwt.fromJson(json["getUserByJWT"]),
      );

  Map<String, dynamic> toJson() => {
        "getUserByJWT": getUserByJwt == null ? null : getUserByJwt?.toJson(),
      };
}

class GetUserByJwt {
  GetUserByJwt({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  GetUserJwt? result;
  String? typename;

  factory GetUserByJwt.fromRawJson(String str) =>
      GetUserByJwt.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetUserByJwt.fromJson(Map<String, dynamic> json) => GetUserByJwt(
        statusCode: json["status_code"] == null ? null : json["status_code"],
        statusMessage:
            json["status_message"] == null ? null : json["status_message"],
        result:
            json["result"] == null ? null : GetUserJwt.fromJson(json["result"]),
        typename: json["__typename"] == null ? null : json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode == null ? null : statusCode,
        "status_message": statusMessage == null ? null : statusMessage,
        "result": result == null ? null : result?.toJson(),
        "__typename": typename == null ? null : typename,
      };
}

class GetUserJwt {
  GetUserJwt({
    this.tfaEnableKey,
    this.vip_level,
    this.antiPhishingCode,
    this.tfaStatus,
    this.passwordStatus,
    this.kyc,
    this.tfaAuthentication,
    this.withdrawalLimit,
    this.withdrawalWhitelist,
    this.oneStepWithdrawal,
    this.typename,
  });

  String? vip_level;
  String? tfaEnableKey;
  String? antiPhishingCode;
  String? tfaStatus;
  bool? passwordStatus;
  Kyc? kyc;
  TfaAuthentication? tfaAuthentication;
  WithdrawalLimit? withdrawalLimit;
  WithdrawalWhitelist? withdrawalWhitelist;
  OneStepWithdrawal? oneStepWithdrawal;
  String? typename;

  factory GetUserJwt.fromRawJson(String str) =>
      GetUserJwt.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetUserJwt.fromJson(Map<String, dynamic> json) => GetUserJwt(
        vip_level: json["vip_level"] == null ? null : json["vip_level"],
        tfaEnableKey:
            json["tfa_enable_key"] == null ? null : json["tfa_enable_key"],
        antiPhishingCode: json["anti_phishing_code"] == null
            ? null
            : json["anti_phishing_code"],
        tfaStatus: json["tfa_status"] == null ? null : json["tfa_status"],
        passwordStatus:
            json["password_status"] == null ? null : json["password_status"],
        tfaAuthentication: json["tfa_authentication"] == null
            ? null
            : TfaAuthentication.fromJson(json["tfa_authentication"]),
        kyc: json["kyc"] == null ? null : Kyc.fromJson(json["kyc"]),
        withdrawalLimit: json["withdrawal_limit"] == null
            ? null
            : WithdrawalLimit.fromJson(json["withdrawal_limit"]),
        withdrawalWhitelist: json["withdrawal_whitelist"] == null
            ? null
            : WithdrawalWhitelist.fromJson(json["withdrawal_whitelist"]),
        oneStepWithdrawal: json["one_step_withdrawal"] == null
            ? null
            : OneStepWithdrawal.fromJson(json["one_step_withdrawal"]),
        typename: json["__typename"] == null ? null : json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "vip_level": vip_level == null ? null : vip_level,
        "tfa_enable_key": tfaEnableKey == null ? null : tfaEnableKey,
        "anti_phishing_code":
            antiPhishingCode == null ? null : antiPhishingCode,
        "tfa_status": tfaStatus == null ? null : tfaStatus,
        "password_status": passwordStatus == null ? null : passwordStatus,
        "tfa_authentication":
            tfaAuthentication == null ? null : tfaAuthentication?.toJson(),
        "kyc": kyc == null ? null : kyc?.toJson(),
        "withdrawal_limit": withdrawalLimit?.toJson(),
        "withdrawal_whitelist": withdrawalWhitelist?.toJson(),
        "one_step_withdrawal": oneStepWithdrawal?.toJson(),
        "__typename": typename == null ? null : typename,
      };
}

class Kyc {
  Kyc({
    this.idProof,
    this.facialProof,
    this.kycStatus,
    this.typename,
  });

  IdProof? idProof;
  FacialProof? facialProof;
  String? kycStatus;
  String? typename;

  factory Kyc.fromRawJson(String str) => Kyc.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Kyc.fromJson(Map<String, dynamic> json) => Kyc(
        idProof: json["id_proof"] == null
            ? null
            : IdProof.fromJson(json["id_proof"]),
        facialProof: json["facial_proof"] == null
            ? null
            : FacialProof.fromJson(json["facial_proof"]),
        kycStatus: json["kyc_status"] == null ? null : json["kyc_status"],
        typename: json["__typename"] == null ? null : json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "id_proof": idProof == null ? null : idProof?.toJson(),
        "facial_proof": facialProof == null ? null : facialProof?.toJson(),
        "kyc_status": kycStatus == null ? null : kycStatus,
        "__typename": typename == null ? null : typename,
      };
}

class FacialProof {
  FacialProof({
    this.facialProof,
    this.facialProofStatus,
    this.typename,
  });

  String? facialProof;
  String? facialProofStatus;
  String? typename;

  factory FacialProof.fromRawJson(String str) =>
      FacialProof.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FacialProof.fromJson(Map<String, dynamic> json) => FacialProof(
        facialProof: json["facial_proof"] == null ? null : json["facial_proof"],
        facialProofStatus: json["facial_proof_Status"] == null
            ? null
            : json["facial_proof_Status"],
        typename: json["__typename"] == null ? null : json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "facial_proof": facialProof == null ? null : facialProof,
        "facial_proof_Status":
            facialProofStatus == null ? null : facialProofStatus,
        "__typename": typename == null ? null : typename,
      };
}

class IdProof {
  IdProof({
    this.firstName,
    this.lastName,
    this.middleName,
    this.dob,
    this.state,
    this.address1,
    this.country,
    this.city,
    this.zip,
    this.idProofType,
    this.idProofFront,
    this.idProofFrontStatus,
    this.idProofBack,
    this.idProofBackStatus,
    this.typename,
  });

  String? firstName;
  String? lastName;
  String? middleName;
  String? dob;
  String? state;
  String? address1;
  String? country;
  String? city;
  String? zip;
  String? idProofType;
  String? idProofFront;
  String? idProofFrontStatus;
  String? idProofBack;
  String? idProofBackStatus;
  String? typename;

  factory IdProof.fromRawJson(String str) => IdProof.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IdProof.fromJson(Map<String, dynamic> json) => IdProof(
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        middleName: json["middle_name"] == null ? null : json["middle_name"],
        dob: json["dob"] == null ? null : json["dob"],
        state: json["State"] == null ? null : json["State"],
        address1: json["Address1"] == null ? null : json["Address1"],
        country: json["country"] == null ? null : json["country"],
        city: json["city"] == null ? null : json["city"],
        zip: json["zip"] == null ? null : json["zip"],
        idProofType:
            json["id_proof_type"] == null ? null : json["id_proof_type"],
        idProofFront:
            json["id_proof_front"] == null ? null : json["id_proof_front"],
        idProofFrontStatus: json["id_proof_front_status"] == null
            ? null
            : json["id_proof_front_status"],
        idProofBack:
            json["id_proof_back"] == null ? null : json["id_proof_back"],
        idProofBackStatus: json["id_proof_back_status"] == null
            ? null
            : json["id_proof_back_status"],
        typename: json["__typename"] == null ? null : json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "middle_name": middleName == null ? null : middleName,
        "dob": dob == null ? null : dob,
        "State": state == null ? null : state,
        "Address1": address1 == null ? null : address1,
        "country": country == null ? null : country,
        "city": city == null ? null : city,
        "zip": zip == null ? null : zip,
        "id_proof_type": idProofType == null ? null : idProofType,
        "id_proof_front": idProofFront == null ? null : idProofFront,
        "id_proof_front_status":
            idProofFrontStatus == null ? null : idProofFrontStatus,
        "id_proof_back": idProofBack == null ? null : idProofBack,
        "id_proof_back_status":
            idProofBackStatus == null ? null : idProofBackStatus,
        "__typename": typename == null ? null : typename,
      };
}

class OneStepWithdrawal {
  bool? enable;
  num? maxWithdrawal;
  String? typename;

  OneStepWithdrawal({
    this.enable,
    this.maxWithdrawal,
    this.typename,
  });

  factory OneStepWithdrawal.fromRawJson(String str) =>
      OneStepWithdrawal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OneStepWithdrawal.fromJson(Map<String, dynamic> json) =>
      OneStepWithdrawal(
        enable: json["enable"],
        maxWithdrawal: json["max_withdrawal"]?.toDouble(),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "enable": enable,
        "max_withdrawal": maxWithdrawal,
        "__typename": typename,
      };
}

class TfaAuthentication {
  MobileNumber? mobileNumber;
  String? typename;

  TfaAuthentication({
    this.mobileNumber,
    this.typename,
  });

  factory TfaAuthentication.fromRawJson(String str) =>
      TfaAuthentication.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TfaAuthentication.fromJson(Map<String, dynamic> json) =>
      TfaAuthentication(
        mobileNumber: json["mobile_number"] == null
            ? null
            : MobileNumber.fromJson(json["mobile_number"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "mobile_number": mobileNumber?.toJson(),
        "__typename": typename,
      };
}

class MobileNumber {
  String? phoneCode;
  String? phoneNumber;
  String? status;
  DateTime? updatedAt;
  String? typename;

  MobileNumber({
    this.phoneCode,
    this.phoneNumber,
    this.status,
    this.updatedAt,
    this.typename,
  });

  factory MobileNumber.fromRawJson(String str) =>
      MobileNumber.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MobileNumber.fromJson(Map<String, dynamic> json) => MobileNumber(
        phoneCode: json["phone_code"],
        phoneNumber: json["phone_number"],
        status: json["status"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "phone_code": phoneCode,
        "phone_number": phoneNumber,
        "status": status,
        "updated_at": updatedAt?.toIso8601String(),
        "__typename": typename,
      };
}

class WithdrawalLimit {
  bool? enable;
  dynamic limit;
  String? typename;

  WithdrawalLimit({
    this.enable,
    this.limit,
    this.typename,
  });

  factory WithdrawalLimit.fromRawJson(String str) =>
      WithdrawalLimit.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WithdrawalLimit.fromJson(Map<String, dynamic> json) =>
      WithdrawalLimit(
        enable: json["enable"],
        limit: json["limit"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "enable": enable,
        "limit": limit,
        "__typename": typename,
      };
}

class WithdrawalWhitelist {
  bool? enable;
  List<AddressList>? addressList;
  String? typename;

  WithdrawalWhitelist({
    this.enable,
    this.addressList,
    this.typename,
  });

  factory WithdrawalWhitelist.fromRawJson(String str) =>
      WithdrawalWhitelist.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WithdrawalWhitelist.fromJson(Map<String, dynamic> json) =>
      WithdrawalWhitelist(
        enable: json["enable"],
        addressList: json["address_list"] == null
            ? []
            : List<AddressList>.from(
                json["address_list"]!.map((x) => AddressList.fromJson(x))),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "enable": enable,
        "address_list": addressList == null
            ? []
            : List<dynamic>.from(addressList!.map((x) => x.toJson())),
        "__typename": typename,
      };
}

class AddressList {
  String? id;
  String? label;
  bool? universalAddress;
  String? address;
  dynamic tagId;
  String? coin;
  String? network;
  bool? whitelist;
  String? originName;
  String? status;
  String? typename;

  AddressList({
    this.id,
    this.label,
    this.universalAddress,
    this.address,
    this.tagId,
    this.coin,
    this.network,
    this.whitelist,
    this.originName,
    this.status,
    this.typename,
  });

  factory AddressList.fromRawJson(String str) =>
      AddressList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddressList.fromJson(Map<String, dynamic> json) => AddressList(
        id: json["_id"],
        label: json["label"],
        universalAddress: json["universal_address"],
        address: json["address"],
        tagId: json["tag_id"],
        coin: json["coin"],
        network: json["network"],
        whitelist: json["whitelist"],
        originName: json["origin_name"],
        status: json["status"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "label": label,
        "universal_address": universalAddress,
        "address": address,
        "tag_id": tagId,
        "coin": coin,
        "network": network,
        "whitelist": whitelist,
        "origin_name": originName,
        "status": status,
        "__typename": typename,
      };
}
