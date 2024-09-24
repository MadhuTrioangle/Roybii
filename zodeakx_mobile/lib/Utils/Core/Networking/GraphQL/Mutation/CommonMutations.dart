CommonMutations commonMutations = CommonMutations();

class CommonMutations {
  var updateMobileNumber = r'''
  mutation updateMobileNumber($data: updateMobileNumberInput!) {
  updateMobileNumber(updateMobileNumberData: $data) {
    status_code
    status_message
    __typename
  }
}
''';
  var verifyMobileNumber = r'''
mutation verifyMobileNumber($data: verifyMobileNumberInput!) {
  verifyMobileNumber(verifyMobileNumberData: $data) {
    status_code
    status_message
    __typename
  }
}
''';
  var setDeleteMobileNumber = r'''
mutation deleteMobileNumber($data: deleteMobileNumberInput!) {
  deleteMobileNumber(deleteMobileNumberData: $data) {
    status_code
    status_message
    __typename
  }
}
''';
  var createUser = r'''mutation ($data: registerInput) {
  createUser(registerInput: $data) {
    status_code
    status_message
    result {
      token
      email
      session_id
      token_type
      tempOTP
      __typename
    }
    __typename
  }
}
''';
  var createUserBankDetails = r'''
mutation AddBankDetails($data: bankdetails) {
  AddBankDetails(bankdetails: $data) {
    status_code
    status_message
    __typename
  }
}
''';
  var createUserEditBankDetails = r'''
mutation EditBankDetails($data: editbankdetails) {
  EditBankDetails(editbankdetails: $data) {
    status_code
    status_message
    __typename
  }
}
''';
  var deleteBankDetails = r'''
mutation deleteBankDetail($data: deleteBankDetailInput) {
  deleteBankDetail(deleteBankDetailData: $data) {
    status_code
    status_message
    __typename
  }
}

''';
  var createAntiPhishingCode = r'''
 mutation antiPhishingCode($data: anitphisingcode) {
  antiPhishingCode(anitphisingcode: $data) {
    status_code
    status_message
    __typename
  }
}
''';
  var forgotPassword = r'''mutation 
  sendForgetPasswordVerifyMail($input: forgetEmailInput) {
  sendForgetPasswordVerifyMail(forgetEmailInput: $input) {
    status_code
    status_message
    result {
      token_type
      token
      __typename
    }
    __typename
  }
}
''';
  var verifyForgotPassword = r'''mutation 
  verfiyForgetPasswordCode($input: forgetPasswordVerifyCodeInput) {
  verfiyForgetPasswordCode(forgetPasswordVerifyCodeInput: $input) {
    status_code
    status_message
    __typename
  }
}
''';
  var verifyAuthentication = r'''
mutation antiPhishingCodeVerification($input: antiPhishingCodeInput!) {
  antiPhishingCodeVerification(antiPhishingCodeData: $input) {
    status_code
    status_message
    __typename
  }
}
''';

