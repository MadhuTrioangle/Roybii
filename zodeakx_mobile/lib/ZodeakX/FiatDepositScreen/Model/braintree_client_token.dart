class BraintreeClientTokenModel {
  int? statusCode;
  String? statusMessage;
  BraintreeClientToken? result;
  String? sTypename;

  BraintreeClientTokenModel(
      {this.statusCode, this.statusMessage, this.result, this.sTypename});

  BraintreeClientTokenModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    result =
    json['result'] != null ? new BraintreeClientToken.fromJson(json['result']) : null;
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['status_message'] = this.statusMessage;
    if (this.result != null) {
      data['result'] = this.result?.toJson();
    }
    data['__typename'] = this.sTypename;
    return data;
  }
}

class BraintreeClientToken {
  String? clientToken;
  bool? success;
  String? sTypename;

  BraintreeClientToken({this.clientToken, this.success, this.sTypename});

  BraintreeClientToken.fromJson(Map<String, dynamic> json) {
    clientToken = json['clientToken'];
    success = json['success'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientToken'] = this.clientToken;
    data['success'] = this.success;
    data['__typename'] = this.sTypename;
    return data;
  }
}
