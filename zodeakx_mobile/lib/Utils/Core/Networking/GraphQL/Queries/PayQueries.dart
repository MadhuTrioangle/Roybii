PayQueries payQueries = PayQueries();

class PayQueries {
  final getUserpayTransactionHistory = r'''
query getUserpayTransactionHistory($data: getUserpayTransactionHistoryInput){
   getUserpayTransactionHistory(getUserpayTransactionHistoryInput: $data) {
    status_code
    status_message      
    result{
        data{
            remarks
            transactionId
            batchId
            paymentMethod
            receiveCurrency
            sendAmount
            ExchangeHistory{
                sendCurrency
                receiveCurrency
                sendAmount
                receiveAmount
                sendUSDexchangeRate
                receiveUSDexchangeRate
            }
            sendWalletType
            status
            createdAt
            userType
            email
            payId
        }
        total
        limit
        page
        pages
    }  
  }
}
''';

  final updateUserPaymentPriority = r'''
mutation updateUserPaymentPriority($data: updateUserPaymentPriorityData) {
  updateUserPaymentPriority(updateUserPaymentPriorityData: $data) {
    status_code
    status_message
    error
    __typename
  }
}
''';

  final getUserPayUsersDetails = r'''
query getUserPayUsersDetails {
  getUserPayUsersDetails {
    status_code
    status_message
    result {
      userPayId
      paymentPriority {
        currency
        __typename
      }
      transactionPin {
        pinStatus
        __typename
      }
      payementReceivingSetting {
        type
        status
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final getUserType = r'''
query getUserType {
  getUserType {
    status_code
    status_message
    result {
      userType
      __typename
    }
    __typename
  }
}
''';

  final getTransactionLimit = r'''query getTransactionLimit {
  getTransactionLimit {
    status_code
    status_message
    result {
      spentAmount
      dailyTransactionLimit {
        code
        sendLimit
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final updateUserpayReceiverSetting = r'''
mutation updateUserpayReceiverSetting($data: updateUserpayReceiverSettingData) {
  updateUserpayReceiverSetting(updateUserpayReceiverSettingData: $data) {
    status_code
    status_message
    error
    __typename
  }
}
''';

  final createTransactionPin =
      r'''mutation createTransactionPin($data: createPinData) {
  createTransactionPin(createPinData: $data) {
    status_code
    status_message
    error
    __typename
  }
}
''';

  final changeTransactionPin = r'''mutation changeTransactionPin($data: changePinData) {
  changeTransactionPin(changePinData: $data) {
    status_code
    status_message
    error
    __typename
  }
}
''';

  final forgotTransactionPin = r'''mutation forgotTransactionPin($data: forgotPinData) {
  forgotTransactionPin(forgotPinData: $data) {
    status_code
    status_message
    error
    __typename
  }
}
''';

  final getUserPayCommonPayee = r'''query getUserPayCommonPayee($getPayeeData: getUserPayCommonPayeeData) {
  getUserPayCommonPayee(getUserPayCommonPayeeData: $getPayeeData) {
    status_code
    status_message
    result {
      _id
      payeeNickname
      payeeUserPayId
      payeeEmail
      payeeRemarks
      payeeUserType
      createdAt
      updatedAt
      __typename
    }
    __typename
  }
}
''';

  final checkForPaymentSent = r'''query checkForPaymentSent($data: checkForPaymentSentData) {
  checkForPaymentSent(checkForPaymentSentData: $data) {
    status_code
    status_message
    __typename
  }
}''';
}
