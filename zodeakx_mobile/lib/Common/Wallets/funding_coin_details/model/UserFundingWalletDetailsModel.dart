class UserFundingWalletDetailsModel {
  UserFundingWalletDetailsModel({
    required this.statusCode,
    required this.statusMessage,
    required this.result,
  });

  late final int statusCode;
  late final String statusMessage;
  late final List<UserFundingWalletDetails> result;

  UserFundingWalletDetailsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    result = List.from(json['result'])
        .map((e) => UserFundingWalletDetails.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status_code'] = statusCode;
    _data['status_message'] = statusMessage;
    _data['result'] = result.map((e) => e.toJson()).toList();
    return _data;
  }
}

class UserFundingWalletDetails {
  UserFundingWalletDetails({
     this.amount,
     this.inorder,
     this.currencyCode,
     this.currency_type,
     this.convertedAmount,
     this.convertedCurrencyCode,
     this.currencyLogo,
  });

    num? amount;
    num? inorder;
    String? currencyCode;
    String? currency_type;
    num? convertedAmount;
    num? exchangeRate;
    num? totalAmount;
    String? convertedCurrencyCode;
    String? currencyLogo;

  UserFundingWalletDetails.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    inorder = json['inorder'];
    currencyCode = json['currency_code'];
    currency_type = json['currency_type'];
    convertedAmount = json['converted_amount'];
    convertedCurrencyCode = json['converted_currency_code'];
    currencyLogo = json['currency_logo'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['amount'] = amount;
    _data['inorder'] = inorder;
    _data['currency_code'] = currencyCode;
    _data['currency_type'] = currency_type;
    _data['converted_amount'] = convertedAmount;
    _data['converted_currency_code'] = convertedCurrencyCode;
    _data['currency_logo'] = currencyLogo;
    return _data;
  }
}

UserFundingWalletDetails dummyUserFundingWalletDetails =
    UserFundingWalletDetails(
        amount: 0,
        inorder: 0,
        currencyCode: "",
        convertedAmount: 0,
        convertedCurrencyCode: "",
        currencyLogo: "",currency_type:"");
