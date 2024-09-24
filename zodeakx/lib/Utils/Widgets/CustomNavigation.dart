import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Common/BankDetails/View/BankDetailsView.dart';
import 'package:zodeakx_mobile/Common/BankDetailsHistory/View/BankDetailHistoryView.dart';
import 'package:zodeakx_mobile/Common/Common/View/common_view.dart';
import 'package:zodeakx_mobile/Common/ConfirmPassword/View/ConfirmPasswordView.dart';
import 'package:zodeakx_mobile/Common/DeleteAccount/View/DeleteAccountView.dart';
import 'package:zodeakx_mobile/Common/Disable%20Google%20Authenticator/View/DiasbleGoogleAuthenticatorView.dart';
import 'package:zodeakx_mobile/Common/EmailVerificationScreen/Views/EmailVerificationView.dart';
import 'package:zodeakx_mobile/Common/Exchange/View/ExchangeView.dart';
import 'package:zodeakx_mobile/Common/ForgotPasswordScreen/View/ForgotPasswordView.dart';
import 'package:zodeakx_mobile/Common/IdentityVerification/View/IdentityVerificationCommonView.dart';
import 'package:zodeakx_mobile/Common/LoginPasswordChange/View/LoginPasswordChangeView.dart';
import 'package:zodeakx_mobile/Common/LoginScreen/Views/LoginView.dart';
import 'package:zodeakx_mobile/Common/ManageAccount/View/ManageAccountView.dart';
import 'package:zodeakx_mobile/Common/OrderDetails/View/OrderBookDetails.dart';
import 'package:zodeakx_mobile/Common/ReactiveAccount/View/ReactiveAccountView.dart';
import 'package:zodeakx_mobile/Common/RegisterScreen/Views/RegisterView.dart';
import 'package:zodeakx_mobile/Common/RegisterScreen/Views/WebViewForRegister.dart';
import 'package:zodeakx_mobile/Common/TradeView/View/TradeView.dart';
import 'package:zodeakx_mobile/Common/VerifyGoogleAuthCode/View/VerifyGoogleAuthview.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/ZodeakX/AntiPhishingCode/View/AntiPhishingView.dart';
import 'package:zodeakx_mobile/ZodeakX/DashBoardScreen/ViewModel/DashBoardViewModel.dart';
import 'package:zodeakx_mobile/ZodeakX/FiatDepositScreen/View/FiatDepositView.dart';
import 'package:zodeakx_mobile/ZodeakX/Security/View/SecurityView.dart';
import 'package:zodeakx_mobile/ZodeakX/Security/ViewModel/SecurityViewModel.dart';
import 'package:zodeakx_mobile/ZodeakX/Setting/View/SettingView.dart';
import 'package:zodeakx_mobile/p2p/add_payment_details/view/p2p_add_payment_details_view.dart';
import 'package:zodeakx_mobile/p2p/appeal_pending_view/view/p2p_appeal_pending_view.dart';
import 'package:zodeakx_mobile/p2p/appeal_progress_view/view/p2p_appeal_progress_view.dart';
import 'package:zodeakx_mobile/p2p/cancel_order_view/view/p2p_cancel_order_view.dart';
import 'package:zodeakx_mobile/p2p/chat_view/view/p2p_chat_view.dart';
import 'package:zodeakx_mobile/p2p/common_view/view/p2p_common_view.dart';
import 'package:zodeakx_mobile/p2p/counter_parties_profile/view/p2p_counter_profile_view.dart';
import 'package:zodeakx_mobile/p2p/crypto_releasing_view/view/p2p_crypto_releasing_view.dart';
import 'package:zodeakx_mobile/p2p/edit_an_ad_view/view/p2p_edit_an_ad_view.dart';
import 'package:zodeakx_mobile/p2p/home/model/p2p_advertisement.dart';
import 'package:zodeakx_mobile/p2p/order_created_view/view/p2p_order_created_view.dart';
import 'package:zodeakx_mobile/p2p/order_creation_view/view/p2p_order_creation_view.dart';
import 'package:zodeakx_mobile/p2p/orders/model/UserOrdersModel.dart';
import 'package:zodeakx_mobile/p2p/post_an_ad_view/view/p2p_post_an_ad_view.dart';
import 'package:zodeakx_mobile/p2p/profile_detail_view/view/p2p_profile_details_view.dart';
import 'package:zodeakx_mobile/p2p/profile_feedback_view/view/p2p_profile_feedback_view.dart';
import 'package:zodeakx_mobile/p2p/provide_more_info_view/view/p2p_provide_more_info_view.dart';
import 'package:zodeakx_mobile/p2p/reached_agreement_view/view/p2p_reached_agreement_view.dart';
import 'package:zodeakx_mobile/p2p/report_view/view/p2p_report_view.dart';
import 'package:zodeakx_mobile/p2p/successfully_posted_view/view/p2p_successfully_posted_view.dart';
import 'package:zodeakx_mobile/p2p/waiting_payment_view/view/p2p_waiting_payment_view.dart';
import 'package:zodeakx_mobile/staking/balance/model/ActiveUserStakesModel.dart';
import 'package:zodeakx_mobile/staking/balance/view/staking_balance_view.dart';
import 'package:zodeakx_mobile/staking/home_page/model/stacking_home_page_model.dart';
import 'package:zodeakx_mobile/staking/redemption_successful/view/redemption_successful_view.dart';
import 'package:zodeakx_mobile/staking/staking_history/view/staking_order_history_view.dart';
import 'package:zodeakx_mobile/staking/staking_transaction/view/staking_transaction_view.dart';
import 'package:zodeakx_mobile/staking/subcription_successful/view/subcription_successful_view.dart';

