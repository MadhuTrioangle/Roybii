MarginTradingQueries marginTradingQueries = MarginTradingQueries();

class MarginTradingQueries {
  final allOpenOrderHistory = r'''
query allOpenOrderHistory($allHistoryData: allHistoryInput) {
  allOpenOrderHistory(allHistoryData: $allHistoryData) {
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
      margin_order
      margin_type
      liquidation_order
      __typename
    }
    __typename
  }
}
''';

  final fetchIsolatedPositions = r'''
query fetchIsolatedPositions($fetchIsolatedPositionsData: fetchMarginWalletInput) {
  fetchIsolatedPositions(fetchIsolatedPositionsData: $fetchIsolatedPositionsData) {
    status_code
    status_message
    result {
      pair
      risk_ratio
      index_price
      liquidation_price
      wallet {
        coin
        image
        position
        position_value
        position_pnl
        interest_rate
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final fetchAllCrossPositions = r'''
query fetchAllCrossPositions($fetchCrossPositionsData: fetchMarginWalletInput) {
  fetchAllCrossPositions(fetchCrossPositionsData: $fetchCrossPositionsData) {
    status_code
    status_message
    result {
      coin
      image
      position
      position_value
      index_price
      liquidation_price
      interest_rate
      __typename
    }
    __typename
  }
}
''';

  final fetchUserWalletPnl = r'''
query fetchUserWalletPnl($fetchPnlData: fetchPnlInput) {
  fetchUserWalletPnl(fetchPnlData: $fetchPnlData) {
    status_code
    status_message
    result {
      daily_pnl
      cross_leverage
      initial_risk_ratio_cross
      mcr_cross
      liquidation_ratio_cross
      mcr_isolated {
        x3
        x5
        x10
        __typename
      }
      initial_risk_ratio_isolated {
        x3
        x5
        x10
        __typename
      }
      liquidation_ratio_isolated {
        x3
        x5
        x10
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final fetchCrossMarginWallet = r'''
query fetchCrossMarginWallet($fetchMarginWalletData: fetchMarginWalletInput) {
  fetchCrossMarginWallet(fetchMarginWalletData: $fetchMarginWalletData) {
    status_code
    status_message
    result {
      margin_ratio
      auto_topup
      total_balance
      total_crypto
      borrowed_crypto
      currency
      available_balance
      borrowed
      interest
      equity
      equity_crypto
      modified_date
      currency_image
      __typename
    }
    __typename
  }
}
''';

  final fetchUserMarginSettings = r'''query fetchUserMarginSettings {
  fetchUserMarginSettings {
    status_code
    status_message
    result {
      userId
      margin_call_ratio_cross
      borrowing_cooling_off_period
      cooling_off_period_start
      cooling_off_period_end
      margin_call_ratio_isolated {
        x10
        x5
        x3
        __typename
      }
      __typename
    }
    __typename
  }
}''';

  final getUserFundingWalletDetails = r'''{
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
}''';

  final getMarginWallet = r'''query getMarginWallet($getMarginWalletData: getMarginWalletInput) {
  getMarginWallet(getMarginWalletData: $getMarginWalletData) {
    status_code
    status_message
    result {
      total
      limit
      page
      pages
      total_active_pairs
      data {
        pair
        auto_topup
        isolated_wallet
        margin_ratio
        status
        created_date
        modified_date
        status_updated
        wallet {
          currency_code
          available_balance
          borrowed
          interest
          __typename
        }
        auto_topup_list {
          firstCurr
          secondCurr
          thirdCurr
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

  final getMarginTradepairs = r'''query getMarginTradepairs($getMarginTradepairsData: getMarginTradepairsInput) {
  getMarginTradepairs(getMarginTradepairsData: $getMarginTradepairsData) {
    status_code
    status_message
    result {
      to_currency_code
      from_currency_code
      from_currency_image
      to_currency_image
      pair
      status
      enable_margin_isolated
      index_price
      __typename
    }
    __typename
  }
}
''';

  final fetchIsolatedMarginWallet = r'''query fetchIsolatedMarginWallet($fetchMarginWalletData: fetchMarginWalletInput) {
  fetchIsolatedMarginWallet(fetchMarginWalletData: $fetchMarginWalletData) {
    status_code
    status_message
    total_active_pairs
    result {
      pair
      leverage_isolated
      margin_ratio
      auto_topup
      modified_date
      status
      wallet {
        total_balance
        total_crypto
        borrowed_crypto
        currency
        available_balance
        borrowed
        interest
        equity
        equity_crypto
        currency_image
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

final getAllCurrencies = r'''query getAllCurrencies($getCurrencyData: getCurrenciesInput) {
  getAllCurrencies(getCurrencyData: $getCurrencyData) {
    status_code
    status_message
    result {
      _id
      image
      status
      name
      code
      type
      index_price
      __typename
    }
    __typename
  }
}
''';

final getMarginBorrowBalance = r'''query getMarginBorrowBalance($getMarginWalletBalanceData: getMarginWalletBalanceInput) {
  getMarginBorrowBalance(getMarginWalletBalanceData: $getMarginWalletBalanceData) {
    status_code
    status_message
    result {
      margin_ratio
      total_borrowed
      total_available
      interest_rate
      user_borrow
      maximum_borrow_cross
      maximum_borrow_isolated
      __typename
    }
    __typename
  }
}
''';

final fetchUserMarginWallet = r'''query fetchUserMarginWallet($userMarginWalletData: userMarginWalletInput) {
  fetchUserMarginWallet(userMarginWalletData: $userMarginWalletData) {
    status_code
    status_message
    result {
      currency_code
      total_available
      total_borrowed
      total_balance
      interest
      pair
      __typename
    }
    __typename
  }
}
''';

final fetchMarginOpenOrders = r'''
query fetchMarginOpenOrders($marginOpenOrdersData: marginOpenOrdersInput) {
  fetchMarginOpenOrders(marginOpenOrdersData: $marginOpenOrdersData) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        _id
        pair
        from_currency
        to_currency
        amount
        type
        side
        price
        average
        executed
        filled
        total
        trigger_condition
        status
        ordered_date
        traded_date
        cancelled_date
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

final fetchMarginTradeHistory = r'''
query fetchMarginTradeHistory($marginTradeHistoryData: marginTradeHistoryInput) {
  fetchMarginTradeHistory(marginTradeHistoryData: $marginTradeHistoryData) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        pair
        amount
        type
        side
        price
        fee
        filled
        total
        margin_type
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

final fetchCapitalFlowHistory = r'''
query fetchCapitalFlowHistory($capitalFlowHistoryData: capitalFlowHistoryInput) {
  fetchCapitalFlowHistory(capitalFlowHistoryData: $capitalFlowHistoryData) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        pair
        currency_code
        amount
        type
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

final fetchMarginCall = r'''
query fetchMarginCall($fetchMarginCallData: fetchMarginCallInput) {
  fetchMarginCall(fetchMarginCallData: $fetchMarginCallData) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        pair
        wallet
        type
        content
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

final fetchLiquidationOrder = r'''
query fetchLiquidationOrder($fetchLiquidationOrderData: fetchLiquidationOrderInput) {
  fetchLiquidationOrder(fetchLiquidationOrderData: $fetchLiquidationOrderData) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        pair
        from_currency
        to_currency
        amount
        type
        side
        price
        average
        executed
        filled
        total
        trigger_condition
        status
        liquidation_order
        margin_order
        ordered_date
        traded_date
        cancelled_date
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

final fetchTransferHistory = r'''
query fetchTransferHistory($transferHistoryData: transferHistoryInput) {
  fetchTransferHistory(transferHistoryData: $transferHistoryData) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        pair
        coin
        margin_account
        auto_topup_transferin
        from_wallet
        to_wallet
        amount
        status
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

final getUserFundingWalletTransferHistory = r'''query getUserFundingWalletTransferHistory($input: userFundWalletTransHisInput){
  getUserFundingWalletTransferDetails(userFundWalletTransHisData: $input) {
    status_code
    status_message
    result {
      currency_code
      from_wallet
      to_wallet
      amount
      status
      created_date
      currency_type
    }
  }
}''';

final fetchBorrowHistory = r'''
query fetchBorrowHistory($borrowHistoryData: borrowHistoryInput) {
  fetchBorrowHistory(borrowHistoryData: $borrowHistoryData) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        pair
        currency_code
        amount
        type
        status
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

final fetchRepayHistory = r'''
query fetchRepayHistory($repayHistoryData: borrowHistoryInput) {
  fetchRepayHistory(repayHistoryData: $repayHistoryData) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        pair
        currency_code
        amount
        interest
        total
        type
        status
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

final fetchInterestHistory = r'''
query fetchInterestHistory($interestHistoryData: borrowHistoryInput) {
  fetchInterestHistory(interestHistoryData: $interestHistoryData) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        pair
        currency_code
        amount
        interest_type
        interest_rate
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

final fetchLiquidationHistory = r'''
query fetchLiquidationHistory($fetchLiquidationHistoryData: fetchLiquidationHistoryInput) {
  fetchLiquidationHistory(fetchLiquidationHistoryData: $fetchLiquidationHistoryData) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        pair
        risk_ratio
        total_debt
        total_assets
        liquidation_fee
        wallet
        status
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

final fetchUserPnlHistory = r'''query fetchUserPnlHistory($fetchPnlData: fetchPnlInput) {
  fetchUserPnlHistory(fetchPnlData: $fetchPnlData) {
    status_code
    status_message
    result {
      daily_pnl
      cumulative_pnl
      net_transfer
      total_equity
      total_debt
      total_asset
      created_date
      modified_date
      __typename
    }
    __typename
  }
}
''';

final activateIsolatedWallet = r'''mutation activateIsolatedWallet($data: activateIsolatedWalletInput) {
  activateIsolatedWallet(activateIsolatedWalletData: $data) {
    status_code
    status_message
    __typename
  }
}
''';
}