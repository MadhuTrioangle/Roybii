

import 'package:zodeakx_mobile/Common/BankDetails/Model/BankDetailsModel.dart';
import 'package:zodeakx_mobile/Common/ConfirmPassword/Model/ConfirmPasswordModel.dart';
import 'package:zodeakx_mobile/Common/EditBankDetails/Model/EditBankDetailsModel.dart';
import 'package:zodeakx_mobile/Common/ForgotPasswordScreen/Model/ForgotPasswordModel.dart';
import 'package:zodeakx_mobile/Common/ForgotPasswordScreen/Model/VerifyForgotPasswordModel.dart';
import 'package:zodeakx_mobile/Common/ReactiveAccount/Model/ReactivateAccountModel.dart';
import 'package:zodeakx_mobile/Common/RegisterScreen/Model/RegisterModel.dart';
import 'package:zodeakx_mobile/Common/VerifyGoogleAuthCode/Model/VerifyGoogleAuthenticateModel.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/APIProvider.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Mutation/CommonMutations.dart';
import 'package:zodeakx_mobile/ZodeakX/AntiPhishingCode/Model/AntiPhishingModel.dart';

import '../../Utils/Core/Networking/CommonModel/CommonModel.dart';
import '../EditBankDetails/Model/DeleteBankdetailsModel.dart';
import '../EmailVerificationScreen/Model/EmailVerificationModel.dart';
import '../GoogleAuthentication/View/GoogleAuthenticate/Model/GoogleAutheticateModel.dart';
import '../LoginScreen/Model/LoginModel.dart';
import '../LoginScreen/Model/verifyNewDeviceLogin.dart';
import '../LoginScreen/Model/verifyTfaLogin.dart';

CommonRepository commonRepository = CommonRepository();

/// Handles app common modules API's
class CommonRepository{

/// Mutate Create User
  Future<CreateUser> MutatecreateUser(Map<String,dynamic> params) async{
    var createUserResponse = await apiProvider.MutationWithParams(commonMutations.createUser, params);
    return CreateUser.fromJson(createUserResponse);
  }
  ///Mutate Create User Bank Details
  Future<AddBankDetails> MutatecreateUserBankDetails(Map<String,dynamic> params) async{
    var createUserBankDetailsResponse = await apiProvider.MutationWithParams(commonMutations.createUserBankDetails, params);
    return AddBankDetails.fromJson(createUserBankDetailsResponse);
  }
  ///Mutate Create User Edit Bank Details
  Future<EditBankDetails> MutatecreateUserEditBankDetails(Map<String,dynamic> params) async{
    var createUserBankDetailsResponse = await apiProvider.MutationWithParams(commonMutations.createUserEditBankDetails, params);
    return EditBankDetails.fromJson(createUserBankDetailsResponse);
  }
  ///Mutate Create User Delete Bank Details
  Future<DeleteBankDetail> MutateDeleteBankDetails(Map<String,dynamic> params) async{
    var createUserBankDetailsResponse = await apiProvider.MutationWithParams(commonMutations.deleteBankDetails, params);
    return DeleteBankDetail.fromJson(createUserBankDetailsResponse);
  }
  /// Mutarte create antiphishing code

  Future<AntiPhishingCode> MutatecreateAntiPhishingCode(Map<String,dynamic> params) async{
    var createCode = await apiProvider.MutationWithParams(commonMutations.createAntiPhishingCode, params);
    return AntiPhishingCode.fromJson(createCode);
  }
  /// Mutate Create User
  Future<Verifytfa> MutateVerifyTFA(Map<String,dynamic> params) async{
    var verifyTFAResponse = await apiProvider.MutationWithParams(commonMutations.verifyTFA, params);
    return Verifytfa.fromJson(verifyTFAResponse);
  }
 /// Mutate Create Forgot Password
  Future<SendForgetPasswordVerifyMail> forgotPassword(Map<String,dynamic> params) async{
    var forgotPasswordResponse = await apiProvider.MutationWithParams(commonMutations.forgotPassword, params);
    return SendForgetPasswordVerifyMail.fromJson(forgotPasswordResponse);
  }
  ///mutate verify forgot password
  Future<VerifyForgotPasswordModel> verifyForgotPassword(Map<String,dynamic> params) async{
    var forgotPasswordResponse = await apiProvider.MutationWithParams(commonMutations.verifyForgotPassword, params);
    return VerifyForgotPasswordModel.fromJson(forgotPasswordResponse);
  }
  /// mutate verify Google Authentication Code
  Future<AntiPhishingCodeVerification> verifiedCode(Map<String,dynamic> params) async{
    var verifiedResponse = await apiProvider.MutationWithParams(commonMutations.verifyAuthentication, params);
    return AntiPhishingCodeVerification.fromJson(verifiedResponse);
  }

