class TradesHistoryModel {
  int? statusCode;
  String? statusMessage;
  List<TradesHistory>? result;

  TradesHistoryModel({this.statusCode, this.statusMessage, this.result});

  TradesHistoryModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['result'] != null) {
      result = <TradesHistory>[];
      json['result'].forEach((v) {
        result?.add(new TradesHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['status_message'] = this.statusMessage;
    if (this.result != null) {
      data['result'] = this.result?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TradesHistory {
  dynamic? price;
  dynamic? qty;
  dynamic? side;

  TradesHistory({this.price, this.qty, this.side});

  TradesHistory.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    qty = json['qty'];
    side = json['side'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['side'] = this.side;
    return data;
  }
}
