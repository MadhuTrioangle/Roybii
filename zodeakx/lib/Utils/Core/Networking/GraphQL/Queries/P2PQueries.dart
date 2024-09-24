P2PQueries p2pQueries = P2PQueries();

class P2PQueries {
  final fetchP2PCurrency = r''' 
query fetchP2PCurrency($fetchP2PCurrencyData: fetchP2PCurrencyInput) {
  fetchP2PCurrency(fetchP2PCurrencyInput: $fetchP2PCurrencyData) {
    status_code
    result {
      image
      type
      code
      status
      p2p_status
      min_ad_limit
      max_ad_limit
      p2p_maker_fee
      __typename
    }
    __typename
  }
}
''';

  final createAdvertisement = r''' 
mutation createAdvertisement($data: createAdvertisementInput) {
  createAdvertisement(createAdvertisementInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final fetchFeedback = r''' 
query fetchFeedback($fetchFeedbackData: fetchFeedbackInput) {
  fetchFeedback(fetchFeedbackInput: $fetchFeedbackData) {
    status_code
    status_message
    result {
      page
      pages
      total
      data {
        _id
        user_id
        feedback
        feedback_type
        created_date
        modified_date
        name
        payment_method
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final closeAdvertisement = r''' 
mutation cancelAdvertisement($data: cancelAdvertisementInput) {
  cancelAdvertisement(cancelAdvertisementInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final editAdvertisement = r''' 
mutation editAdvertisement($data: editAdvertisementInput) {
  editAdvertisement(editAdvertisementInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final fetchHighestPrice = r''' 
query fetchHighestPrice($fetchHighPrice: fetchHighestPriceInput) {
  fetchHighestPrice(fetchHighestPriceInput: $fetchHighPrice) {
    status_code
    result
    __typename
  }
}
''';

  final fetchPaymentMethods = r''' 
query fetchPaymentMethods {
  fetchPaymentMethods {
    status_code
    status_message
    result {
      status
      name
      _id
      type
      __typename
    }
    __typename
  }
}
''';

  final fetchUserPaymentDetails = r''' 
query fetchUserPaymentDetails($UserPaymentDetails: fetchUserPaymentDetailsInput) {
  fetchUserPaymentDetails(fetchUserPaymentDetailsInput: $UserPaymentDetails) {
    status_code
    status_message
    result {
      _id
      user_id
      payment_details
      created_date
      modified_date
      payment_method_id
      created_date
      payment_name
      __typename
    }
    __typename
  }
}
''';

  final fetchAppealHistory = r'''
query fetchAppealHistory($fetchAppealHistoryData: fetchAppealHistoryInput) {
  fetchAppealHistory(fetchAppealHistoryInput: $fetchAppealHistoryData) {
    status_code
    status_message
    result {
      _id
      user_id
      order_id
      status
      user_name
      description
      proof
      reason_for_appeal
      created_date
      modified_date
      consensus
      __typename
    }
    __typename
  }
}
''';

  final fetchUserActivity = r''' 
query fetchUserActivity {
  fetchUserActivity {
    status_code
    status_message
    result {
      user_id
      created_date
      modified_date
      __typename
    }
    __typename
  }
}

''';

  final fetchAdvertisement = r''' 
query fetchAdvertisement($fetchAdvertisementData: fetchAdvertisementInput) {
  fetchAdvertisement(fetchAdvertisementInput: $fetchAdvertisementData) {
    status_code
    status_message
    result {
      total
      limit
      page
      pages
      data {
        _id
        user_id
        min_trade_order
        max_trade_order
        advertisement_type
        trade_status
        payment_method {
          payment_method_id
          payment_method_name
          __typename
        }
        floating_price
        price
        amount
        status
        total
        from_asset
        to_asset
        created_date
        auto_reply
        created_date
        completion_rate
        totalOrders
        price_type
        payment_time_limit
        remarks
        name
        floating_price_margin
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final fetchUserAdvertisement = r''' 
query fetchUserAdvertisements($userAdvertisementData: fetchUserAdvertisementsInput) {
  fetchUserAdvertisements(fetchUserAdvertisementsInput: $userAdvertisementData) {
    status_code
    status_message
    result {
      total
      limit
      page
      pages
      data {
        _id
        user_id
        min_trade_order
        max_trade_order
        filled_amount
        ordered_amount
        status
        advertisement_type
        trade_status
        payment_method {
          payment_method_id
          payment_method_name
          __typename
        }
        floating_price
        price
        amount
        total
        auto_reply
        remarks
        name
        from_asset
        to_asset
        created_date
        modified_date
        price_type
        payment_time_limit
        floating_price_margin
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final userAdvertisementPaymentDetails = r'''
query($data: fetchUserAdvertisementsInput){
  fetchUserAdvertisements(fetchUserAdvertisementsInput:$data){
    status_code
    status_message
    result{
      data{
        _id
      user_id
      advertisement_type
      name
      from_asset
      to_asset
      price_type
      floating_price_margin
      price
      amount
      total
      min_trade_order
      max_trade_order
      payment_method{
        payment_method_id
        payment_method_name
      }
      status
      trade_status
      payment_time_limit
      auto_reply
      remarks
      floating_price
      totalOrders
      completion_rate
      filled_amount
      ordered_amount
      created_date
      modified_date
      }
      limit
      page
      pages
    }
  }
}
''';

  final fetchOrderCreation = r''' 
mutation orderCreation($data: orderCreationInput) {
  orderCreation(orderCreationInput: $data) {
    status_code
    status_message
    result {
      _id
      from_asset
      to_asset
      price
      amount
      total
      created_date
      modified_date
      __typename
    }
    __typename
  }
}
''';

  final editFeedback = r''' 
mutation editFeedback($data: addFeedbackInput) {
  editFeedback(addFeedbackInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final addFeedback = r''' 
mutation addFeedback($data: addFeedbackInput) {
  addFeedback(addFeedbackInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final addUserPaymentMethod = r''' 
mutation addUserPaymentMethod($data: addUserPaymentMethodInput) {
  addUserPaymentMethod(addUserPaymentMethodInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final editAdTradeStatus = r''' 
mutation editAdTradeStatus($data: editAdTradeStatusInput) {
  editAdTradeStatus(editAdTradeStatusInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final updateUserPaymentMethod = r''' 
mutation updateUserPaymentMethod($data: updateUserPaymentMethodInput) {
  updateUserPaymentMethod(updateUserPaymentMethodInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final deleteUserPaymentMethod = r''' 
mutation deleteUserPaymentMethod($data: deleteUserPaymentMethodInput) {
  deleteUserPaymentMethod(deleteUserPaymentMethodInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final editUserName = r''' 
mutation editUserName($data: editUserNameInput) {
  editUserName(editUserNameInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final createMessage = r''' 
mutation createMessage($data: createMessageInput) {
  createMessage(createMessageInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final cancelP2POrder =
      r'''mutation cancelP2POrder($data: cancelP2POrderInput) {
  cancelP2POrder(cancelP2POrderInput: $data) {
    status_code
    status_message
    __typename
  }
}
 ''';
final appealConsensus = r'''
mutation appealConsensus($data: appealUpdateInput) {
  appealConsensus(appealUpdateInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final fiatTransferred =
      r'''mutation fiatTransferred($data: fiatTransferredInput){
    fiatTransferred(fiatTransferredInput: $data){
    status_code
    status_message
  }
}
''';

  final fetchMessageHistory = r'''
      query fetchMessageHistory($fetchMessageHistoryData: fetchMessageHistoryInput) {
  fetchMessageHistory(fetchMessageHistoryInput: $fetchMessageHistoryData) {
    status_code
    status_message
    result {
      user_id
      conversation_id
      message
      image
      created_date
      __typename
    }
    __typename
  }
}
''';

  final releaseCrypto = r'''mutation releaseCrypto($data: releaseCryptoInput) {
  releaseCrypto(releaseCryptoInput: $data) {
    status_code
    status_message
    __typename
  }
}
 ''';
  final findUserCenter = r''' 
query findUserCenter($UserCenterDetails: findUserCenterInput) {
  findUserCenter(findUserCenterInput: $UserCenterDetails) {
    status_code
    status_message
    result {
      name
      kyc_status
      email_status
      join_date
      avg_payment_time
      avg_release_time
      totalOrders
      sell_order
      buy_order
      last30DayTrade
      completion_rate
      positive_feedback
      negative
      positive
      registered
      first_trade
      __typename
    }
    __typename
  }
}
''';

  final fetchUserOrders = r''' 
query fetchUserOrders($fetchUserOrdersData: fetchOrdersInput) {
  fetchUserOrders(fetchOrdersInput: $fetchUserOrdersData) {
    status_code
    status_message
    result {
      page
      pages
      total
      data {
        _id
        trade_type
        counter_party
        to_asset
        from_asset
        admin_fee_amount
        advertisement_id
        seller_id
        buyer_id
        status
        price
        amount
        total
        payment_method {
          payment_method_id
          payment_method_name
          __typename
        }
        to_asset
        fiat_expiry_time
        crypto_expiry_time
        loggedInUser
        kyc_name
        modified_date
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

  final fetchFeedbackData = r''' 
query fetchFeedback($fetchFeedbackData: fetchFeedbackInput) {
  fetchFeedback(fetchFeedbackInput: $fetchFeedbackData) {
    status_code
    status_message
    result {
      page
      pages
      total
      data {
        _id
        user_id
        feedback
        feedback_type
        created_date
        modified_date
        name
        payment_method
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final reportUser = r''' 
mutation reportUser($data: reportUserInput) {
  reportUser(reportUserInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final appealCreation = r'''
 mutation appealCreation($appealCreationInput: appealCreationInput) {
  appealCreation(appealCreationInput: $appealCreationInput) {
    status_code
    status_message
  }
}
''';

  final cancelAppeal = r'''
  mutation cancelAppeal($data: cancelAppealInput) {
  cancelAppeal(cancelAppealInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';
}
