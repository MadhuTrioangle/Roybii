MarketQueries marketQueries = MarketQueries();

class MarketQueries {
  final getMerchantAllInvoice = r'''
query getMerchantAllInvoice($data: getMerchantAllInvoiceInput) {
  getMerchantAllInvoice(getMerchantAllInvoiceInput: $data) {
    status_code
    status_message
    result {
      total
      data {
        _id
        invoiceId
        currency
        merchantName
        merchantPayId
        clientName
        clientEmail
        clientAddress
        itemsOverallAmount
        itemsTaxAmount
        invoiceType
        paymentDate
        transactionId
        saleItemInfo {
          item
          itemDescription
          itemPerPrice
          itemQuantity
          itemTotalAmount
          discount
          discountType
          __typename
        }
        invoiceDueRecuringValue
        invoiceDueRecurringType
        invoiceDueTimeZone
        invoiceDueDate
        createdAt
        status
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final deleteAccount = r'''mutation ($data: deleteAccountInput) {
  deleteAccount(deleteAccountInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final getMerchantPaymentLink = r'''
query getMerchantPaymentLink($data: getMerchantPaymentLinkInput) {
  getMerchantPaymentLink(getMerchantPaymentLinkInput: $data) {
    status_code
    status_message
    result {
      total
      data {
        _id
        merchantName
        merchantEmail
        merchantPayId
        currency
        payAmount
        paymentLink
        paymentLinkId
        paymentLinkReference
        paymentLinkType
        paymentLinkType
        productName
        productType
        productDetail
        totalNoOfPayments
        remainingNoOfPayments
        status
        createdAt
        validityDate
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

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
        leverage_isolated
        enable_margin_isolated
        enable_margin_cross
      }
    }
  }
''';

  final getSpotMarket = r'''query getSpotMarket($data: getSpotMarketInput) {
  getSpotMarket(getSpotMarketInput: $data) {
    status_code
    status_message
    fiatCurrency
    result {
      pair
      code
      modified_pair
      image
      market
      change_percent
      low_24h
      fav
      high_24h
      volume_24h
      price
      leverage
      exchange_rates {
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

  final getFutureMarket =
      r'''query getFutureMarket($data: getFutureMarketInput) {
  getFutureMarket(getFutureMarketInput: $data) {
    status_code
    status_message
    result {
      symbol
      contract_type
      price
      low_24h
      high_24h
      volume_24h
      fav
      to_currency_code
      from_currency_code
      change_percent
      exchange_rates {
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

  final getFavoriteMarkets = r'''query getFavoriteMarkets {
  getFavoriteMarkets {
    status_code
    status_message
    result {
      spot {
        pair
        price
        modified_pair
        change_percent
        high_24h
        low_24h
        volume_24h
        leverage
        exchange_rates {
          to_currency_code
          exchange_rate
          __typename
        }
        __typename
      }
      margin {
        pair
        modified_pair
        price
        change_percent
        high_24h
        low_24h
        volume_24h
        leverage
        exchange_rates {
          to_currency_code
          exchange_rate
          __typename
        }
        __typename
      }
      future {
        contract_type
        markets
        symbol
        price
        change_percent
        contract_type
        high_24h
        low_24h
        volume_24h
        exchange_rates {
          to_currency_code
          exchange_rate
          __typename
        }
        __typename
      }
      __typename
    }
    __typename
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
      setback_rate
      trade_status
      stake_balance
      #mlm_stakeBalance
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
      #User_pay_signContract_document
      default_pairs {
       spot_default_pair
      }
      fiat_default_currency
      crypto_default_currency
      site_name
      site_logo
      favicon
      site_banner
      binance_status
      site_description
      banner_title
      crypto_currency_api_key
      join_us {
        Facebook
        Twitter
        Linkedin
        Youtube
        Instagram
        Play_store
        App_store
        contact_mail
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
      site_maintenance_settings {
        status
        start_date
        end_date
        __typename
      }
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

  final getCurrency = r'''query getCurrency {
  getCurrency {
    status_code
    status_message
    result {
      currency_name
      currency_type
      network
      currency_code
      min_withdraw_limit
      withdraw_fee
      defaultExchangeRate
      USDExchangeRate
      image
      max_withdraw_limit
      withdraw_24h_limit
      coin_type
      confirmations
      network_details {
        network
        withdraw_fee
        min_withdraw_limit
        max_withdraw_limit
        withdraw_24h_limit
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final getMarketOverview = r''' query getMarketOverview {
   getMarketOverview {
      status_code
          status_message
             result {
             highlight {
                 image      
                    code     
                  price     
                  change_percent    
                  exchange_rates {     
                  to_currency_code  
                   exchange_rate
                    __typename    
                    }    
       __typename  
              }  
                gainer {
               image    
                code   
               price  
                  change_percent   
               exchange_rates {    
            to_currency_code   
                exchange_rate 
       __typename
                   }
          __typename
             }
                    volume {      
                      image
                       code 
                      price 
                    change_percent    
                      volume_24h   
                        exchange_rates {   
                     to_currency_code   
                         exchange_rate
                      __typename  
                       }   
                     __typename    
                      }  
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
  final tradeHistory =
      r'''query tradeHistory($tradeTransactionHistoryData: tradeTransactionHistoryInput) {
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
  final getTradeOrder =
      r'''query getTradeOrder($tradeOrderQueryData: getTradeOrderInput) {
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

  final getUserFavTradePair = r'''
query getUserFavTradePair {
  getUserFavTradePair {
    status_code
    status_message
    result {
      pair
      isfav
      __typename
    }
    __typename
  }
}
''';

  final getUserFundingWalletDetails = r'''
{
  getUserFundingWalletDetails {
    status_code
    status_message
    result {
      amount
      inorder
      currency_code
      converted_amount
      converted_currency_code
      currency_logo
      currency_type
    }
  }
}
''';
}