import '../../Common/GoogleAuthentication/View/GoogleAuthenticateCommonView.dart';
import '../../Common/OrderBook/View/OrderBookView.dart';
import '../../Common/OrderDetails/View/cancelOrderDetails.dart';
import '../../Common/OrderDetails/View/tradeHistoryOrderDetails.dart';
import '../../Common/Orders/Model/CancelledOrderModel.dart';
import '../../Common/Orders/Model/TradeHistoryModel.dart';
import '../../Common/Orders/Model/TradeOrderModel.dart';
import '../../Common/Orders/View/OrdersView.dart';
import '../../Common/Transfer/View/TransferView.dart';
import '../../Common/Wallets/CoinDetailsView/CoinDetailsView.dart';
import '../../Common/Wallets/CoinDetailsViewModel/GetcurrencyViewModel.dart';
import '../../Common/Wallets/CommonWithdraw/View/CommonWithdrawView.dart';
import '../../Common/Wallets/CryptoDeposit/View/crypto_deposit_view.dart';
import '../../Common/Wallets/TransactionDetails/View/TransactionDetailView.dart';
import '../../Common/Wallets/View/WalletView.dart';
import '../../Common/wallet_select/view/wallet_select_view.dart';
import '../../ZodeakX/CurrencyPreferenceScreen/View/CurrencyPreferenceView.dart';
import '../../ZodeakX/DashBoardScreen/View/DashBoardview.dart';
import '../../ZodeakX/ReferralScreen/View/ReferralView.dart';
import '../../funding_wallet/funding_coin_details/model/funding_wallet_balance.dart';
import '../../funding_wallet/funding_coin_details/view/funding_coin_details_view.dart';
import '../../funding_wallet/funding_history/view/funding_history_view.dart';
import '../../funding_wallet/wallet_details/view/funding_wallet_view.dart';
import '../../launchPad/common_view/view/launch_pad_common_view.dart';
import '../../launchPad/launchpad_project_detail/view/launchpad_project_detail_view.dart';
import '../../p2p/ads_detail_view/view/p2p_ads_details_view.dart';
import '../../p2p/appeal_view/view/p2p_appeal_view.dart';
import '../../p2p/confirm_payment_view/view/p2p_confirm_payment_view.dart';
import '../../p2p/edit_payment_details/view/p2p_edit_payment_details_view.dart';
import '../../p2p/feedback_view/view/p2p_feedback_view.dart';
import '../../p2p/order_details_view/view/p2p_order_details_view.dart';
import '../../p2p/pay_the_seller_view/view/p2p_pay_the_seller_view.dart';
import '../../p2p/payment_methods/view/p2p_payment_methods_view.dart';
import '../../p2p/profile/model/UserPaymentDetailsModel.dart';
import '../../p2p/select_payment/view/p2p_select_payment_view.dart';
import '../../p2p/trading_requirement/view/p2p_trading_requirement_view.dart';
import '../../staking/home_page/view/home_page_view.dart';
import '../../staking/search_coins/view/search_coins_view.dart';
import '../../staking/stacking_creation/view/stacking_creation_view.dart';
import '../../staking/staking_redemption/view/staking_redemption_view.dart';
import '../../staking/staking_successful/view/stacking_successful_view.dart';

