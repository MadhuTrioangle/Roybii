StackingQueries stackingQueries = StackingQueries();

class StackingQueries {
  final getActiveStakes = r'''query getActiveStakes{
    getActiveStakes{
      status_code
      status_message
      result{
        _id
        minStakeAmount
        maxStakeAmount        
        childs{
          _id
          lockedDuration
          APR          
        }
        interestPeriod
        redemptionPeriod
        totalPersonalQuota
        isFlexible
        flexibleInterest        
        availableSupply
        interestCreditTime
        stakeCurrencyDetails{
          code
        }
        rewardCurrencyDetails{
          code
        }           
        }
    }
}''';

  final getUserStakes = r'''
  query getUserStakes($data: getUserStakeInput) {
  getUserStakes(getUserStakeInput: $data) {
    status_code
    status_message
    result {
      total
      limit
      pages
      page
      data {
        _id
        userStakeId
        isFlexible
        isAutoRestake
        interestEndAt
        status
        stakeCurrencyDetails {
          code
          __typename
        }
        rewardCurrencyDetails {
          code
          __typename
        }
        stakeAmount
        APR
        stakedAt
        lockedDuration
        __typename
      }
      __typename
    }
    __typename
  }
}
  ''';

  final getUserStakeEarns = r'''
query getUserStakeEarns($data: getUserStakeEarnInput) {
  getUserStakeEarns(getUserStakeEarnInput: $data) {
    status_code
    status_message
    result {
      total
      limit
      pages
      page
      data {
        userStakeDetails {
          isFlexible
        }
        userStakeId
        interestAmount
        earnCurrencyDetails {
          code
          __typename
        }
        createdAt
        __typename
      }
      __typename
    }
    __typename
  }
}
  ''';

  final updateUserRestake = r'''
mutation updateUserRestake($data:updateUserStakeData){
  updateUserRestake(updateUserStakeData:$data){
      status_code
      status_message          
    }
}
  ''';

  final requestForRedeem = r'''
mutation requestForRedeem($data:unstakeInput){
  requestForRedeem(unstakeInput:$data){
      status_code
      status_message          
    }
}
  ''';

  final getStakeBalance = r'''
query getStakedBalanceByDefultCurrency($data:getStakedBalanceByDefultCurrencyInput){
  getStakedBalanceByDefultCurrency(getStakedBalanceByDefultCurrencyInput:$data){
    status_code
    status_message
    result{
    	earnBalance{
        _id
        totalEarnAmount
        stakeEarnBalanceByUserPreferred
        stakeEarnBalanceByDefaultCurrency
        stakeEarnBalanceByUSD
        stakeEarnBalanceByUSDDefaultCurrency
      }
      stakeBalance{
        _id
        stakeBalance
        stakeBalanceByUserPreferred
        stakeBalanceByDefaultCurrency
        stakeBalanceByUSD
        stakeBalanceByUSDDefaultCurrency
      }
    }
  }
  }
  ''';

  final getUserStakesById = r'''
query getUserStakesById($data: getUserStakeByIdInput) {
  getUserStakesById(getUserStakeByIdInput:$data){
   	status_code
    status_message
     result{
     userEarnData{
        lastEarnAmount
        totalEarnAmount
      }
      data{
        _id
        userStakeId
        restakeId
        isFlexible
        isAutoRestake
        lockedDuration
        APR
        interestEndAt
        stakeAmount
        interestStartAt
        redemptionDate
        redemptionPeriod
        stakeCurrencyDetails{
          code
        }
        rewardCurrencyDetails{
          code
        }
        stakedAt
      }
    }
  }
}''';

  final getActiveUserStakes = r'''
  query getActiveUserStakes($data: getActiveUserStakesInput) {
  getActiveUserStakes(getActiveUserStakesInput:$data){
    status_code
    status_message
    result{
      earnBalance{
        _id
        earnBalance
      }
      exchangeRate{
        _id
        exchangeRateByUserPreferred
        USDRate
      }
      stakeData{
        _id
        data{
          _id
          userStakeId
          stakeId
          isFlexible
          isAutoRestake
          status
          stakeCurrencyDetails{
            code
          }
          rewardCurrencyDetails{
            code
          }
          stakeAmount
          APR
          interestEndAt
          stakedAt
          lockedDuration
        }
      }
      total
      limit
      page
      pages
    }
  }
}
  ''';
}
