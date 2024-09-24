FutureQueries futureQueries = FutureQueries();

class FutureQueries {
  var fetchDeliveryData = r'''
query fetchDeliveryData($data:fetchDeliveryDataInput){
  fetchDeliveryData(fetchDeliveryDataInput:$data){
    status_code
    status_message
    result{
      symbol
      markets
      delivery_date
      delivery_price
    }
  }
}
''';

  var fetchIndexAndMarkPrice = r'''
query fetchIndexAndMarkPrice($data:fetchIndexAndMarkPriceInput){
  fetchIndexAndMarkPrice(fetchIndexAndMarkPriceData:$data){
    status_code
    status_message
    result{
      page
      total
      data{
        symbol
        index_price
        mark_price
        created_date
      }
    }
  }
}
''';

  var fetchPremiumIndexPrice = r'''
query fetchPremiumIndexPrice($data:fetchPremiumIndexPriceInput){
  fetchPremiumIndexPrice(fetchPremiumIndexPriceData: $data){
    status_code
    status_message
    result{
      page
      total
      data{
        symbol
        premium_index
        created_date
      }
    }
  }
}
''';

  var fetchFutureInsuranceFundsHistory = r'''
query fetchFutureInsuranceFundsHistory($fetchInsuranceData: fetchFutureInsuranceFundsHistoryInput) {
  fetchFutureInsuranceFundsHistory(fetchFutureInsuranceFundsHistoryData: $fetchInsuranceData) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        amount
        date
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  var fetchFundingRateHistory = r'''
query fetchFundingRateHisotry($fetchfundingData: fetchFundingRateHisotryInput) {
  fetchFundingRateHisotry(fetchFundingRateHisotryData: $fetchfundingData) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        asset
        symbol
        funding_interval
        funding_rate
        created_date
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  var fetchTradingAndFundingAnalysis = r'''
query fetchTradingAndFundingAnalysis($data: fetchTradingAndFundingAnalysisInput) {
  fetchTradingAndFundingAnalysis(fetchTradingAndFundingAnalysisData:$data){
    status_code
    status_message
    result{
        total_funding_fee
        total_transaction_fee
        daily_funding_fee
        paidAndReceived
        assets_transaction_fee
    }
  }
}
''';

  var fetchFuturePnlAnalysis = r'''
query fetchFuturePnlAnalysis($data: fetchFuturePnlAnalysisInput) {
  fetchFuturePnlAnalysis(fetchFuturePnlAnalysisData:$data){
    status_code
    status_message
    result{
      total_profit
      total_loss
      net_profit_loss
      winning_days
      losing_days
      breaking_days
      win_rate
      average_profit
      average_loss
      profit_loss_ratio
    }
  }
}
''';

  var fetchFuturePnl = r'''
query fetchFuturePnl($data: fetchFuturePnlInput){
  fetchFuturePnl(fetchFuturePnlData:$data){
   status_code
    status_message
    result{
      total
      data{
        markets
        daily_pnl
        cummulative_pnl
        cummulatiive_pnl_percent
        initial_balance
        net_transfer
        created_date
      }
    }
  }
}
''';

  var walletConvert = r'''
mutation walletConvert($data: walletConvertInput) {
  walletConvert(walletConvertData: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  var fetchFuturePositions = r'''
query fetchFuturePositions($futurePositionData: fetchFuturePositionsInput) {
  fetchFuturePositions(fetchFuturePositionsData: $futurePositionData) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        _id
        userId
        symbol
        image
        asset
        markets
        margin_type
        status
        leverage
        side
        liquidation_price
        contract_type
        entry_price
        quantity
        margin
        margin_ratio
        mark_price
        from_currency
        to_currency
        realised_pnl
        trade_quantity
        maintenance_margin
        close_price
        close_vol
        max_open_interest
        created_date
        modified_date
        tp_sl_orders {
          stop_price
          counterId
          take_profit_order
          stop_loss_order
          order_type
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

  var getFutureWallet = r'''
  query getFutureWallet($fetchFutureWalletData: getFutureWalletInput) {
  getFutureWallet(getFutureWalletData: $fetchFutureWalletData) {
    status_code
    status_message
    result {
      markets
      currency_code
      image
      currency_name
      available_balance
      inorder_balance
      default_total_balance
      default_available_balance
      default_unrealized_pnl
      total_balance
      unrealized_pnl
      available_exchange_balance
      total_exchange_balance
      unrealized_pnl_exchange_balance
      __typename
    }
    __typename
  }
}
''';

  var fetchUserPreference = r'''query fetchUserPreference {
  fetchUserPreference {
    status_code
    status_message
    result {
      usds {
        position_mode
        price_protection
        asset_mode
        order_confirmation
        __typename
      }
      coin {
        position_mode
        price_protection
        asset_mode
        order_confirmation
        __typename
      }
      notification {
        tp_sl_trigger
        funding_fee_trigger
        customise_fee
        __typename
      }
      cooling_period {
        enabled
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

  final fetchContractDetails = r'''
query fetchContractDetails($fetchContractData: fetchContractDetailsInput) {
  fetchContractDetails(fetchContractDetailsData: $fetchContractData) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        to_currency_code
        from_currency_code
        symbol
        markets
        contract_type
        status
        min_trade_amount
        max_trade_amount
        last_price
        last_price_percent
        high_24h
        low_24h
        change_24h
        change_percent
        volume_24h
        volume_24h_from
        index_price
        maker_fee
        taker_fee
        contract_multiplier
        funding_rate
        mark_price
        price_change_percentage
        price_protection_limit
        liquidation_fee
        min_notional_value
        max_leverage
        interest_rate
        bid_buffer
        ask_buffer
        price_percision
        min_price_movement
        limit_order_price_cap
        market_order_price_cap
        max_limit_order_amount
        max_market_order_amount
        current_funding_rate
        max_open_orders
        delivery_price
        max_amend_amout
        delivery_date
        created_date
        modified_date
        reduce_only_trigger {
          open_positions_notional_value
          position_to_total_ratio
          liquidation_and_mark_price_gap
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

  final updateFutureFavSymbol =
      r'''mutation updateFutureFavSymbol($data: updateFutureFavSymbolInput) {
  updateFutureFavSymbol(updateFutureFavSymbolData: $data) {
    status_code
    status_message
    result {
      isfav
      __typename
    }
    __typename
  }
}
''';

  final getUserFavSymbol = r'''query getUserFavSymbol {
  getUserFavSymbol {
    status_code
    status_message
    result {
      symbol
      isfav
      change_percent
      markets
      __typename
    }
    __typename
  }
}
''';

  final fetchFutureLeverage =
      r'''query fetchFutureLeverage($marginLeverageData: fetchFutureLeverageInput) {
  fetchFutureLeverage(fetchFutureLeverageData: $marginLeverageData) {
    status_code
    status_message
    result {
      markets
      symbol
      leverage_data {
        tier_lower_limit
        tier_upper_limit
        max_leverage
        maintenance_margin_rate
        maintenance_amount
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final updatePositionLeverage =
      r'''mutation updatePositionLeverage($data: updatePositionLeverageInput) {
  updatePositionLeverage(updatePositionLeverageData: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final getFutureOrderBook =
      r'''query getFutureOrderBook($orderBookData: getFutureOrderBookInput) {
  getFutureOrderBook(getFutureOrderBookData: $orderBookData) {
    status_code
    status_message
    result {
      bids
      asks
      __typename
    }
    __typename
  }
}
''';

  final createFutureLiquidationPrice =
      r'''query getFutureLiquidationPrice($data: getFutureLiquidationPriceInput) {
    getFutureLiquidationPrice(getFutureLiquidationPriceData: $data){
    status_code
    status_message
    result
  }
  }
  ''';

  final getFutureOpenOrder =
      r'''query getFutureOpenOrder($getFutureOpenOrderDetails: getFutureOpenOrderInput) {
  getFutureOpenOrder(getFutureOpenOrderData: $getFutureOpenOrderDetails) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        _id
        symbol
        order_type
        trade_type
        contract_type
        from_currency
        to_currency
        delivery_date
        markets
        margin_type
        trigger_condition
        callback_rate
        market_price
        stop_price
        limit_price
        amount
        initial_amount
        ordered_amount
        partial_amount
        total
        cost
        userId
        status
        cancelled_date
        leverage
        take_profit_order
        stop_loss_order
        reduce_only_order
        ordered_date
        traded_date
        __typename
      }
      __typename
    }
    __typename
  }
}''';

  final getFutureTradeHistory =
      r'''query getFutureTradeHistory($getTradeHistoryDetails: getFutureTradeHistoryInput) {
  getFutureTradeHistory(getFutureTradeHistoryData: $getTradeHistoryDetails) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        role
        markets
        transaction_id
        contract_type
        from_currency
        to_currency
        delivery_date
        realized_pnl
        amount
        price
        total
        filled_amount
        symbol
        order_type
        trade_type
        admin_fee_percentage
        admin_fee_amount
        margin_type
        liquidation_order
        created_date
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final getTransactionHistory =
      r'''query getTransactionHistory($transactionHistoryData: getTransactionHistoryInput) {
  getTransactionHistory(getTransactionHistoryData: $transactionHistoryData) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        currency_code
        amount
        wallet
        type
        userId
        pair
        created_date
        modified_date
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final getFutureCurrency = r'''query getFutureCurrency {
  getFutureCurrency {
    status_code
    status_message
    result {
      image
      status
      deposit_status
      withdraw_status
      trade_status
      name
      code
      type
      coin_type
      featured
      future_settings
      __typename
    }
    __typename
  }
}
''';

  final fetchFundingFeeHistory =
      r'''query fetchFundingFeeHisotry($fundingFeeData: fetchFundingFeeHisotryInput) {
  fetchFundingFeeHisotry(fetchFundingFeeHisotryData: $fundingFeeData) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        markets
        side
        symbol
        asset
        amount
        funding_rate
        created_date
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final getFutureHistoricalTrades =
      r'''query getFutureHistoricalTrades($tradeHistoryData: getFutureHistoricalTradesInput) {
  getFutureHistoricalTrades(getFutureHistoricalTradesData: $tradeHistoryData) {
    status_code
    status_message
    result {
      price
      qty
      side
      created_date
      __typename
    }
    __typename
  }
}
''';

  final multiAssetsTable = r'''query multiAssetsTable {
  multiAssetsTable {
    status_code
    status_message
    result {
      asset
      collateral_ratio
      maximum_transfer_in
      threshold
      haircut
      bid_buffer
      ask_buffer
      __typename
    }
    __typename
  }
}
''';

  final multiAssetsExchageRateTable = r'''query multiAssetsExchageRateTable {
  multiAssetsExchageRateTable {
    status_code
    status_message
    result {
      pair
      ask_ratio
      bid_ratio
      index_price
      bid_buffer
      ask_buffer
      __typename
    }
    __typename
  }
}
''';

  final fetchOpenInterest =
      r'''query fetchOpenInterest($openInterestData: fetchTopTraderAccountRatioInput) {
  fetchOpenInterest(fetchTopTraderAccountRatioData: $openInterestData) {
    status_code
    status_message
    result {
      date
      long_percent
      short_percent
      ratio
      open_interest
      notional_value
      __typename
    }
    __typename
  }
}
''';

  final fetchTopTraderAccountRatio =
      r'''query fetchTopTraderAccountRatio($longShortAccountData: fetchTopTraderAccountRatioInput) {
  fetchTopTraderAccountRatio(fetchTopTraderAccountRatioData: $longShortAccountData) {
    status_code
    status_message
    result {
      date
      long_percent
      short_percent
      ratio
      open_interest
      notional_value
      __typename
    }
    __typename
  }
}
''';

  final fetchTopTraderPositionRatio =
      r'''query fetchTopTraderPositionRatio($longShortPositionData: fetchTopTraderAccountRatioInput) {
  fetchTopTraderPositionRatio(fetchTopTraderAccountRatioData: $longShortPositionData) {
    status_code
    status_message
    result {
      date
      long_percent
      short_percent
      ratio
      open_interest
      notional_value
      __typename
    }
    __typename
  }
}
''';

  final fetchTakerBuySellVolume =
      r'''query fetchTakerBuySellVolume($takerBuySellData: fetchTopTraderAccountRatioInput) {
  fetchTakerBuySellVolume(fetchTopTraderAccountRatioData: $takerBuySellData) {
    status_code
    status_message
    result {
      date
      long_percent
      short_percent
      ratio
      open_interest
      notional_value
      __typename
    }
    __typename
  }
}
''';
}