moveToRegister(BuildContext context, [isLogin]) async {
  await Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => RegisterView(isLogin: isLogin)),
  );
}

void moveToMarket(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CommonView()),
  );
}

moveToLogin(BuildContext context, ScreenType emailScreenType) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => LoginView(verficationType: emailScreenType)),
  );
}

void moveToForgotPassword(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ForgotPasswordView()),
  );
}

void moveToCryptoDepositView(BuildContext context, String? currencyType) async {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => CryptoDepositView(currencyType: currencyType)),
  );
}

void moveToEmailVerification(
    BuildContext context,
    String? title,
    int? OTP,
    String? email,
    EmailVerificationType emailScreenType,
    String? tokenType) async {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => EmailVerificationScreen(
              screenTitle: title ?? stringVariables.resetPassword,
              tempOTP: OTP ?? 123456,
              userEmail: email ?? "${constant.appEmail}",
              verficationType: emailScreenType,
              tokenType: tokenType ?? "Register",
            )),
  );
}

void moveToConfirmPassword(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ConfirmPasswordView()),
  );
}

void moveToSetting(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SettingView()),
  );
}

void moveToReactivateAccount(
  BuildContext context,
) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ReactivateAccount()),
  );
}

void moveToDashBoard(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DashBoardView()),
  );
}

void moveToReferral(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ReferralView()),
  );
}

void moveToCurrency(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => const CurrencyPreferenceView()),
  );
}

void moveToSecurity(BuildContext context, String? buttonValue) async {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => SecurityView(
              buttonValue: buttonValue,
            )),
  );
}

void moveToLoginPasswordChange(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginPasswordChangeView()),
  );
}

void moveToAntiPhishingCode(
    BuildContext context, AuthenticationVerificationType screenType) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => AntiPhishingCodeView(screenType: screenType)),
  );
}

Future<void> moveToGoogleAuthenticateView(
  BuildContext context,
  String? screen, [
  SecurityViewModel? securityViewModel,
  DashBoardViewModel? getDashBoardBalance,
]) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => const GoogleAuthenticateCommonView()),
  );
  result
      ? setButtonValue(securityViewModel!, getDashBoardBalance!, screen)
      : () {};
}

void setButtonValue(SecurityViewModel securityViewModel,
    DashBoardViewModel dashBoardViewModel, String? screen) {
  return screen == "Security"
      ? securityViewModel
          .setButtonValue(constant.buttonValue.value == 'verified')
      : dashBoardViewModel
          .setButtonValue(constant.buttonValue.value == 'verified');
}

Future<void> moveToDisableGoogleAuthenticator(
  BuildContext context,
  String? screen, [
  SecurityViewModel? securityViewModel,
  DashBoardViewModel? getDashBoardBalance,
]) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => const DiableGoogleAuthenticatorView()),
  );
  result
      ? setButtonValue(securityViewModel!, getDashBoardBalance!, screen)
      : () {};
}
/*void moveToGoogleAuthenticateView(BuildContext context)async{
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>   const GoogleAuthenticateCommonView()

    ),
  );
}*/

