MarketQueries marketQueries = MarketQueries();

class MarketQueries {
  final getTradePairs = r''' 
query getAllTradePairs($data: getFeaturedTradePairsInput) {
    getAllTradePairs(getFeaturedTradePairsData: $data) {
      status_code
      status_message
      result {
        symbol
        lastPrice
        priceChange
        priceChangePercent
        highPrice
        lowPrice
        quoteVolume
      }
    }
  }
''';

final getTradeChartData = r'''
query getKlines($data: getKlinesInput!){
  getKlines(getKlinesData: $data){
    status_code
    status_message
    result
  }
}
''';
  final getAdminBankDetail = r'''
  query getAdminBankDetails {
  getAdminBankDetails {
    status_code
    status_message
    result {
      admin_account_name
      admin_account_number
      bank_name
      bank_routing_sort_code
      bank_swift_bic_code
      bank_address
      bank_state
      bank_country
      bank_postal_zip_code
      __typename
    }
    __typename
  }
}
 ''';
  var getBraintreeClientToken = r'''
query
getBraintreeClientToken{
  getBraintreeClientToken{
    status_code
    status_message
    result {
      clientToken
      success
    }
  }
}
''';
  final getReferralDashboard = r'''
  query getReferralDashboard($data: getReferralDashboardInput) {
  getReferralDashboard(getReferralDashboardData: $data) {
    status_code
    status_message
    result {
      you_earned
      total_traded_friends
      total_friends
      referral_default_currency
      __typename
    }
    __typename
  }
}
''';

  final getBankDetailsHistory = r'''
 query getBankDetails {
  getBankDetails {
    status_code
    status_message
    result {
      bank_details
      __typename
    }
    __typename
  }
}
''';
  final getBalance = r'''  query getBalance($data: getBalanceInput) {
  getBalance (getBalanceData: $data){
    status_code
    status_message
    result {
      image
      currency_code
      currency_name
      currency_type
      deposit_status
      withdraw_status
      trade_status
      stake_balance
      available_balance
      inorder_balance
      total_balance
      BTCValue
      USDValue
      defaultCryptoValue
      status
      __typename
    }
    __typename
  }
}

  ''';

  final defaultCurrency = r'''query getDefaultCurrency {
  getDefaultCurrency {
    status_code
    status_message
    result {
      fiat_default_currency
      crypto_default_currency
      site_name
      site_logo
      favicon
      site_banner
      site_description
      banner_title
      crypto_currency_api_key
      binance_status
      join_us {
        Facebook
        Twitter
        Linkedin
        Youtube
        Instagram
        Play_store
        App_store
        contact_mail
        support_mail
        __typename
      }
      recaptcha {
        recaptcha_sitekey
        recaptcha_secretkey
        __typename
      }
      referral_settings {
        earning_limit
        commission_percentage
        referral_link_limit
        referral_default_currency
        __typename
      }
      site_maintenance
      __typename
    }
    __typename
  }
}
 ''';

  final getExchangeRate = r''' 
query getExchangeRate($data: getExchangeRateDataInput) {
  getExchangeRate(getExchangeRateData: $data) {
    status_code
    status_message
    result {
      _id
      from_currency_code
      to_currency_code
      exchange_rate
      __typename
    }
    __typename
  }
}
 ''';
  final getReferralLinks = r'''
 query getReferralLinks {
  getReferralLinks {
    status_code
    status_message
    result {
      _id
      user_id
      referral_id
      you_receive
      friends_receive
      note
      default
      invite_qr
      noOfFriends
      friendsDetails {
        email
        created_date
        __typename
      }
      created_date
      modified_date
      __typename
    }
    __typename
  }
}

  ''';
  final getReferralId = r'''
query getReferralLinkByReferralID($data: getRefLinkByRefIDInput) {
  getReferralLinkByReferralID(getRefLinkByRefIDData: $data) {
    status_code
    status_message
    result {
      _id
      user_id
      referral_id
      you_receive
      friends_receive
      created_date
      modified_date
      __typename
    }
    __typename
  }
}

  ''';
  final getTFA = r'''
  {
  gettfa {
    status_code
    status_message
    result {
      secret
      url
      __typename
    }
    __typename
  }
}

   ''';

  final inorderBalance = r''' 
  query inOrderBalance($data: inorderInput) {
  inOrderBalance(inorderInput: $data) {
    status_code
    status_message
    result {
      inorderBalance
      availableBalance
      totalBalance
      __typename
    }
    __typename
  }
}
''';

