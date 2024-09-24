OneStepWithdrawQueries oneStepWithdrawQueries = OneStepWithdrawQueries();

class OneStepWithdrawQueries{
  final getWhitelistAddress = r'''query getWhitelistAddress($getWhitelistAddressData: getWhitelistAddressInput) {
  getWhitelistAddress(getWhitelistAddressData: $getWhitelistAddressData) {
    status_code
    status_message
    result {
      _id
      label
      universal_address
      address
      tag_id
      coin
      network
      whitelist
      origin_name
      status
      __typename
    }
    __typename
  }
}
''';
}