/*void moveToDisableGoogleAuthenticator(BuildContext context)async{
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>   const DiableGoogleAuthenticatorView()

    ),
  );
}*/
void moveToIdentityVerification(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const IdentityVerificationView()),
  );
}

moveToVerifyCode(
    BuildContext context, AuthenticationVerificationType authScreenType,
    [GlobalKey<CommonWithdrawViewState>? key,
    GetCurrencyViewModel? getCurrencyViewModel,
    String? bank,
    String? amont,
    String? bankID,
    String? cryptoAmount,
    String? receipientAddress]) async {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => VerifyGoogleAuthView(screenType: authScreenType)),
  ).then((value) {
    userDetails(context, getCurrencyViewModel!, bank!, amont!, bankID!,
        cryptoAmount!, receipientAddress!, value);
  });
}

userDetails(
  BuildContext context,
  GetCurrencyViewModel getCurrencyViewModel,
  String bank,
  String amont,
  String bankID,
  String cryptoAmount,
  String receipientAddress,
  AuthenticationVerificationType value,
) {
  if (bank == '' && value == AuthenticationVerificationType.cryptoWithdraw) {
    getUsertypedDetails(
        context, getCurrencyViewModel, cryptoAmount, receipientAddress);
  } else if (bank != "" &&
      value == AuthenticationVerificationType.fiatWithdrawSubmit) {
    getUserFiattypedDetails(context, getCurrencyViewModel, bank, amont, bankID);
  } else if (value == AuthenticationVerificationType.dashBoard ||
      value == "") {}
}

getUserFiattypedDetails(
    BuildContext context,
    GetCurrencyViewModel getCurrencyViewModel,
    String bank,
    String amont,
    String bankID) {
  if (bank != "" && amont != "") {
    getCurrencyViewModel.CreateFiatWithdraw(
        constant.walletCurrency.value,
        double.parse(amont),
        getCurrencyViewModel.fiatWithdrawFee,
        double.parse(getCurrencyViewModel.withdrawFiat.toStringAsPrecision(2)),
        context,
        bankID);
  }
}

getUsertypedDetails(
    BuildContext context,
    GetCurrencyViewModel getCurrencyViewModel,
    String cryptoAmount,
    String receipientAddress) {
  if (cryptoAmount != "" && receipientAddress != "") {
    getCurrencyViewModel.CreateCryptoWithdraw(
        constant.walletCurrency.value,
        receipientAddress,
        double.parse(cryptoAmount),
        double.parse(
            getCurrencyViewModel.transactionFee.toStringAsPrecision(8)),
        double.parse(getCurrencyViewModel.withdraw.toStringAsPrecision(8)),
        double.parse(getCurrencyViewModel.youWillGet.toStringAsPrecision(8)),
        context);
  }
}

void moveToOrders(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const OrdersView()),
  );
}

void moveToExchange(BuildContext context, [String pair = "ETH/BTC"]) async {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => ExchangeView(
              pair: pair,
            )),
  );
}

void moveToBankDetails(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(builder: (context) => const BankDetailsView()),
  );
}

void moveToWallets(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const WalletView()),
  );
}

void moveToBankDetailsHistory(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => const BankDetailHistoryView()),
  );
}

void moveToFiatDeposit(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const FiatDepositView()),
  );
}

void moveToCoinDetailsView(
    BuildContext context,
    String? currencyName,
    String? totalBalance,
    String? availableBalance,
    String? currencyCode,
    String? currencyType,
    String? inorderBalance,  String? mlmBalance) async {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => CoinDetailsView(
            currencyName: currencyName,
            totalBalance: totalBalance,
            availableBalance: availableBalance,
            currencyCode: currencyCode,
            currencyType: currencyType,
            inorderBalance: inorderBalance)),
  );
}

