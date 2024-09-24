TokenSaleQueries tokenSaleQueries = TokenSaleQueries();

class TokenSaleQueries {
  final getICOBanners = r'''
query getICOBanners {
  getICOBanners {
    status_code
    status_message
    result {
      name
      webBannerImage
      bannerLink
      __typename
    }
    __typename
  }
}
  ''';

  final getICOCurrency = r'''
query getICOCurrency {
  getICOCurrency {
    status_code
    status_message
    result {
      name
      code
      network
      defaultExchangeRate
      isICOSwapCurrency
      isPairedCurrency
      currencyDetails {
        from_currency_code
        to_currency_code
        exchange_rate
        __typename
      }
      __typename
    }
    __typename
  }
}
  ''';

  final createTokenSale = r'''
mutation createTokenSale($data: tokenSaleInput) {
  createTokenSale(tokenSaleInput: $data) {
    status_code
    status_message
    error
    __typename
  }
}
''';

  final getUserTokenSaleHistory = r'''
mutation getUserTokenSaleHistory($data: tokenSaleHistoryInput) {
  getUserTokenSaleHistory(tokenSaleHistoryInput: $data) {
    status_code
    error
    status_message
    result {
      data {
        fromAmount
        toAmount
        createdAt
        fromCurrencyDetails {
          code
          __typename
        }
        toCurrencyDetails {
          code
          __typename
        }
        __typename
      }
      total
      limit
      page
      pages
      __typename
    }
    __typename
  }
}
''';
}
