

import 'dart:convert';

class GetCurrencyModel {
    GetCurrencyModel({
        this.statusCode,
        this.statusMessage,
        this.result,
        this.typename,
    });

    int? statusCode;
    String? statusMessage;
    List<GetCurrency>? result;
    String? typename;

    factory GetCurrencyModel.fromRawJson(String str) => GetCurrencyModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetCurrencyModel.fromJson(Map<String, dynamic> json) => GetCurrencyModel(
        statusCode: json["status_code"] == null ? null : json["status_code"],
        statusMessage: json["status_message"] == null ? null : json["status_message"],
        result: json["result"] == null ? null : List<GetCurrency>.from(json["result"].map((x) => GetCurrency.fromJson(x))),
        typename: json["__typename"] == null ? null : json["__typename"],
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode == null ? null : statusCode,
        "status_message": statusMessage == null ? null : statusMessage,
        "result": result == null ? null : List<dynamic>.from(result!.map((x) => x.toJson())),
        "__typename": typename == null ? null : typename,
    };
}

class GetCurrency {
    GetCurrency({
        this.image,
        this.currencyCode,
        this.minWithdrawLimit,
        this.withdrawFee,
        this.maxWithdrawLimit,
        this.network,
        this.networkDetails,
        this.withdraw24HLimit,
        this.typename,
    });

    String? image;
    String? currencyCode;
    num? minWithdrawLimit;
    num? withdrawFee;
    num? maxWithdrawLimit;
    List<String>? network;
    List<NetworkDetail>? networkDetails;
    num? withdraw24HLimit;
    Typename? typename;
    String name = "";

    factory GetCurrency.fromRawJson(String str) => GetCurrency.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetCurrency.fromJson(Map<String, dynamic> json) => GetCurrency(
        image: json["image"] == null ? null : json["image"],
        currencyCode: json["currency_code"] == null ? null : json["currency_code"],
        minWithdrawLimit: json["min_withdraw_limit"] == null ? null : json["min_withdraw_limit"].toDouble(),
        withdrawFee: json["withdraw_fee"] == null ? null : json["withdraw_fee"].toDouble(),
        maxWithdrawLimit: json["max_withdraw_limit"] == null ? null : json["max_withdraw_limit"].toDouble(),
        network: json["network"] == null ? [] : List<String>.from(json["network"]!.map((x) => x)),
        networkDetails: json["network_details"] == null ? [] : List<NetworkDetail>.from(json["network_details"]!.map((x) => NetworkDetail.fromJson(x))),
        withdraw24HLimit: json["withdraw_24h_limit"] == null ? null : json["withdraw_24h_limit"].toDouble(),
        typename: json["__typename"] == null ? null : typenameValues.map?[json["__typename"]],
    );

    Map<String, dynamic> toJson() => {
        "image": image == null ? null : image,
        "currency_code": currencyCode == null ? null : currencyCode,
        "min_withdraw_limit": minWithdrawLimit == null ? null : minWithdrawLimit,
        "withdraw_fee": withdrawFee == null ? null : withdrawFee,
        "max_withdraw_limit": maxWithdrawLimit == null ? null : maxWithdrawLimit,
        "network": network == null ? [] : List<dynamic>.from(network!.map((x) => x)),
        "network_details": networkDetails == null ? [] : List<dynamic>.from(networkDetails!.map((x) => x.toJson())),
        "withdraw_24h_limit": withdraw24HLimit == null ? null : withdraw24HLimit,
        "__typename": typename == null ? null : typenameValues.reverse?[typename],
    };
}

enum Typename { CURRENCY_RESPONSE }

final typenameValues = EnumValues({
    "currencyResponse": Typename.CURRENCY_RESPONSE
});

class EnumValues<T> {
    Map<String, T>? map;
    Map<T, String>? reverseMap;

    EnumValues(this.map);

    Map<T, String>? get reverse {
        if (reverseMap == null) {
            reverseMap = map?.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}

class NetworkDetail {
    String? network;
    num? withdrawFee;
    num? minWithdrawLimit;
    num? maxWithdrawLimit;
    num? withdraw24HLimit;
    String? typename;

    NetworkDetail({
        this.network,
        this.withdrawFee,
        this.minWithdrawLimit,
        this.maxWithdrawLimit,
        this.withdraw24HLimit,
        this.typename,
    });

    factory NetworkDetail.fromRawJson(String str) => NetworkDetail.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory NetworkDetail.fromJson(Map<String, dynamic> json) => NetworkDetail(
        network: json["network"],
        withdrawFee: json["withdraw_fee"]?.toDouble(),
        minWithdrawLimit: json["min_withdraw_limit"]?.toDouble(),
        maxWithdrawLimit: json["max_withdraw_limit"],
        withdraw24HLimit: json["withdraw_24h_limit"],
        typename: json["__typename"],
    );

    Map<String, dynamic> toJson() => {
        "network": network,
        "withdraw_fee": withdrawFee,
        "min_withdraw_limit": minWithdrawLimit,
        "max_withdraw_limit": maxWithdrawLimit,
        "withdraw_24h_limit": withdraw24HLimit,
        "__typename": typename,
    };
}