void moveToCommonWithdrawView(
    BuildContext context, String? currencyType, String? currencyCode, String? availableBalance) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => CommonWithdrawView(
            currencyType: currencyType, currencyCode: currencyCode,availableBalance: availableBalance)),
  );
}

class CustomMaterialPageRoute extends MaterialPageRoute {
  bool backFlag = false;

  @protected
  bool get hasScopedWillPopCallback {
    return backFlag;
  }

  CustomMaterialPageRoute({
    required WidgetBuilder builder,
    bool backFlag = false,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        ) {
    this.backFlag = backFlag;
  }
}

moveToTransactionDetailView(
  BuildContext context,
  String? amount,
  String? modifiedDate,
  String? status,
  String? transactionId,
  String? currencyCode,
  String? payMode,
  String? typename,
  String? type,
  String? adminFee,
  String? receivedAmount,
  String? sentAmount,
  String? fromAddress,
  String? toAddress,
  String? sentCryptoAmount,
  String? receivedCryptoAmount,
  String? cryptoCreatedDate,
  String? cryptoAdminFee,
) async {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => TransactionDetailView(
            amount: amount,
            modifiedDate: modifiedDate,
            status: status,
            transactionId: transactionId,
            currencyCode: currencyCode,
            payMode: payMode,
            typename: typename,
            type: type,
            adminFee: adminFee,
            receivedAmount: receivedAmount,
            sentAmount: sentAmount,
            fromAddress: fromAddress,
            toAddress: toAddress,
            sentCryptoAmount: sentCryptoAmount,
            receivedCryptoAmount: receivedCryptoAmount,
            cryptoCreatedDate: cryptoCreatedDate,
            cryptoAdminFee: cryptoAdminFee)),
  );
}

void moveToOrderBook(BuildContext context, String pair) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => OrderBookView(
              pair: pair,
            )),
  );
}

void moveToOrderDetails(BuildContext context,String orderName,Order order) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => OrderDetailsView(
          order: order,
        )),
  );
}

moveToCancelDetails(BuildContext context,String orderName,CancelOrder? cancelOrder,) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => CancelOrderDetailsView(
          orderName:orderName,
          cancelOrder:cancelOrder,

        )),
  );
}

moveToTradeHistoryDetails(BuildContext context,String orderName,TradeHistoryModelDetails? tradeHistoryModelDetails) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => TradeHistoryDetailsView(
            orderName:orderName,
            tradeHistoryModelDetails:tradeHistoryModelDetails
        )),
  );
}

void moveToTrade(BuildContext context, String pair) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => TradeView(
              pair: pair,
            )),
  );
}

void moveToManageAccount(
  BuildContext context,
) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(builder: (context) => ManageAccountView()),
  );
}

void moveToDeleteAccount(
  BuildContext context,
) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(builder: (context) => DeleteAccountView()),
  );
}

void moveToWebView(
  BuildContext context,
  String url,
) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => WebViewForRegister(url: url)),
  );
}

//p2p starts
void moveToP2P(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(builder: (context) => const P2PCommonView()),
  );
}

void moveToPaymentMethods(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => const P2PPaymentMethodsView()),
  );
}

void moveToSelectPayment(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(builder: (context) => const P2PSelectPaymentView()),
  );
}

void moveToProfileDetails(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => const P2PProfileDetailsView()),
  );
}

void moveToTradingRequirement(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => const P2PTradingRequirementView()),
  );
}

void moveToCounterProfile(BuildContext context, String userId) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => P2PCounterProfileView(
              userId: userId,
            )),
  );
}

void moveToAddPayment(BuildContext context, String title) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => P2PAddPaymentDetailsView(
              title: title,
            )),
  );
}

void moveToEditPayment(
    BuildContext context, UserPaymentDetails userPaymentDetails) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) =>
            P2PEditPaymentDetailsView(userPaymentDetails: userPaymentDetails)),
  );
}

void moveToProfileFeedback(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => const P2PProfileFeedbackView()),
  );
}

