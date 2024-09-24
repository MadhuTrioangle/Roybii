LaunchpadQueries launchpadQueries = LaunchpadQueries();

class LaunchpadQueries {
  final getUserVotesEarn = r'''
query getUserVotesEarn($data: getUserVotesEarnInput) {
  getUserVotesEarn(getUserVotesEarnInput: $data) {
    status_code
    status_message
    result {
      total
      page
      pages
      data {
        noOfVotes
        roundName
        projectName
        rewardCurrencyCode
        rewardAmount
        createdAt
        updatedAt
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final getUserVotes = r'''
query getUserVotes($data: getUserVoteInput) {
  getUserVotes(getUserVoteInput: $data) {
    status_code
    status_message
    result {
      count {
        total
        page
        pages
        limit
        __typename
      }
      data {
        noOfVotes
        createdAt
        updatedAt
        project_name
        currency
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final fetchLaunchpadHistory = r'''
  query fetchLaunchpadHistory {
  fetchLaunchpadHistory {
    status_code
    status_message
    result {
      project_name
      price
      price_holding
      commited_amount
      deducted_amount
      allocated_token
      status
      allocated_token_id
      commited_token_id
      created_date
      modified_date
      __typename
    }
    __typename
  }
}
''';

  final fetchAvgBalance = r'''
query fetchAvgBalance($data: fetchAvgBalanceInput) {
  fetchAvgBalance(fetchAvgBalanceInput: $data) {
    status_code
    status_message
    result {
      subscription_end_date
      subscription_start_date
      avg_balance
      holding_currency
      kyc
      __typename
    }
    __typename
  }
}
''';

  final fetchParticipantData = r'''
query fetchParticipantData($data: fetchAvgBalanceInput) {
  fetchParticipantData(fetchAvgBalanceInput: $data) {
    status_code
    status_message
    result {
      user_id
      project_id
      allocated_token
      allocated_token_id
      commited_amount
      commited_token_id
      deducted_amount
      __typename
    }
    __typename
  }
}
''';

  final fetchProjectCommitedData = r'''
query fetchProjectCommitedData($data: fetchAvgBalanceInput) {
  fetchProjectCommitedData(fetchAvgBalanceInput: $data) {
    status_code
    status_message
    result {
      no_of_participants
      commited_value
      holding_currency
      project_id
      __typename
    }
    __typename
  }
}
''';
}
