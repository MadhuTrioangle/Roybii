
JwtQueries userJwtQueries = JwtQueries();

class JwtQueries{
  final getUserByJwt = r''' 
 query getUserByJWT  {
  getUserByJWT {
    status_code
    status_message
    result {
      tfa_enable_key
      anti_phishing_code
      tfa_status
      kyc {
        kyc_status
        __typename
      }
      __typename
    }
    __typename
  }
}
''';
}