void moveToAdsDetailsView(BuildContext context, String id) async {
  Navigator.push(context,
      CustomMaterialPageRoute(builder: (context) => P2PAdsDetailsView(id: id)));
}

void moveToOrderCreatedView(
    BuildContext context, String id, String adId, int? timeLimit,
    [String? paymentMethodName]) async {
  Navigator.push(
      context,
      CustomMaterialPageRoute(
          builder: (context) => P2POrderCreatedView(
              id: id,
              adId: adId,
              paymentMethodName: paymentMethodName,
              timeLimit: timeLimit)));
}

void moveToConfirmPaymentView(
  BuildContext context,
  double amount,
  String fiatCurrency,
  String paymentMethodName,
  String adid,
  String logginUser,
  String buyerName,
  String orderNo,
) async {
  Navigator.push(
      context,
      CustomMaterialPageRoute(
          builder: (context) => P2PConfirmPaymentView(
                amount: amount,
                fiatCurrency: fiatCurrency,
                paymentMethodName: paymentMethodName,
                adid: adid,
                logginUser: logginUser,
                buyerName: buyerName,
                orderNo: orderNo,
              )));
}

void moveToFeedbackView(BuildContext context) async {
  Navigator.push(context,
      CustomMaterialPageRoute(builder: (context) => P2PFeedbackView()));
}

void moveToCryptoReleasingView(
    BuildContext context,
    String id,
    List<UserPaymentDetails>? paymentMethods,
    UserOrdersModel? userOrdersModel) async {
  Navigator.push(
      context,
      CustomMaterialPageRoute(
          builder: (context) => P2PCryptoReleasingView(
              id: id,
              paymentMethods: paymentMethods,
              userOrdersModel: userOrdersModel)));
}

void moveToChatView(BuildContext context, String id) async {
  Navigator.push(context,
      CustomMaterialPageRoute(builder: (context) => P2PChatView(id: id)));
}

void moveToAppealProgressView(BuildContext context, String id,
    [String amount = "500", String symbol = "\$", String side = ""]) async {
  Navigator.push(
      context,
      CustomMaterialPageRoute(
          builder: (context) => P2PAppealProgressView(
              id: id, amount: amount, symbol: symbol, side: side)));
}

void moveToOrderDetailsView(BuildContext context, String id, String? user_id,
    String? adid, String? paymentMethodName,
    [String? view]) async {
  Navigator.push(
      context,
      CustomMaterialPageRoute(
          builder: (context) => P2POrderDetailsView(
              id: id,
              user_id: user_id,
              adid: adid,
              paymentMethodName: paymentMethodName,
              view: view)));
}

void moveToAppealView(
    BuildContext context, String id, String? side, String loggedInUser) async {
  Navigator.push(
      context,
      CustomMaterialPageRoute(
          builder: (context) =>
              P2PAppealView(id: id, side: side, loggedInUser: loggedInUser)));
}

void moveToAppealPendingView(
    BuildContext context, OrdersData ordersData) async {
  Navigator.push(
      context,
      CustomMaterialPageRoute(
          builder: (context) => P2PAppealPendingView(ordersData: ordersData)));
}

void moveToSuccessfullyPostedView(BuildContext context) async {
  Navigator.push(
      context,
      CustomMaterialPageRoute(
          builder: (context) => P2PSuccessfullyPostedView()));
}

void moveToProvideMoreInfoView(
    BuildContext context, String id, bool isProvide) async {
  Navigator.push(
      context,
      CustomMaterialPageRoute(
          builder: (context) =>
              P2PProvideMoreInfoView(id: id, isProvide: isProvide)));
}

void moveToReachedAgreementView(
    BuildContext context, String id, bool color, String? side) async {
  Navigator.push(
      context,
      CustomMaterialPageRoute(
          builder: (context) =>
              P2PReachedAgreementView(id: id, color: color, side: side)));
}

