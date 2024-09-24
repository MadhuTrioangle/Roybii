MlmQueries mlmQueries = MlmQueries();

class MlmQueries {
  final mlmUnstake = r'''
mutation mlmUnstake($data: mlmUnstakeInputData) {
  mlmUnstake(mlmUnstakeInputData: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final getMlmUserStakes = r'''
query getMlmUserStakes($data: getMlmUserStakesInput) {
  getMlmUserStakes(getMlmUserStakesInput: $data) {
    status_code
    status_message
    result {
      total
      page
      result {
        _id
        status
        currencyCode
        createdAt
        stakeAmount
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final getMLMUserEarnHistory = r'''
query getMLMUserEarnHistory($data: getMlmUserEarnInput) {
  getMLMUserEarnHistory(getMlmUserEarnInput: $data) {
    status_code
    status_message
    result {
      total
      page
      data {
        _id
        status
        currencyCode
        createdAt
        earnAmount
        childEmail
        __typename
      }
      __typename
    }
    __typename
  }
}
''';
  final getMlmMembershipCriteria = r'''query getMlmMembershipCriteria {
  getMlmMembershipCriteria {
    status_code
    status_message
    result {
      _id
      currencyCode
      activateLimit
      reactivateLimit
      __typename
    }
    __typename
  }
}
''';

  final getMlmCurrency = r'''query getMlmCurrency {
  getMlmCurrency {
    status_code
    status_message
    result {
      code
      __typename
    }
    __typename
  }
}
''';

  final getMlmLevel = r'''query getMlmLevel {
  getMlmLevel {
    status_code
    status_message
    result {
      _id
      earnCurrencyCode
      levels {
        _id
        name
        earnPercentage
        category
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final getMLMAmbassadorDetails = r'''query getMLMAmbassadorDetails {
  getMLMAmbassadorDetails {
    status_code
    status_message
    result {
      userEarns
      userDetails {
        mlm_status
        mlm_nextClaimAt
        mlm_ambassadorCode
        mlm_activationStatus
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final getUserWalletBalance = r'''query getUserWalletBalance {
  getUserWalletBalance {
    status_code
    status_message
    result {
      _id
      currencyName
      currencyImage
      fundingWallet {
        amount
        defaultUSDAmount
        USDAmount
        __typename
      }
      spotWallet {
        amount
        defaultUSDAmount
        USDAmount
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final getPriorityOrderBalance = r'''query{
 getPriorityOrderBalance{
    status_code
    status_message        
    result
  }
}''';

  final getExchangeRateForFunding = r'''query getUserWalletBalance {
  getUserWalletBalance {
    status_code
    status_message
    result {
      _id
      currencyName
      defaultExchangeRate
      USDExchangeRate
      __typename
    }
    __typename
  }
}
''';
}
