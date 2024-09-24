SettingQueries settingQueries = SettingQueries();

class SettingQueries{
  /// getactivity Query
  final getIpAndTime = r''' 
{
  getActivity {
    status_code
    status_message
    result {
      source
      location
      device
      os
      ip
      created_date
      __typename
    }
    __typename
  }
}

''';


/// getuserbyjwt Query

  final getKycStatus = r'''
  query getUserByJWT{
  getUserByJWT {
    status_code
    status_message
    result {
      tfa_enable_key
      anti_phishing_code
      tfa_status
      kyc {
         id_proof{
                    first_name
                    last_name
                    middle_name
                    dob
                    State
                    Address1
                    country
                    city
                    zip
                    id_proof_type
                    id_proof_front
                    id_proof_front_status
                    id_proof_back
                    id_proof_back_status
                    __typename
                }
                facial_proof{
                    facial_proof
                    facial_proof_Status
                    __typename
                }
                kyc_status
        __typename
      }
      __typename
    }
    __typename
  }
}
 ''' ;

}