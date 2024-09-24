SettingQueries settingQueries = SettingQueries();

class SettingQueries {
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

  final getKycStatus = r'''query getUserByJWT {
  getUserByJWT {
    status_code
    status_message
    result {
      email
      vip_level
      time_zone
      timezone_name
      current_wallet {
        crypto_deposit
        crypto_withdraw
        __typename
      }
      whitelist_address {
        currency_code
        label
        address
        __typename
      }
      anti_phishing_code
      status
      phone_number {
        phone_code
        phone_number
        otp
        status
        __typename
      }
      referral_code
      referred_by
      kyc {
        id_proof {
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
        facial_proof {
          facial_proof
          facial_proof_Status
          __typename
        }
        kyc_status
        __typename
      }
      tfa_authentication {
        mobile_number {
          phone_code
          phone_number
          status
          updated_at
          __typename
        }
        __typename
      }
      tfa_enable_key
      tfa_status
      verify_email
      token_type
      remember_code
      remember_token
      login_attempts
      withdrawal_limit {
        enable
        limit
        __typename
      }
      withdrawal_whitelist {
        enable
        address_list {
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
      one_step_withdrawal {
        enable
        max_withdrawal
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final getLoggedInUserDetails = r'''query getLoggedInUserDetails {
  getLoggedInUserDetails {
    status_code
    status_message
    result {
      kyc {
        kyc_status
        __typename
      }
      status
      tfa_status
      password_status
      email
      tfa_authentication {
        mobile_number {
          phone_code
          phone_number
          status
          __typename
        }
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  final getPersonalDetails = r'''query getPersonalDetails {
  getPersonalDetails {
    status_code
    status_message
    result {
      first_name
      middle_name
      last_name
      dob
      address
      country
      state
      city
      zip
      __typename
    }
    __typename
  }
}
''';
}
