class CrossMarginWalletModel {
  int? statusCode;
  String? statusMessage;
  List<CrossMarginWallet>? result;
  String? sTypename;

  CrossMarginWalletModel(
      {this.statusCode, this.statusMessage, this.result, this.sTypename});

  CrossMarginWalletModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(new CrossMarginWallet.fromJson(v));
      });
    }
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['status_message'] = this.statusMessage;
    if (this.result != null) {
      data['result'] = this.result?.map((v) => v.toJson()).toList();
    }
    data['__typename'] = this.sTypename;
    return data;
  }
}

class CrossMarginWallet {
  num? marginRatio;
  bool? autoTopup;
  num? totalBalance;
  num? totalCrypto;
  num? borrowedCrypto;
  String? currency;
  num? availableBalance;
  num? borrowed;
  num? inorder;
  num? interest;
  num? equity;
  num? equityCrypto;
  String? modifiedDate;
  String? currencyImage;
  String? sTypename;

  CrossMarginWallet(
      {this.marginRatio,
      this.autoTopup,
      this.totalBalance,
      this.totalCrypto,
      this.borrowedCrypto,
      this.currency,
      this.availableBalance,
      this.borrowed,
      this.inorder,
      this.interest,
      this.equity,
      this.equityCrypto,
      this.modifiedDate,
      this.currencyImage,
      this.sTypename});

  CrossMarginWallet.fromJson(Map<String, dynamic> json) {
    marginRatio = json['margin_ratio'];
    autoTopup = json['auto_topup'];
    totalBalance = json['total_balance'];
    totalCrypto = json['total_crypto'];
    borrowedCrypto = json['borrowed_crypto'];
    currency = json['currency'];
    availableBalance = json['available_balance'];
    borrowed = json['borrowed'];
    inorder = json['inorder'];
    interest = json['interest'];
    equity = json['equity'];
    equityCrypto = json['equity_crypto'];
    modifiedDate = json['modified_date'];
    currencyImage = json['currency_image'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['margin_ratio'] = this.marginRatio;
    data['auto_topup'] = this.autoTopup;
    data['total_balance'] = this.totalBalance;
    data['total_crypto'] = this.totalCrypto;
    data['borrowed_crypto'] = this.borrowedCrypto;
    data['currency'] = this.currency;
    data['available_balance'] = this.availableBalance;
    data['borrowed'] = this.borrowed;
    data['inorder'] = this.inorder;
    data['interest'] = this.interest;
    data['equity'] = this.equity;
    data['equity_crypto'] = this.equityCrypto;
    data['modified_date'] = this.modifiedDate;
    data['currency_image'] = this.currencyImage;
    data['__typename'] = this.sTypename;
    return data;
  }
}
