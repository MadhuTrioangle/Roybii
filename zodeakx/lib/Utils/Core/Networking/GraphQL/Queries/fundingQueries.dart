FundingQueries fundingQueries = FundingQueries();

class FundingQueries{
final getUserFundingWalletDetails = r'''query GetUserFundingWalletDetails($getUserFundingWalletDetailsInput: getUserFundingWalletDetailsInput) {
  getUserFundingWalletDetails(getUserFundingWalletDetailsInput: $getUserFundingWalletDetailsInput) {
    result {
      USDValue
      amount
      converted_amount
      converted_currency_code
      currency_code
      currency_logo
      currency_name
      currency_type
      inorder
      p2p_status
    }
    status_code
    status_message
  }
}''';
}
