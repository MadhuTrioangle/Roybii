VotingQueries votingQueries = VotingQueries();

class VotingQueries {
  final getActiveUserRound = r'''query getActiveUserRound{    
    getActiveUserRound{
        status_code
        status_message        
        result{      
            _id
            roundName            
            endDate
            project_details{
              _id
              project_name
              project_logo
              noOfVotes
              token
              tokenId
              vote_promotion_text
              token_link{
               facebook_link
                website_link
                twitter_link
                medium_link
              }          
            }
        }
    }
}
''';

  final fetchWinningProject = r'''
  query fetchWinningProject($data: fetchWinningProjectInput) {
  fetchWinningProject(fetchWinningProjectInput: $data) {
    status_code
    status_message
    result {
      page
      pages
      total
      data {
        project_name
        project_logo
        currency_code
        vote_winners_total_supply
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final getUserVoteQuota = r'''
  query getUserVoteQuota($data: getUserVoteQuotaInput) {
  getUserVoteQuota(getUserVoteQuotaInput: $data) {
    status_code
    status_message
    result {
      voteDetails {
        voteCount
        __typename
      }
      __typename
    }
    __typename
  }
}
''';
}