  var sendMobileOtp =
      r'''mutation sendMobileOtp($data: updateMobileNumberInput!) {
  sendMobileOtp(updateMobileNumberData: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  var verifyTfaLogin = r'''mutation ($data: tfaInput) {
  verifyTfaLogin(tfaInput: $data) {
    status_code
    status_message
    result {
      token
      email
      token_type
      session_id
      tempOTP
      __typename
    }
    __typename
  }
}
 ''';

  var newPassword = r'''mutation 
  newPassword($input: newPasswordInput) {
  newPassword(newPasswordData: $input) {
    status_code
    status_message
    __typename
  }
}
''';

  var resendEmail = r'''mutation resendEmail($data: reSendEmailInput) {
  resendEmail(reSendEmailData: $data) {
     status_code
     status_message
      result {
               tempOTP
                __typename
             }
              __typename
           }
      }''';

  var verifyEmail = r'''mutation ($data: verifyUserInput!) {
  verifyEmail(verifyUserInput: $data) {
    status_code
    status_message
    __typename
  }
}''';

  var loginUser = r'''mutation ($data: loginInput) {
  login(loginInput: $data) {
    status_code
    status_message
    result {
      token
      email
      session_id
      account_status
      token_type
      mobile_number
      mobile_code
      mobile_status
      tempOTP
      __typename
    }
    __typename
  }
}
''';

  var logoutUser = r'''
mutation deviceLogout($input: logoutInput) {
  deviceLogout(logoutData: $input) {
    status_code
    status_message
    __typename
  }
}
''';

  var reactivateAccount = r'''mutation ($data: activateInput) {
  reactivateAccount(activateInput: $data) {
    status_code
    status_message
    result {
      token
      email
      account_status
      token_type
      tempOTP
      __typename
    }
    __typename
  }
}
''';

  var activateAccount = r'''mutation ($data: NewDeviceInput) {
  activateAccount(NewDeviceInput: $data) {
    status_code
    status_message
    result {
      token
      email
      account_status
      token_type
      __typename
    }
    __typename
  }
}''';

  var newDeviceLogin = r'''mutation ($data: NewDeviceInput) {
  verifyNewDevice(NewDeviceInput: $data) {
    status_code
    status_message
    result {
      token
      email
      session_id
      __typename
    }
    __typename
  }
}
''';

  var verifyForgotPasswordVerifyMail = r'''
mutation verfiyForgetPasswordCode($input: forgetPasswordVerifyCodeInput) {
  verfiyForgetPasswordCode(forgetPasswordVerifyCodeInput: $input) {
    status_code
    status_message
    __typename
  }
}
''';
  var verifyRegisterEmail = r'''
mutation verifyRegisterEmail($input: verifyRegisterEmailInput) {
  verifyRegisterEmail(verifyRegisterEmailInput: $input) {
    status_code
    status_message
    result
  }
}
''';
  var generateReferralLink = r'''
mutation generateReferralLink($data: generateReferralLinkInput) {
  generateReferralLink(generateReferralLinkData: $data) {
    status_code
    status_message
    __typename
  }
}

''';

  var createCryptoWithdraw = r'''
  mutation withdraw($data: withdrawInput) {
  withdraw(withdrawInput: $data) {
    status_code
    status_message
    __typename
  }
}
 ''';

  var createFiatWithdraw = r'''
  mutation createFiatWithdraw($data: fiatWithdrawInput) {
  createFiatWithdraw(fiatWithdrawInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  var verifyTFA = r'''
  mutation ($data: verifytfainput) {
  verifytfa(verifytfainput: $data) {
    status_code
    status_message
    result {
      buttonvalue
      __typename
    }
    __typename
  }
}
 ''';

  var updatePersonalInformation = r'''
  mutation updatepersonalInfo($data: personalinfoinput) {
  updatepersonalInfo(personalinfoinput: $data) {
    status_code
    status_message
    __typename
  }
}
 ''';

  var createFiatDeposit = r'''
  
    mutation createFiatDeposit($data: fiatDepositInput)
     { createFiatDeposit(fiatDepositInput: $data) {
           status_code
              status_message   __typename  }}''';

  var createFiatTransaction = r'''
  mutation createFiatTransaction($data: createFiatTransactionInput) {
  createFiatTransaction(createFiatTransactionData: $data) {
    status_code
    status_message
    __typename
  }
}
              ''';

  var updateNewPassword = r'''
  mutation updateLoginPassword($input: updateLoginPasswordInput) {
  updateLoginPassword(updateLoginPasswordData: $input) {
    status_code
    status_message
    __typename
  }
}
''';

  var updateIdInfo = r'''
  mutation updateIdProof($data: idproofinput) {
   updateIdProof(idproofinput: $data) { 
    status_code  status_message result { 
       id_proof_front_url     
        id_proof_back_url    
          __typename  }  
           __typename }
           } ''';

  var updateFacialInfo = r'''
  mutation updateFacialProof($data: facialproofinput) { 
  updateFacialProof(facialproofinput: $data) 
  {   status_code    
  status_message  
    __typename 
     }
     } ''';

  var createOrder = r'''
  mutation createOrder($data: createOrderInput) {
  createOrder(createOrderInput: $data) {
    status_code
    status_message
    __typename
  }
}  ''';

  final getConvertHistory =
      r'''query getConvertHistory($getConvertHistoryData: getConvertHistoryInput) {
  getConvertHistory(getConvertHistoryData: $getConvertHistoryData) {
    status_code
    status_message
    result {
      data {
        userId
        from_currency
        to_currency
        converted_amount
        convertion_rate
        received_amount
        created_date
        __typename
      }
      total
      limit
      page
      pages
      __typename
    }
    __typename
  }
}
''';

  final getBalanceMutation = r'''
mutation getBalance($data: openOrderInput) {
	getBalance(openOrderInput: $data) {
		status_code
		status_message
		result {
			fcurr
			scurr
			__typename
		}
		__typename
	}
} ''';

  var verifyKyc = r'''
mutation{
  verifyKyc{
    status_code
    status_message
  }
} ''';

  final createUserStake = r'''
mutation createUserStake($data:createUserStakeData){
  createUserStake(createUserStakeData:$data){
      status_code
      status_message          
    }
}''';

  // launchpad starts
  final fetchBannerData = r'''
 query fetchBannerData($data: fetchBannerInput) {
  fetchBannerData(fetchBannerInput: $data) {
    status_code
    status_message
    result {
      fund_raised
      no_of_projects
      total_participants
      total_committed
      __typename
    }
    __typename
  }
}
''';

  final fetchProjects = r'''
 query fetchProjects($fetchProjectdata: fetchProjectsInput) {
  fetchProjects(fetchProjectsInput: $fetchProjectdata) {
    status_code
    status_message
    result {
      data {
        _id
        project_name
        project_logo
        project_status
        hardcap_per_user
        minimum_commitment
        description
        price
        holding_currency
        fiat_currency
        token
        tokens_offered
        project_status
        token_distribution
        total_token_supply
        total_circulating_supply
        hardcap
        introduction
        key_features
        created_date
        modified_date
        #exchange_rate
        hold_calculation_period {
          start_date
          no_of_days
          end_date
          __typename
        }
        allocation_period {
          start_date
          end_date
          no_of_hours
          break_hours
          __typename
        }
        subscription_period {
          start_date
          end_date
          no_of_hours
          break_hours
          __typename
        }
        token_distribution
        token_link {
          white_paper_link
          research_report_link
          website_link
          facebook_link
          twitter_link
          medium_link
          __typename
        }
        __typename
      }
      total
      limit
      page
      pages
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

  final subscribeProject = r'''
mutation subscribeProject($data: subscribeProjectInput) {
  subscribeProject(subscribeProjectInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final createUserVote = r'''
 mutation createUserVote($data:createUserVoteInput){
    createUserVote(createUserVoteInput:$data){
      status_code
      status_message    
    }
  }
  ''';

  //margin trading starts
  final borrowCoolingOffPeriod = r'''
   mutation borrowCoolingOffPeriod($data: borrowCoolingOffPeriodInput) {
  borrowCoolingOffPeriod(borrowCoolingOffPeriodData: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final setAutoTopup = r'''mutation setAutoTopup($data: autoTopupInput) {
  setAutoTopup(autoTopupData: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final userFundingWalletTransfer =
      r'''mutation userFundingWalletTransfer($input: userFundingWalletTransferInput) {
  userFundingWalletTransfer(userFundingWalletTransferData: $input) {
    status_code
    status_message
  }
}''';

  final createManualBorrow =
      r'''mutation createManualBorrow($data: manualBorrowInput) {
  createManualBorrow(manualBorrowData: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final createManualRepay =
      r'''mutation createManualRepay($data: manualBorrowInput) {
  createManualRepay(manualRepayData: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final transferWalletFunds =
      r'''mutation transferWalletFunds($data: transferFundInput) {
  transferWalletFunds(transferFundData: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final createMarginOrder = r'''
   mutation createMarginOrder($data: createMarginOrderInput) {
  createMarginOrder(createMarginOrderInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

// margin trading ends

// mlm starts
  final createMlmStake =
      r'''mutation createMlmStake($data: createMlmUserStakeData) {
  createMlmStake(createMlmUserStakeData: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final claimUserEarns =
      r'''mutation claimUserEarns($data: claimUserEarnsInputData) {
  claimUserEarns(claimUserEarnsInputData: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final socialMediaLogin = r'''
 mutation ($data: socialMediaLoginInput) {
  socialMediaLogin(socialMediaLoginData: $data) {
    status_code
    status_message
    result {
      token
      email
      account_status
      session_id
      token_type
      tempOTP
      vip_level
      linked_account
      mobile_number
      mobile_code
      mobile_status
      __typename
    }
    __typename
  }
}
''';

// mlm ends

  final sendEmailCode = r'''
mutation sendEmailCode {
  sendEmailCode {
    status_code
    status_message
    result {
      token_type
      token
      __typename
    }
    __typename
  }
}
''';

  final verifyEmailCode = r'''
mutation verifyEmailCode($input: verifyEmailCodeInput) {
  verifyEmailCode(verifyEmailCodeInput: $input) {
    status_code
    status_message
    __typename
  }
}
''';

  final updateFavTradePair = r'''
mutation updateFavTradePair($data: favpairInput) {
  updateFavTradePair(favpairInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final userPaySendTransaction =
      r'''mutation userPaySendTransaction($data:sendTransactionData){
  userPaySendTransaction(sendTransactionData:$data){
    status_code
    status_message     
  }
}''';

  final updateUserDefaultWallet =
      r'''mutation updateUserDefaultWallet($input: updateUserDefaultWalletInput){
  updateUserDefaultWallet(updateUserDefaultWalletData: $input) {
    status_code
    status_message
  }
}''';

  final updateUserPreference =
      r'''mutation updateUserPreference($data: updateUserPreferenceInput) {
  updateUserPreference(updateUserPreferenceData: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final cooling_period =
      r'''mutation updateUserPreference($data: updateUserPreferenceInput) {
  updateUserPreference(updateUserPreferenceData: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final createFutureUsdsOrder =
      r'''mutation createFutureUsdsOrder($data: createFutureOrderInput) {
  createFutureUsdsOrder(createFutureUsdsOrderInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final createFutureCoinOrder =
      r'''mutation createFutureCoinOrder($data: createFutureOrderInput) {
  createFutureCoinOrder(createFutureCoinOrderInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final cancelFutureOrder =
      r'''mutation cancelFutureOrder($data: cancelFutureOrderInput) {
  cancelFutureOrder(cancelFutureOrderInput: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final closeFuturePositions =
      r'''mutation closeFuturePositions($data: closeFuturePositionsInput) {
  closeFuturePositions(closeFuturePositionsData: $data) {
    status_code
    status_message
    __typename
  }
}
''';

  final updateOneStepWithdrawData =
      r'''mutation ($updateOneStepWithdrawData: updateOneStepWithdrawInput) {
  updateOneStepWithdraw(updateOneStepWithdrawData: $updateOneStepWithdrawData) {
    status_code
    status_message
    __typename
  }
}
''';

  final updateWithdrawWhitelistData =
      r'''mutation ($updateWithdrawWhitelistData: updateWithdrawWhitelistInput) {
  updateWithdrawWhitelist(updateWithdrawWhitelistData: $updateWithdrawWhitelistData) {
    status_code
    status_message
    __typename
  }
}
''';

  final createWhitelistAddressData =
      r'''mutation ($createWhitelistAddressData: createWhitelistAddressInput) {
  createWhitelistAddress(createWhitelistAddressData: $createWhitelistAddressData) {
    status_code
    status_message
    __typename
  }
}
''';

  final editWhitelistStatusData =
      r'''mutation ($editWhitelistStatusData: editWhitelistStatusInput) {
  editWhitelistStatus(editWhitelistStatusData: $editWhitelistStatusData) {
    status_code
    status_message
    __typename
  }
}
''';

  final deleteWhitelistAddressData =
      r'''mutation ($deleteWhitelistAddressData: deleteWhitelistAddressInput) {
  deleteWhitelistAddress(deleteWhitelistAddressData: $deleteWhitelistAddressData) {
    status_code
    status_message
    __typename
  }
}
''';

  final deleteUserRequest = r''' mutation{
  deleteUserRequest{
    status_code
    status_message
  }
}
''';

  final walletConvert = r'''mutation walletConvert($data: walletConvertInput) {
  walletConvert(walletConvertData: $data) {
    status_code
    status_message
    __typename
  }
}
''';
}
