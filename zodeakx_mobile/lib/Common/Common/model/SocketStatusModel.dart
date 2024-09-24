import 'dart:convert';

class SocketStatus {
  bool? binanceStatus;
  bool? okxStatus;

  SocketStatus({
    this.binanceStatus,
    this.okxStatus,
  });

  factory SocketStatus.fromRawJson(String str) => SocketStatus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SocketStatus.fromJson(Map<String, dynamic> json) => SocketStatus(
    binanceStatus: json["binance_status"],
    okxStatus: json["okx_status"],
  );

  Map<String, dynamic> toJson() => {
    "binance_status": binanceStatus,
    "okx_status": okxStatus,
  };
}
