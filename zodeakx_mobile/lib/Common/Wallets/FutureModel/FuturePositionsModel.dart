import 'dart:convert';

class FuturePositionsModel {
  num? statusCode;
  String? statusMessage;
  FuturePositions? result;
  String? typename;

  FuturePositionsModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory FuturePositionsModel.fromRawJson(dynamic str) =>
      FuturePositionsModel.fromJson(json.decode(str));

  dynamic toRawJson() => json.encode(toJson());

  factory FuturePositionsModel.fromJson(Map<dynamic, dynamic> json) =>
      FuturePositionsModel(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result: json["result"] == null
            ? null
            : FuturePositions.fromJson(json["result"]),
        typename: json["__typename"],
      );

  Map<dynamic, dynamic> toJson() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "result": result?.toJson(),
        "__typename": typename,
      };
}

class FuturePositions {
  int? total;
  int? page;
  int? pages;
  List<FuturePositionsData>? data;
  String? typename;

  FuturePositions({
    this.total,
    this.page,
    this.pages,
    this.data,
    this.typename,
  });

  factory FuturePositions.fromRawJson(dynamic str) =>
      FuturePositions.fromJson(json.decode(str));

  dynamic toRawJson() => json.encode(toJson());

  factory FuturePositions.fromJson(Map<dynamic, dynamic> json) =>
      FuturePositions(
        total: json["total"],
        page: json["page"],
        pages: json["pages"],
        data: json["data"] == null
            ? []
            : List<FuturePositionsData>.from(json["data"]!.map((x) => FuturePositionsData.fromJson(x))),
        typename: json["__typename"],
      );

  Map<dynamic, dynamic> toJson() => {
        "total": total,
        "page": page,
        "pages": pages,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "__typename": typename,
      };
}

class FuturePositionsData {
  String? id;
  String? userId;
  String? symbol;
  String? image;
  String? asset;
  String? markets;
  String? margnumype;
  String? status;
  num? leverage;
  String? side;
  num? liquidationPrice;
  String? contractType;
  num? entryPrice;
  num? lastPrice;
  num? quantity;
  num? margin;
  num? marginRatio;
  num? maintenance_margin_ratio;
  num? markPrice;
  String? fromCurrency;
  String? toCurrency;
  num? realisedPnl;
  num? tradeQuantity;
  num? manumenanceMargin;
  num? closePrice;
  num? closeVol;
  num? maxOpennumerest;
  DateTime? createdDate;
  DateTime? modifiedDate;
  List<TpSlOrder>? tpSlOrders;
  String? typename;

  FuturePositionsData({
    this.id,
    this.userId,
    this.symbol,
    this.image,
    this.asset,
    this.markets,
    this.margnumype,
    this.status,
    this.leverage,
    this.side,
    this.liquidationPrice,
    this.contractType,
    this.entryPrice,
    this.lastPrice,
    this.quantity,
    this.margin,
    this.marginRatio,
    this.maintenance_margin_ratio,
    this.markPrice,
    this.fromCurrency,
    this.toCurrency,
    this.realisedPnl,
    this.tradeQuantity,
    this.manumenanceMargin,
    this.closePrice,
    this.closeVol,
    this.maxOpennumerest,
    this.createdDate,
    this.modifiedDate,
    this.tpSlOrders,
    this.typename,
  });

  factory FuturePositionsData.fromRawJson(dynamic str) =>
      FuturePositionsData.fromJson(json.decode(str));

  dynamic toRawJson() => json.encode(toJson());

  factory FuturePositionsData.fromJson(Map<dynamic, dynamic> json) =>
      FuturePositionsData(
        id: json["_id"],
        userId: json["userId"],
        symbol: json["symbol"],
        image: json["image"],
        asset: json["asset"],
        markets: json["markets"],
        margnumype: json["margin_type"],
        status: json["status"],
        leverage: json["leverage"],
        side: json["side"],
        liquidationPrice: json["liquidation_price"],
        contractType: json["contract_type"],
        entryPrice: json["entry_price"],
        lastPrice: json["last_price"],
        quantity: json["quantity"],
        margin: json["margin"],
        marginRatio: json["margin_ratio"],
        maintenance_margin_ratio: json["maintenance_margin_ratio"],
        markPrice: json["mark_price"],
        fromCurrency: json["from_currency"],
        toCurrency: json["to_currency"],
        realisedPnl: json["realised_pnl"],
        tradeQuantity: json["trade_quantity"],
        manumenanceMargin: json["manumenance_margin"],
        closePrice: json["close_price"],
        closeVol: json["close_vol"],
        maxOpennumerest: json["max_open_numerest"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        modifiedDate: json["modified_date"] == null
            ? null
            : DateTime.parse(json["modified_date"]),
        tpSlOrders: json["tp_sl_orders"] == null
            ? []
            : List<TpSlOrder>.from(
                json["tp_sl_orders"]!.map((x) => TpSlOrder.fromJson(x))),
        typename: json["__typename"],
      );

  Map<dynamic, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "symbol": symbol,
        "image": image,
        "asset": asset,
        "markets": markets,
        "margin_type": margnumype,
        "status": status,
        "leverage": leverage,
        "side": side,
        "liquidation_price": liquidationPrice,
        "contract_type": contractType,
        "entry_price": entryPrice,
        "last_price": lastPrice,
        "quantity": quantity,
        "margin": margin,
        "margin_ratio": marginRatio,
        "maintenance_margin_ratio": maintenance_margin_ratio,
        "mark_price": markPrice,
        "from_currency": fromCurrency,
        "to_currency": toCurrency,
        "realised_pnl": realisedPnl,
        "trade_quantity": tradeQuantity,
        "manumenance_margin": manumenanceMargin,
        "close_price": closePrice,
        "close_vol": closeVol,
        "max_open_numerest": maxOpennumerest,
        "created_date": createdDate?.toIso8601String(),
        "modified_date": modifiedDate?.toIso8601String(),
        "tp_sl_orders": tpSlOrders == null
            ? []
            : List<dynamic>.from(tpSlOrders!.map((x) => x.toJson())),
        "__typename": typename,
      };
}

class TpSlOrder {
  num? stopPrice;
  String? counterId;
  String? takeProfitOrder;
  String? stopLossOrder;
  String? orderType;
  String? typename;

  TpSlOrder({
    this.stopPrice,
    this.counterId,
    this.takeProfitOrder,
    this.stopLossOrder,
    this.orderType,
    this.typename,
  });

  factory TpSlOrder.fromRawJson(dynamic str) =>
      TpSlOrder.fromJson(json.decode(str));

  dynamic toRawJson() => json.encode(toJson());

  factory TpSlOrder.fromJson(Map<dynamic, dynamic> json) => TpSlOrder(
        stopPrice: json["stop_price"],
        counterId: json["counterId"],
        takeProfitOrder: json["take_profit_order"],
        stopLossOrder: json["stop_loss_order"],
        orderType: json["order_type"],
        typename: json["__typename"],
      );

  Map<dynamic, dynamic> toJson() => {
        "stop_price": stopPrice,
        "counterId": counterId,
        "take_profit_order": takeProfitOrder,
        "stop_loss_order": stopLossOrder,
        "order_type": orderType,
        "__typename": typename,
      };
}