  final cryptoCurrency = r''' 
 query getCurrency {
  getCurrency {
    status_code
    status_message
    result {
      image
      currency_code
      #min_withdraw_limit
      #withdraw_fee
      #max_withdraw_limit
      network
      #withdraw_24h_limit
      __typename
    }
    __typename
  }
}

 ''';

  final fiatInorderBalance = r'''
  query FiatInOrderBalance($data: inorderInput) {
  FiatInOrderBalance(inorderInput: $data) {
    status_code
    status_message
    result {
      inorderBalance
      availableBalance
      totalBalance
      __typename
    }
    __typename
  }
}
 ''';

  final findBtcAddress = r'''
  query findBTCAddress {
  findBTCAddress {
    status_code
    status_message
    result {
      address
      qr_Code
      __typename
    }
    __typename
  }
}
 ''';

  final findEthAddress = r'''
  query findETHAddress {
  findETHAddress {
    status_code
    status_message
    result {
      address
      qr_Code
      __typename
    }
    __typename
  }
}
 ''';

  final findLtcAddress = r'''
  query findLTCAddress {
  findLTCAddress {
    status_code
    status_message
    result {
      address
      qr_Code
      __typename
    }
    __typename
  }
}
 ''';

  final btcAddress = r''' 
 query findBTCAddress {
  findBTCAddress {
    status_code
    status_message
    result {
      address
      qr_Code
      __typename
    }
    __typename
  }
}
''';

  final ethAddress = r''' query findETHAddress {
  findETHAddress {
    status_code
    status_message
    result {
      address
      qr_Code
      __typename
    }
    __typename
  }
}
''';

  final xrpAddress = r'''query findXRPAddress {
  findXRPAddress {
    status_code
    status_message
    result {
      address
      qr_Code
      tag_id
      __typename
    }
    __typename
  }
} ''';

  final ltcAddress = r''' 
query findLTCAddress {
  findLTCAddress {
    status_code
    status_message
    result {
      address
      qr_Code
      __typename
    }
    __typename
  }
}
''';

  final bnbAddress = r''' 
{
  findBNBAddress{
    status_code
    status_message
    result{
      address
      qr_Code
    }
  }
}''';

  final solAddress = r''' 
  query findSOLAddress {
  findSOLAddress {
    status_code
    status_message
    result {
      address
      qr_Code
      __typename
    }
    __typename
  }
}
''';

  final dotAddress = r'''
{
  findDOTAddress{
    status_code
    status_message
    result{
      address
      qr_Code
    }
  }
}
''';

  final ulxAddress = r'''
{
  findULXAddress{
    status_code
    status_message
    result{
      address
      qr_Code
    }
  }
}
''';

  final adaAddress = r''' 
  query findADAAddress {
  findADAAddress {
    status_code
    status_message
    result {
      address
      qr_Code
      __typename
    }
    __typename
  }
}
''';

  final maticAddress = r''' 
  query findMATICAddress {
  findMATICAddress {
    status_code
    status_message
    result {
      address
      qr_Code
      __typename
    }
    __typename
  }
}

  ''';

  final dogeAddress = r''' 
  query findDOGEAddress {
  findDOGEAddress {
    status_code
    status_message
    result {
      address
      qr_Code
      __typename
    }
    __typename
  }
}
''';

  final getCurrency = r'''
query getCurrency {
  getCurrency {
    status_code
    status_message
    result {
      image
      currency_code
      min_withdraw_limit
      withdraw_fee
      network
      __typename
    }
    __typename
  }
}
 ''';

  final paymentExchangeRate = r'''
  query getPaymentCurrencyExchangeRate($data: getPayCurrencyExRateInput) {
  getPaymentCurrencyExchangeRate(getPayCurrencyExRateData: $data) {
    status_code
    status_message
    result {
      from_currency_code
      to_currency_code
      exchange_rate
      __typename
    }
    __typename
  }
}
 ''';

  final getFiatCurrency = r'''
  query getFiatCurrency {
  getFiatCurrency {
    status_code
    status_message
    result {
      currency_code
      min_withdraw_limit
      withdraw_fee
      __typename
    }
    __typename
  }
}
 ''';

