class CreateOrder {
  CreateOrder({
    this.order_type,
    this.trade_type,
    this.pair,
    this.amount,
    this.market_price,
    this.stop_price,
    this.limit_price,
    this.total,
    this.borrow,
    this.repay,
    this.callBackRate,
  });

  //common for all order type
  String? order_type;
  String? trade_type;
  String? pair;
  double? amount;

  double? market_price; // for Limit only - stands for Limit
  double? stop_price; // for Stop Limit only
  double? limit_price; // for Stop Limit only
  double? total; // for Limit & Stop Limit only

  double? borrow; // for Stop Limit only
  double? repay; // for Limit & Stop Limit only
  double? callBackRate; // call back rate for trailing stop
}
