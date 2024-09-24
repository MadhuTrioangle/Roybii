class CreateOrder {
  CreateOrder({
    required this.order_type,
    required this.trade_type,
    required this.pair,
    required this.amount,
    this.market_price,
    this.stop_price,
    this.limit_price,
    this.total,
  });

  //common for all order type
  String order_type;
  String trade_type;
  String pair;
  double amount;

  double? market_price; // for Limit only - stands for Limit
  double? stop_price; // for Stop Limit only
  double? limit_price; // for Stop Limit only
  double? total; // for Limit & Stop Limit only
}