  final CryptoWithdrawHistoryDetails = r'''
  query cryptoWithdrawHistory($cryptoWithdrawHistoryData: cryptoWithdrawHistoryInput) {
  cryptoWithdrawHistory(cryptoWithdrawHistoryData: $cryptoWithdrawHistoryData) {
    status_code
    status_message
    result {
      data {
        from_address
        to_address
        sent_amount
        received_amount
        type
        amount_mob
        status
        admin_fee
        created_date
        currency_code
        transaction_id
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

  final CryptoDepositHistoryDetails = r'''
  query getCryptoDepositHistory($cryptoDepositHistoryData: cryptoDepositHistoryInput) {
  getCryptoDepositHistory(cryptoDepositHistoryData: $cryptoDepositHistoryData) {
    status_code
    status_message
    result {
      data {
        status
        transaction_id
        currency_code
        address
        type
        amount_mob
        amount
        user_amount
        admin_amount
        created_date
        modified_date
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

  final getFiatWithdrawHistoryDetails = r''' 
  query getFiatWithdrawHistory {
  getFiatWithdrawHistory {
    status_code
    status_message
    result {
      currency_code
      status
      sent_amount
      admin_fee
      received_amount
      transaction_id
      modified_date
      type
      amount_mob
      __typename
    }
    __typename
  }
}
''';


  final getMarketCurrency = r'''
{
  getMarketCurrency{
    status_code
    status_message
    result{
      currency_type
      currency_code
    }
  }
}
''';

  final getFiatDepositHistoryDetails = r'''
  query FiatDepositHistory {
  FiatDepositHistory {
    status_code
    status_message
    result {
      currency_code
      transaction_id
      pay_mode
      status
      amount
      modified_date
      type
      amount_mob
      __typename
    }
    __typename
  }
}
 ''';

  final getPriceTickers = r'''
query getTicker($input: getTickerInput!) {
  getTicker(getTickerData: $input) {
    status_code
    status_message
    result {
      symbol
      lastPrice
      priceChange
      priceChangePercent
      highPrice
      lowPrice
      quoteVolume
      exchange_rates
    }
  }
}
 ''';
  final openOrderHistory = r'''
query openOrderHistory {
  openOrderHistory {
    status_code
    status_message
    result {
      amount
      market_price
      total
      pair
      _id
      trade_type
      order_type
      partial_amount
      stop_price
      limit_price
      trigger_price
      ordered_amount
      initial_amount
      ordered_date
      status
      __typename
    }
    __typename
  }
}
 ''';
  final tradeHistory = r'''
query tradeHistory($tradeTransactionHistoryData: tradeTransactionHistoryInput) {
  tradeHistory(tradeTransactionHistoryData: $tradeTransactionHistoryData) {
    status_code
    status_message
    result {
      data {
        _id
        amount
        price
        total
        filled_amount
        pair
        trade_type
        order_type
        admin_fee_percentage
        admin_fee_amount
        created_date
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
  final getTradeOrder = r'''
query getTradeOrder($tradeOrderQueryData: getTradeOrderInput) {
  getTradeOrder(getTradeOrderData: $tradeOrderQueryData) {
    status_code
    status_message
    result {
      data {
        _id
        amount
        market_price
        admin_fee_percentage
        admin_fee_amount
        total
        trade_type
        order_type
        pair
        status
        partial_amount
        initial_amount
        stop_price
        limit_price
        trigger_price
        ordered_date
        traded_date
        cancelled_date
        user_id
        user_email
        user {
          email
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
  final cancelOrder = r'''
mutation cancelOrder($data: cancelOrderInput) {
  cancelOrder(cancelOrderInput: $data) {
    status_code
    status_message
    __typename
  }
}
 ''';

  final orderBook = r'''
query getOrderBookDepth($input: getOrderBookDepthInput) {
  getOrderBookDepth(getOrderBookDepthData: $input) {
    status_code
    status_message
    result {
      bids
      asks
    }
  }
}
''';
  final marketTrades = r'''
query getHistoricalTrades($data: getHistoricalTradesInput!){
  getHistoricalTrades(getHistoricalTradesData: $data){
    status_code
    status_message
    result{
      price
      qty
      side
    }
  }
}
''';
  final yoursTrades = r'''
query getYoursHistory($input: getYoursHistoryInput!) {
  getYoursHistory(getYoursHistoryData: $input) {
    status_code
    status_message
    result {
      price
      qty
      side
    }
  }
}
''';
}