void moveToWaitingPaymentView(BuildContext context, String id, String user_id,
    String? paymentMethodName, int? timeLimit) async {
  Navigator.push(
      context,
      CustomMaterialPageRoute(
          builder: (context) => P2PWaitingPaymentView(
              id: id,
              user_id: user_id,
              paymentMethodName: paymentMethodName,
              timeLimit: timeLimit)));
}

void moveToCancelOrderView(
  BuildContext context,
  String id,
) async {
  Navigator.push(
      context,
      CustomMaterialPageRoute(
          builder: (context) => P2PCancelOrderView(id: id)));
}

void moveToPostAnAdView(
  BuildContext context,
) async {
  Navigator.push(context,
      CustomMaterialPageRoute(builder: (context) => P2PPostAnAdView()));
}

void moveToEditAnAdView(
  BuildContext context,
  String id,
) async {
  Navigator.push(context,
      CustomMaterialPageRoute(builder: (context) => P2PEditAnAdView(id: id)));
}

void moveToPayTheSellerView(BuildContext context, String id, String? banktype,
    String? adId, UserOrdersModel? userOrdersModel) async {
  Navigator.push(
      context,
      CustomMaterialPageRoute(
          builder: (context) => P2PPayTheSellerView(
              id: id,
              banktype: banktype,
              adId: adId,
              userOrdersModel: userOrdersModel)));
}

void moveToOrderCreation(BuildContext context, bool isBuy,
    Advertisement advertisement, int page) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => P2POrderCreationView(
            isBuy: isBuy, advertisement: advertisement, page: page)),
  );
}

void moveToReport(BuildContext context, String id) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => P2PReportView(
              id: id,
            )),
  );
}
//p2p ends

//staking starts

void moveToStackingHomePageView(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(builder: (context) => StackingHomePageView()),
  );
}

void moveToTransferView(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(builder: (context) => TransferView()),
  );
}

void moveToWalletSelectView(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(builder: (context) => WalletSelectView()),
  );
}

void moveToSearchCoinsView(BuildContext context, bool isHistory) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => SearchCoinsView(
              isHistory: isHistory,
            )),
  );
}

void moveToStackingSuccessfulView(
    BuildContext context, String amount, String code) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) =>
            StackingSuccessfulView(amount: amount, code: code)),
  );
}

void moveToStackingCreationView(BuildContext context, String viewType,
    GetAllActiveStatus activeStakesList) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => StackingCreationView(
            viewType: viewType, activeStakesList: activeStakesList)),
  );
}

void moveToTransaction(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(builder: (context) => StakingTransactionView()),
  );
}

void moveToBalance(
    BuildContext context, StakeItem userStakeDetail) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => StakingBalanceView(
              userStakeDetail: userStakeDetail,
            )),
  );
}

void moveToOrderHistory(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(builder: (context) => StakingOrderHistoryView()),
  );
}

void moveToRedemptionSuccessful(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(builder: (context) => RedemptionSuccessfulView()),
  );
}

void moveToSubcriptionSuccessful(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(builder: (context) => SubcriptionSuccessfulView()),
  );
}

void moveToRedemption(
    BuildContext context, StakeItem userStakeDetail) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => StakingRedemptionView(
              userStakeDetail: userStakeDetail,
            )),
  );
}
//staking ends

// funding starts
// funding starts
void moveToFundingWalletView(
    BuildContext context, GetUserFundingWalletDetails item) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => FundingWalletView(item: item)),
  );
}

void moveToFundingHistoryView(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(builder: (context) => FundingHistoryView()),
  );
}

void moveToFundingCoinDetailsView(BuildContext context, String coin) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => FundingCoinDetailsView(
          coin: coin,
        )),
  );
}
// funding ends

// launch pad starts
void moveToProjectDetail(BuildContext context, String projectId) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(
        builder: (context) => LaunchpadProjectDetailView(
          projectId: projectId,
        )),
  );
}

void moveToLaunchPad(BuildContext context) async {
  Navigator.push(
    context,
    CustomMaterialPageRoute(builder: (context) => LaunchPadCommonView()),
  );
}
// launch pad ends

