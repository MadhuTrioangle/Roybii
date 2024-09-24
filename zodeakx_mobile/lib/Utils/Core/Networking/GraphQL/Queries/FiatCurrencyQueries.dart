
FiatCurrencyQueries fiatCurrencyQueries = FiatCurrencyQueries();

class FiatCurrencyQueries{
  final getFiatCurrency = r''' 
query getFiatCurrency {
  getFiatCurrency {
    status_code
    status_message
    result {
      currency_code
      currency_name
      min_withdraw_limit
      withdraw_fee
      __typename
    }
    __typename
  }
}
''';
}

