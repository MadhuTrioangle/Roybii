class GetBalanceModel {
  late int statusCode;
  late String statusMessage;
  late Balance result;
  late String sTypename;

  GetBalanceModel(
      {required this.statusCode, required this.statusMessage, required this.result, required this.sTypename});

  GetBalanceModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    result =
    (json['result'] != null ? new Balance.fromJson(json['result']) : null)!;
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['status_message'] = this.statusMessage;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['__typename'] = this.sTypename;
    return data;
  }
}

class Balance {
  late num fcurr;
  late num scurr;
  late String sTypename;

  Balance({required this.fcurr, required this.scurr, required this.sTypename});

  Balance.fromJson(Map<String, dynamic> json) {
    fcurr = json['fcurr'];
    scurr = json['scurr'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fcurr'] = this.fcurr;
    data['scurr'] = this.scurr;
    data['__typename'] = this.sTypename;
    return data;
  }
}

Balance dummyBalance = Balance(fcurr: 0, scurr: 0, sTypename: '__typename',);