  /// mutate verifyTfa Code
  Future<VerifyTfaLoginClass> verifyTfaCode(Map<String,dynamic> params) async{
    var verifyTfaCodeResponse = await apiProvider.MutationWithParams(commonMutations.verifyTfaLogin, params);
    return VerifyTfaLoginClass.fromJson(verifyTfaCodeResponse);
  }

/// Mutate Create New Password
  Future<NewPasswordClass> createPassword(Map<String,dynamic> params) async{
    var newPasswordResponse = await apiProvider.MutationWithParams(commonMutations.newPassword, params);
    return NewPasswordClass.fromJson(newPasswordResponse);
  }

  Future<ResendMail> MutateResendEmail(Map<String,dynamic> params) async{
    var resendEmailResponse = await apiProvider.MutationWithParams(commonMutations.resendEmail, params);
    return ResendMail.fromJson(resendEmailResponse);
  }

  /// Mutate Verify Email
  Future<CommonModel> MutateVerifyEmail(Map<String,dynamic> params) async{
    var verifyEmailResponse = await apiProvider.MutationWithParams(commonMutations.verifyEmail, params);
    return CommonModel.fromJson(verifyEmailResponse);
  }
  /// Login User Response
  Future<LoginModel> MutateLoginUser(Map<String, dynamic>params) async{
    var loginUserResponse = await apiProvider.MutationWithParams(commonMutations.loginUser, params);
    return LoginModel.fromJson(loginUserResponse);
  }
  /// logout User Response
  Future<CommonModel> MutatelogoutUser(Map<String, dynamic>params) async{
    var logoutUserResponse = await apiProvider.MutationWithParams(commonMutations.logoutUser, params);
    return CommonModel.fromJson(logoutUserResponse);
  }

  Future<ReactivateAccountModel>MutateReactivateAccount(Map<String, dynamic> params) async{
    var reactivateUserResponse = await apiProvider.MutationWithParams(commonMutations.reactivateAccount, params);
    return ReactivateAccountModel.fromJson(reactivateUserResponse);
  }

    Future<CommonModel>MutateActivateAccount(Map<String, dynamic> params) async{
    var reactivateUserResponse = await apiProvider.MutationWithParams(commonMutations.activateAccount, params);
    return CommonModel.fromJson(reactivateUserResponse);
  }

  Future<VerifyNewDeviceClass>MutateNewDeviceLogin(Map<String, dynamic> params) async{
    var reactivateUserResponse = await apiProvider.MutationWithParams(commonMutations.newDeviceLogin, params);
    return VerifyNewDeviceClass.fromJson(reactivateUserResponse);
  }
  /// forgotPasswordVerifyEmail
 Future<CommonModel>MutateForgotPasswordVerifyEmail(Map<String, dynamic> params) async{
    var verifyMailResponse = await apiProvider.MutationWithParams(commonMutations.verifyForgotPasswordVerifyMail, params);
    return CommonModel.fromJson(verifyMailResponse);
  }
  ///verifyRegisterEmail
  Future<CommonModel>MutateRegisterPasswordVerifyEmail(Map<String, dynamic> params) async{
    var verifyRegisterMailResponse = await apiProvider.MutationWithParams(commonMutations.verifyRegisterEmail, params);
    return CommonModel.fromJson(verifyRegisterMailResponse);
  }
}
