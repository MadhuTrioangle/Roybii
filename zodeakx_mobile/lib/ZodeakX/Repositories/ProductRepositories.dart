import 'package:zodeakx_mobile/Common/BankDetailsHistory/Model/BankDetailHistoryModel.dart';
import 'package:zodeakx_mobile/Common/Exchange/Model/AllOpenOrderHistoryModel.dart';
import 'package:zodeakx_mobile/Common/Exchange/Model/GetBalance.dart';
import 'package:zodeakx_mobile/Common/OrderBook/Model/OrderBookModel.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/APIProvider.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Mutation/CommonMutations.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Queries/FiatCurrencyQueries.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Queries/MarginTradingQueries.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Queries/MarketQueries.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Queries/P2PQueries.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Queries/SettingQueries.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Queries/futureQueries.dart';
import 'package:zodeakx_mobile/ZodeakX/CurrencyPreferenceScreen/Model/CurrencyPreferenceModel.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/Model/TradePairsModel.dart';
import 'package:zodeakx_mobile/ZodeakX/Setting/Model/GetActivityModel.dart';
import 'package:zodeakx_mobile/ZodeakX/Setting/Model/GetUserByJwtModel.dart';
import 'package:zodeakx_mobile/p2p/counter_parties_profile/model/FeedbackDataModel.dart';
import 'package:zodeakx_mobile/p2p/counter_parties_profile/model/UserCenterModel.dart';
import 'package:zodeakx_mobile/p2p/order_creation_view/model/OrderCreationModel.dart';
import 'package:zodeakx_mobile/p2p/order_details_view/model/FeedbackModel.dart';

import '../../Common/Common/model/MerchantPaymentLinkModel.dart';
import '../../Common/Common/model/MerchantRecurringInvoiceModel.dart';
import '../../Common/Exchange/Model/FavPairModel.dart';
import '../../Common/Exchange/Model/market_currency_model.dart';
import '../../Common/GoogleAuthentication/Model/QRCodeModel.dart';
import '../../Common/GoogleAuthentication/Model/SendEmailCodeModel.dart';
import '../../Common/IdentityVerification/Model/IdentityVerificationModel.dart';
import '../../Common/Orders/Model/CancelledOrderModel.dart';
import '../../Common/Orders/Model/TradeHistoryModel.dart';
import '../../Common/Orders/Model/TradeOrderModel.dart';
import '../../Common/RegisterScreen/Model/ReferralIdModel.dart';
import '../../Common/RegisterScreen/Model/SocialMediaModel.dart';
import '../../Common/SplashScreen/Model/SplashModel.dart';
import '../../Common/TradeView/Model/TradeHistoryModel.dart';
import '../../Common/Wallets/CoinDetailsModel/CoinDetailsModel.dart';
import '../../Common/Wallets/CoinDetailsModel/FiatCurrencyModel.dart';
import '../../Common/Wallets/CoinDetailsModel/find_address.dart';
import '../../Common/Wallets/CoinDetailsModel/get_currency.dart';
import '../../Common/Wallets/CryptoDeposit/Model/CryptoDepositModel.dart';
import '../../Common/Wallets/TransactionDetails/Model/CryptoDepositHistoryModel.dart';
import '../../Common/Wallets/TransactionDetails/Model/CryptoWithdrawHistoryModel.dart';
import '../../Common/Wallets/TransactionDetails/Model/FiatDepositHistoryModel.dart';
import '../../Common/Wallets/TransactionDetails/Model/FiatWithdrawHistory.dart';
import '../../Common/Wallets/funding_coin_details/model/UserFundingWalletDetailsModel.dart';
import '../../Common/transfer/model/funding_wallet_balance.dart';
import '../../Common/transfer_history/model/TransferHistoryModel.dart';
import '../../Common/transfer_history/model/funding_transfer_history_details.dart';
import '../../Utils/Core/Networking/CommonModel/CommonModel.dart';
import '../../p2p/ads/model/HighestPriceModel.dart';
import '../../p2p/appeal_progress_view/Model/p2p_appeal_progress_model.dart';
import '../../p2p/chat_view/model/MessageHistoryModel.dart';
import '../../p2p/home/model/p2p_advertisement.dart';
import '../../p2p/home/model/p2p_currency.dart';
import '../../p2p/home/model/p2p_payment_methods.dart';
import '../../p2p/orders/model/UserOrdersModel.dart';
import '../../p2p/profile/model/UserActivityModel.dart';
import '../../p2p/profile/model/UserPaymentDetailsModel.dart';
import '../DashBoardScreen/Model/DashBoardModel.dart';
import '../DashBoardScreen/Model/ExchangeRateModel.dart';
import '../FiatDepositScreen/Model/FIatDepositModel.dart';
import '../FiatDepositScreen/Model/FiatCommonDepositModel.dart';
import '../FiatDepositScreen/Model/GetPaymentCurrencyExchangeRateModel.dart';
import '../FiatDepositScreen/Model/braintree_client_token.dart';
import '../HomeScreen/Model/HomeModel.dart';
import '../MarketScreen/NewModel/GetFavouriteMarkets.dart';
import '../MarketScreen/NewModel/GetFutureMarkets.dart';
import '../MarketScreen/NewModel/GetSpotMarkets.dart';
import '../ReferralScreen/Model/ReferralLinksModel.dart';
import '../ReferralScreen/Model/ReferralModel.dart';
import '../Setting/Model/GetPersonalDetailsModel.dart';

ProductRepository productRepository = ProductRepository();

class ProductRepository {
  /// Fetch trade pairs
  Future<TradePairs> fetchTradePairs(Map<String, dynamic> params) async {
    final tradeResponse =
        await apiProvider.QueryWithParams(marketQueries.getTradePairs, params);
    return TradePairs.fromJson(tradeResponse);
  }

  Future<GetSpotMarketModelClass> fetchSpotMarketPair(
      Map<String, dynamic> params) async {
    final response =
        await apiProvider.QueryWithParams(marketQueries.getSpotMarket, params);
    return GetSpotMarketModelClass.fromJson(response);
  }

  Future<CommonModel> createWalletConvert(
      Map<String, dynamic> mutateUserParams) async {
    final dashBoardBalanceResponse = await apiProvider.MutationWithParams(
        CommonMutations().walletConvert, mutateUserParams);
    return CommonModel.fromJson(dashBoardBalanceResponse);
  }

  Future<GetFutureMarketModelClass> fetchFutureMarketPair(
      Map<String, dynamic> params) async {
    final response = await apiProvider.QueryWithParams(
        marketQueries.getFutureMarket, params);
    return GetFutureMarketModelClass.fromJson(response);
  }

  Future<FavoriteAllMarketsModelClass> fetchFavouriteMarket() async {
    final response =
        await apiProvider.QueryWithoutParams(marketQueries.getFavoriteMarkets);
    return FavoriteAllMarketsModelClass.fromJson(response);
  }

  Future<TransferHistoryModel> fetchTransferHistory(
      Map<String, dynamic> mutateUserParams) async {
    final response = await apiProvider.QueryWithParams(
        marginTradingQueries.fetchTransferHistory, mutateUserParams);
    return TransferHistoryModel.fromJson(response);
  }

  Future<BraintreeClientTokenModel> fetchBraintreeClientToken() async {
    final tradeResponse = await apiProvider.QueryWithoutParams(
        marketQueries.getBraintreeClientToken);
    return BraintreeClientTokenModel.fromJson(tradeResponse);
  }

  /// Fetch Admin Bank Detail
  Future<AdminBankDetails> fetchAdminDetails() async {
    final adminDetailResponse =
        await apiProvider.QueryWithoutParams(marketQueries.getAdminBankDetail);
    return AdminBankDetails.fromJson(adminDetailResponse);
  }

  /// Fetch FiatCurrency
  Future<GetFiatCurrency> fetchFiatCurrency() async {
    final currencyResponse = await apiProvider.QueryWithoutParams(
        fiatCurrencyQueries.getFiatCurrency);
    return GetFiatCurrency.fromJson(currencyResponse);
  }

  ///Fetch Bank Details History
  Future<GetBankDetails> fetchBankDetailsHistory() async {
    final bankDetailResponse = await apiProvider.QueryWithoutParams(
        marketQueries.getBankDetailsHistory);
    return GetBankDetails.fromJson(bankDetailResponse);
  }

  /// Fetch IpAndTime
  Future<GetActivity> fetchIpAndTime() async {
    final timeAndIpResponse =
        await apiProvider.QueryWithoutParams(settingQueries.getIpAndTime);
    return GetActivity.fromJson(timeAndIpResponse);
  }

  /// Fetch IdVerification
  Future<GetUserByJwt> fetchIdVerification() async {
    final status =
        await apiProvider.QueryWithoutParams(settingQueries.getKycStatus);
    return GetUserByJwt.fromJson(status);
  }

  /// Fetch Personal Details
  Future<GetPersonalDetailsClass> fetchPersonalDetails() async {
    final status =
        await apiProvider.QueryWithoutParams(settingQueries.getPersonalDetails);
    return GetPersonalDetailsClass.fromJson(status);
  }

  /// Fetch referral List Dashboard
  Future<GetReferralDashboard> fetchReferralList(
      Map<String, dynamic> params) async {
    final referralResponse = await apiProvider.QueryWithParams(
        marketQueries.getReferralDashboard, params);
    return GetReferralDashboard.fromJson(referralResponse);
  }

  /// Fetch  ReferralLinkByReferralId
  Future<GetReferralLinkByReferral> fetchReferralLink(
      Map<String, dynamic> params) async {
    final paymentExchangeResponse =
        await apiProvider.QueryWithParams(marketQueries.getReferralId, params);
    return GetReferralLinkByReferral.fromJson(paymentExchangeResponse);
  }

  /// Fetch fetchDashBoardBalance
  Future<GetBalance> fetchDashBoardBalance(
      Map<String, dynamic> mutateUserParams) async {
    final dashBoardBalanceResponse = await apiProvider.QueryWithParams(
        marketQueries.getBalance, mutateUserParams);
    return GetBalance.fromJson(dashBoardBalanceResponse);
  }

  /// fetch dashboard balance without query params
  Future<GetBalance> fetchBalance() async {
    final fetchBalance =
        await apiProvider.QueryWithoutParams(marketQueries.getBalance);
    return GetBalance.fromJson(fetchBalance);
  }

  /// Fetch Default Currency
  Future<GetDefaultCurrency> fetchDefaultCurrency() async {
    final defaultCurrencyResponse =
        await apiProvider.QueryWithoutParams(marketQueries.defaultCurrency);
    return GetDefaultCurrency.fromJson(defaultCurrencyResponse);
  }

  /// Fetch User Crypto Btc Address
  Future<UserCryptoAddress> fetchCryptoBtcAddress() async {
    final userCryptoBtcAddressResponse =
        await apiProvider.QueryWithoutParams(marketQueries.findBtcAddress);
    return UserCryptoAddress.fromJson(userCryptoBtcAddressResponse);
  }

  /// Fetch User Crypto Eth Address
  Future<UserCryptoAddress> fetchCryptoEthAddress() async {
    final userCryptoAddressResponse =
        await apiProvider.QueryWithoutParams(marketQueries.findEthAddress);
    return UserCryptoAddress.fromJson(userCryptoAddressResponse);
  }

  /// Fetch User Crypto Ltc Address
  Future<UserCryptoAddress> fetchCryptoLtcAddress() async {
    final userCryptoLtcAddressResponse =
        await apiProvider.QueryWithoutParams(marketQueries.findLtcAddress);
    return UserCryptoAddress.fromJson(userCryptoLtcAddressResponse);
  }

  /// Fetch ExchangeRate
  Future<GetExchangeRate> fetchExchangeRate(Map<String, dynamic> params) async {
    final exchangeResponse = await apiProvider.QueryWithParams(
        marketQueries.getExchangeRate, params);
    return GetExchangeRate.fromJson(exchangeResponse);
  }

  Future<UserFundingWalletDetailsModel> getUserFundingWalletDetails() async {
    final response = await apiProvider.QueryWithoutParams(
        marketQueries.getUserFundingWalletDetails);
    return UserFundingWalletDetailsModel.fromJson(response);
  }

  /// Fetch Payment Currency Exchange Rate
  Future<GetPaymentCurrencyExchangeRate> fetchPaymentExchangeRate(
      Map<String, dynamic> params) async {
    final paymentExchangeResponse = await apiProvider.QueryWithParams(
        marketQueries.paymentExchangeRate, params);
    return GetPaymentCurrencyExchangeRate.fromJson(paymentExchangeResponse);
  }

  Future<MerchantPaymentLinkModel> getMerchantPaymentLink(
      Map<String, dynamic> mutateUserParams) async {
    final response = await apiProvider.QueryWithParams(
        marketQueries.getMerchantPaymentLink, mutateUserParams);
    return MerchantPaymentLinkModel.fromJson(response);
  }

  Future<MerchantRecurringInvoiceModel> getMerchantAllInvoice(
      Map<String, dynamic> mutateUserParams) async {
    final response = await apiProvider.QueryWithParams(
        marketQueries.getMerchantAllInvoice, mutateUserParams);
    return MerchantRecurringInvoiceModel.fromJson(response);
  }

  /// Create Crypto Withdraw
  Future<CreateFiatDepositModel> mutateCryptoWithdraw(
      Map<String, dynamic> mutateUserParams) async {
    final responsemutateCryptoWithdraw = await apiProvider.MutationWithParams(
        CommonMutations().createCryptoWithdraw, mutateUserParams);
    return CreateFiatDepositModel.fromJson(responsemutateCryptoWithdraw);
  }

  /// Create Fiat Withdraw
  Future<CreateFiatDepositModel> mutateFiatWithdraw(
      Map<String, dynamic> mutateUserParams) async {
    final responsemutateFiatWithdraw = await apiProvider.MutationWithParams(
        CommonMutations().createFiatWithdraw, mutateUserParams);
    return CreateFiatDepositModel.fromJson(responsemutateFiatWithdraw);
  }

  /// Fetch inOrderBalance
  Future<InOrderBalanceModel> fetchInOrderBalance(
      Map<String, dynamic> params) async {
    final InOrderBalanceModelResponse =
        await apiProvider.QueryWithParams(marketQueries.inorderBalance, params);
    return InOrderBalanceModel.fromJson(InOrderBalanceModelResponse);
  }

  /// Fetch Crypto Currency
  Future<GetCurrencyModel> fetchCryptoCurrency() async {
    final crytpocurrencyResponse =
        await apiProvider.QueryWithoutParams(marketQueries.cryptoCurrency);
    return GetCurrencyModel.fromJson(crytpocurrencyResponse);
  }

  /// Fetch Fiat inOrderBalance
  Future<InOrderBalanceModel> fetchFiatInOrderBalance(
      Map<String, dynamic> params) async {
    final fiatInOrderBalanceModelResponse = await apiProvider.QueryWithParams(
        marketQueries.fiatInorderBalance, params);
    return InOrderBalanceModel.fromJson(fiatInOrderBalanceModelResponse);
  }

  ///Fetch Referral Id
  Future<GetReferralLinks> fetchReferralId() async {
    final refferalIdResponse =
        await apiProvider.QueryWithoutParams(marketQueries.getReferralLinks);
    return GetReferralLinks.fromJson(refferalIdResponse);
  }

  ///Generate Referral Link
  Future<CommonModel> generateReferralId(
      Map<String, dynamic> mutateUserParams) async {
    final dashBoardBalanceResponse = await apiProvider.MutationWithParams(
        CommonMutations().generateReferralLink, mutateUserParams);
    return CommonModel.fromJson(dashBoardBalanceResponse);
  }

  /// Fetch SecretCode
  Future<Gettfa> fetchSecretCode() async {
    final tfaresponse =
        await apiProvider.QueryWithoutParams(marketQueries.getTFA);
    return Gettfa.fromJson(tfaresponse);
  }

  ///update Personal Information
  Future<CommonModel> updatePersonalInfo(
      Map<String, dynamic> mutateUserParams) async {
    final dashBoardBalanceResponse = await apiProvider.MutationWithParams(
        CommonMutations().updatePersonalInformation, mutateUserParams);
    return CommonModel.fromJson(dashBoardBalanceResponse);
  }

  ///update Fiat Deposit
  Future<CreateFiatDepositModel> updateFiatDeposit(
      Map<String, dynamic> mutateUserParams) async {
    final fiatDepositResponse = await apiProvider.MutationWithParams(
        CommonMutations().createFiatDeposit, mutateUserParams);
    return CreateFiatDepositModel.fromJson(fiatDepositResponse);
  }

  ///update Fiat Transaction
  Future<CommonModel> updateFiatTransaction(
      Map<String, dynamic> mutateUserParams) async {
    final fiatDepositResponse = await apiProvider.MutationWithParams(
        CommonMutations().createFiatTransaction, mutateUserParams);
    return CommonModel.fromJson(fiatDepositResponse);
  }

  ///update New Password
  Future<CommonModel> updateNewPassword(
      Map<String, dynamic> mutateUserParams) async {
    final NewPasswordResponse = await apiProvider.MutationWithParams(
        CommonMutations().updateNewPassword, mutateUserParams);
    return CommonModel.fromJson(NewPasswordResponse);
  }

  ///update Id information
  Future<UpdateIdProof> updateIdInformation(
      Map<String, dynamic> mutateUserParams) async {
    final UpdateIdInformation = await apiProvider.MutationWithParams(
        CommonMutations().updateIdInfo, mutateUserParams);
    return UpdateIdProof.fromJson(UpdateIdInformation);
  }

  ///update Facial information
  Future<CommonModel> updateFacialInformation(
      Map<String, dynamic> mutateUserParams) async {
    final UpdateFacialInformation = await apiProvider.MutationWithParams(
        CommonMutations().updateFacialInfo, mutateUserParams);
    return CommonModel.fromJson(UpdateFacialInformation);
  }
  ///GetMarketOverview
  Future<GetMarketOverviewModel> getMarketOverview() async {
    final getMarketOverviewresponse =
    await apiProvider.QueryWithoutParams(marketQueries.getMarketOverview);
    return GetMarketOverviewModel.fromJson(getMarketOverviewresponse);
  }


  /// Get Currency
  Future<GetCurrencyModel> getCurrency() async {
    final getCurrencyresponse =
        await apiProvider.QueryWithoutParams(marketQueries.getCurrency);
    return GetCurrencyModel.fromJson(getCurrencyresponse);
  }

  /// Get Fiat Currency
  Future<GetFiatCurrencyForWithdraw> getFiatCurrency() async {
    final getFiatCurrencyresponse =
        await apiProvider.QueryWithoutParams(marketQueries.getFiatCurrency);
    return GetFiatCurrencyForWithdraw.fromJson(getFiatCurrencyresponse);
  }

  /// Fetch Crypto Withdraw History Details
  Future<CryptoWithdrawHistory> fetchCryptoWithdrawHistoryDetails(
      Map<String, dynamic> params) async {
    final CryptoWithdrawHistoryResponse = await apiProvider.QueryWithParams(
        marketQueries.CryptoWithdrawHistoryDetails, params);
    return CryptoWithdrawHistory.fromJson(CryptoWithdrawHistoryResponse);
  }

  /// Fetch Crypto Deposit History Details
  Future<CryptoDepositHistory> fetchCryptoDepositHistoryDetails(
      Map<String, dynamic> params) async {
    final CryptoDepositHistoryResponse = await apiProvider.QueryWithParams(
        marketQueries.CryptoDepositHistoryDetails, params);
    return CryptoDepositHistory.fromJson(CryptoDepositHistoryResponse);
  }

  /// Fetch Fiat Withdraw History Details
  Future<FiatWithdrawHistory> fetchFiatWithdrawHistory() async {
    final fiatWithdrawHistoryResponse = await apiProvider.QueryWithoutParams(
        marketQueries.getFiatWithdrawHistoryDetails);
    return FiatWithdrawHistory.fromJson(fiatWithdrawHistoryResponse);
  }

  /// Fetch Fiat Deposit History Details
  Future<FiatDepositHistory> fetchFiatDepositHistory() async {
    final fiatDepositHistoryResponse = await apiProvider.QueryWithoutParams(
        marketQueries.getFiatDepositHistoryDetails);
    return FiatDepositHistory.fromJson(fiatDepositHistoryResponse);
  }

  ///getMarketCurrency
  Future<MarketCurrencyModel> getMarketCurrency() async {
    var marketCurrencyRespose =
        await apiProvider.QueryWithoutParams(marketQueries.getMarketCurrency);
    return MarketCurrencyModel.fromJson(marketCurrencyRespose);
  }

  ///create order - common for limit, market and stop-limit
  Future<CommonModel> createOrder(Map<String, dynamic> mutateUserParams) async {
    final createOrder = await apiProvider.MutationWithParams(
        CommonMutations().createOrder, mutateUserParams);
    return CommonModel.fromJson(createOrder);
  }

  /// Fetch Price tickers for pair
  Future<TradePairs> fetchPriceTickers(Map<String, dynamic> params) async {
    final priceTickersResponse = await apiProvider.QueryWithParams(
        marketQueries.getPriceTickers, params);
    return TradePairs.fromJson(priceTickersResponse);
  }

  /// Fetch open order history
  Future<TradeOrderModel> fetchOpenOrderHistory(
      Map<String, dynamic> params) async {
    final openOrderResponse =
        await apiProvider.QueryWithParams(marketQueries.getTradeOrder, params);
    return TradeOrderModel.fromJson(openOrderResponse);
  }

  /// Fetch cancel order history
  Future<CancelledOrderModelClass> fetchCancelOrderrHistory(
      Map<String, dynamic> params) async {
    final openOrderResponse =
        await apiProvider.QueryWithParams(marketQueries.getTradeOrder, params);
    return CancelledOrderModelClass.fromJson(openOrderResponse);
  }

  /// Fetch trade history
  Future<TradeHistoryModelClass> fetchTradeHistory(
      Map<String, dynamic> params) async {
    final tradeResponse =
        await apiProvider.QueryWithParams(marketQueries.tradeHistory, params);
    return TradeHistoryModelClass.fromJson(tradeResponse);
  }

  /// cancel open order
  Future<CommonModel> cancelOrder(Map<String, dynamic> params) async {
    final cancelResponse =
        await apiProvider.MutationWithParams(marketQueries.cancelOrder, params);
    return CommonModel.fromJson(cancelResponse);
  }

  /// Fetch Order details
  Future<GetOpenOrders> orderDetails(Map<String, dynamic> params) async {
    final response =
        await apiProvider.MutationWithParams(marketQueries.orderBook, params);
    return GetOpenOrders.fromJson(response);
  }

  /// Fetch Trade history
  Future<TradesHistoryModel> tradeHistory(Map<String, dynamic> params) async {
    final response = await apiProvider.MutationWithParams(
        marketQueries.marketTrades, params);
    return TradesHistoryModel.fromJson(response);
  }

  /// Fetch Your Trade history
  Future<TradesHistoryModel> yoursTradeHistory(
      Map<String, dynamic> params) async {
    final response =
        await apiProvider.MutationWithParams(marketQueries.yoursTrades, params);
    return TradesHistoryModel.fromJson(response);
  }

  ///get balance
  Future<GetBalanceModel> getBalance(
      Map<String, dynamic> mutateUserParams) async {
    final getBalance = await apiProvider.MutationWithParams(
        CommonMutations().getBalanceMutation, mutateUserParams);
    return GetBalanceModel.fromJson(getBalance);
  }

  /// Fetch Address
  Future<AddressCommonResponse> fetchFindAddress(address) async {
    final crytpocurrencyResponse =
        await apiProvider.QueryWithoutParams(address);
    return AddressCommonResponse.fromJson(crytpocurrencyResponse);
  }

  Future<CommonModel> verifyKyc() async {
    final verifyKyc =
        await apiProvider.MutationWithoutParams(CommonMutations().verifyKyc);
    return CommonModel.fromJson(verifyKyc);
  }

  Future<CommonModel> deleteUserRequest() async {
    final response = await apiProvider.MutationWithoutParams(
        CommonMutations().deleteUserRequest);
    return CommonModel.fromJson(response);
  }

  Future<CreateFiatDepositModel> fetchVerifyDeleteAccount(
      Map<String, dynamic> mutateUserParams) async {
    final changePasswordCodeResponse = await apiProvider.QueryWithParams(
        marketQueries.deleteAccount, mutateUserParams);
    return CreateFiatDepositModel.fromJson(changePasswordCodeResponse);
  }

  //p2p starts
  Future<P2PCurrencyModel> fetchP2PCurrency(params) async {
    final response =
        await apiProvider.QueryWithParams(p2pQueries.fetchP2PCurrency, params);
    return P2PCurrencyModel.fromJson(response);
  }

  Future<HighestPriceModel> fetchHighestPrice(params) async {
    final response =
        await apiProvider.QueryWithParams(p2pQueries.fetchHighestPrice, params);
    return HighestPriceModel.fromJson(response);
  }

  Future<P2PPaymentMethodsModel> fetchPaymentMethods() async {
    final response =
        await apiProvider.QueryWithoutParams(p2pQueries.fetchPaymentMethods);
    return P2PPaymentMethodsModel.fromJson(response);
  }

  Future<UserPaymentDetailsModel> fetchUserPaymentDetails(params) async {
    final response = await apiProvider.QueryWithParams(
        p2pQueries.fetchUserPaymentDetails, params);
    return UserPaymentDetailsModel.fromJson(response);
  }

  Future<FetchAppealHistory> fetchAppealHistory(params) async {
    final response = await apiProvider.QueryWithParams(
        p2pQueries.fetchAppealHistory, params);
    return FetchAppealHistory.fromJson(response);
  }

  Future<UserActivityModel> fetchUserActivity() async {
    final response =
        await apiProvider.QueryWithoutParams(p2pQueries.fetchUserActivity);
    return UserActivityModel.fromJson(response);
  }

  Future<P2PAdvertisementModel> fetchAdvertisement(params) async {
    final response = await apiProvider.QueryWithParams(
        p2pQueries.fetchAdvertisement, params);
    return P2PAdvertisementModel.fromJson(response);
  }

  Future<P2PAdvertisementModel> fetchUserAdvertisement(params) async {
    final response = await apiProvider.QueryWithParams(
        p2pQueries.fetchUserAdvertisement, params);
    return P2PAdvertisementModel.fromJson(response);
  }

  Future<FeedbackModel> fetchFeedback(params) async {
    final response =
        await apiProvider.QueryWithParams(p2pQueries.fetchFeedback, params);
    return FeedbackModel.fromJson(response);
  }

  Future<OrderCreationModel> fetchOrderCreation(params) async {
    final response = await apiProvider.MutationWithParams(
        p2pQueries.fetchOrderCreation, params);
    return OrderCreationModel.fromJson(response);
  }

  Future<CommonModel> addFeedback(params) async {
    final response =
        await apiProvider.MutationWithParams(p2pQueries.addFeedback, params);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> editFeedback(params) async {
    final response =
        await apiProvider.MutationWithParams(p2pQueries.editFeedback, params);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> createAdvertisement(params) async {
    final response = await apiProvider.MutationWithParams(
        p2pQueries.createAdvertisement, params);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> closeAdvertisement(params) async {
    final response = await apiProvider.MutationWithParams(
        p2pQueries.closeAdvertisement, params);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> editAdvertisement(params) async {
    final response = await apiProvider.MutationWithParams(
        p2pQueries.editAdvertisement, params);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> addUserPaymentMethod(params) async {
    final response = await apiProvider.MutationWithParams(
        p2pQueries.addUserPaymentMethod, params);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> editAdTradeStatus(params) async {
    final response = await apiProvider.MutationWithParams(
        p2pQueries.editAdTradeStatus, params);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> updateUserPaymentMethod(params) async {
    final response = await apiProvider.MutationWithParams(
        p2pQueries.updateUserPaymentMethod, params);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> deleteUserPaymentMethod(params) async {
    final response = await apiProvider.MutationWithParams(
        p2pQueries.deleteUserPaymentMethod, params);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> editUserName(params) async {
    final response =
        await apiProvider.MutationWithParams(p2pQueries.editUserName, params);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> createMessage(params) async {
    final response =
        await apiProvider.MutationWithParams(p2pQueries.createMessage, params);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> cancelP2POrder(params) async {
    final response =
        await apiProvider.MutationWithParams(p2pQueries.cancelP2POrder, params);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> appealConsensus(params) async {
    final response = await apiProvider.MutationWithParams(
        p2pQueries.appealConsensus, params);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> ReleaseCrypto(params) async {
    final response =
        await apiProvider.MutationWithParams(p2pQueries.releaseCrypto, params);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> fiatTransferred(params) async {
    final response = await apiProvider.MutationWithParams(
        p2pQueries.fiatTransferred, params);
    return CommonModel.fromJson(response);
  }

  Future<MessageHistoryModel> fetchMessageHistory(params) async {
    final response = await apiProvider.QueryWithParams(
        p2pQueries.fetchMessageHistory, params);
    return MessageHistoryModel.fromJson(response);
  }

  Future<UserCenterModel> findUserCenter(params) async {
    final response =
        await apiProvider.QueryWithParams(p2pQueries.findUserCenter, params);
    return UserCenterModel.fromJson(response);
  }

  Future<UserOrdersModel> fetchUserOrders(params) async {
    final response =
        await apiProvider.QueryWithParams(p2pQueries.fetchUserOrders, params);
    return UserOrdersModel.fromJson(response);
  }

  Future<P2PAdvertisementModel> fetchUserAdvertisements(params) async {
    final response = await apiProvider.QueryWithParams(
        p2pQueries.userAdvertisementPaymentDetails, params);
    return P2PAdvertisementModel.fromJson(response);
  }

  Future<FeedbackDataModel> fetchFeedbackData(params) async {
    final response =
        await apiProvider.QueryWithParams(p2pQueries.fetchFeedbackData, params);
    return FeedbackDataModel.fromJson(response);
  }

  Future<CommonModel> reportUser(params) async {
    final response =
        await apiProvider.MutationWithParams(p2pQueries.reportUser, params);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> appealCreate(params) async {
    final response =
        await apiProvider.MutationWithParams(p2pQueries.appealCreation, params);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> cancelAppeal(params) async {
    final response =
        await apiProvider.MutationWithParams(p2pQueries.cancelAppeal, params);
    return CommonModel.fromJson(response);
  }

//p2p ends

// margin trading starts
  Future<AllOpenOrderHistoryModel> allOpenOrderHistory(params) async {
    final response = await apiProvider.QueryWithParams(
        marginTradingQueries.allOpenOrderHistory, params);
    return AllOpenOrderHistoryModel.fromJson(response);
  }

  Future<GetUserFundingWalletDetailsClass>
      fetchUserFundingWalletDetails() async {
    final response = await apiProvider.QueryWithoutParams(
        marginTradingQueries.getUserFundingWalletDetails);
    return GetUserFundingWalletDetailsClass.fromJson(response);
  }

  Future<CommonModel> fetchTransferWalletFund(
      Map<String, dynamic> mutateUserParams) async {
    final response = await apiProvider.MutationWithParams(
        CommonMutations().transferWalletFunds, mutateUserParams);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> userFundingWalletTransfer(
      Map<String, dynamic> mutateUserParams) async {
    final response = await apiProvider.MutationWithParams(
        CommonMutations().userFundingWalletTransfer, mutateUserParams);
    return CommonModel.fromJson(response);
  }

  Future<GetUserFundingWalletTransferDetailsClass>
      fetchTransferHistoryForFunding(
          Map<String, dynamic> mutateUserParams) async {
    final response = await apiProvider.QueryWithParams(
        marginTradingQueries.getUserFundingWalletTransferHistory,
        mutateUserParams);
    return GetUserFundingWalletTransferDetailsClass.fromJson(response);
  }

  Future<CommonModel> createMarginOrder(Map<String, dynamic> params) async {
    final response = await apiProvider.MutationWithParams(
        commonMutations.createMarginOrder, params);
    return CommonModel.fromJson(response);
  }

// margin trading ends

  Future<SocialMediaModel> socialMediaLogin(
      Map<String, dynamic> mutateUserParams) async {
    final response = await apiProvider.MutationWithParams(
        commonMutations.socialMediaLogin, mutateUserParams);
    return SocialMediaModel.fromJson(response);
  }

  Future<SendEmailCodeModel> sendEmailCode() async {
    final response =
        await apiProvider.MutationWithoutParams(commonMutations.sendEmailCode);
    return SendEmailCodeModel.fromJson(response);
  }

  Future<CommonModel> verifyEmailCode(
      Map<String, dynamic> mutateUserParams) async {
    final response = await apiProvider.MutationWithParams(
        commonMutations.verifyEmailCode, mutateUserParams);
    return CommonModel.fromJson(response);
  }

  Future<CommonModel> updateFavTradePair(
      Map<String, dynamic> mutateUserParams) async {
    final response = await apiProvider.MutationWithParams(
        commonMutations.updateFavTradePair, mutateUserParams);
    return CommonModel.fromJson(response);
  }

  Future<FavPairModel> getUserFavTradePair() async {
    final response =
        await apiProvider.QueryWithoutParams(marketQueries.getUserFavTradePair);
    return FavPairModel.fromJson(response);
  }

  /// funding wallet starts
  Future<CommonModel> updateUserDefaultWallet(
      Map<String, dynamic> mutateUserParams) async {
    final response = await apiProvider.MutationWithParams(
        commonMutations.updateUserDefaultWallet, mutateUserParams);
    return CommonModel.fromJson(response);
  }

  /// funding wallet ends

  /// Future starts

  Future<CommonModel> updateFavSymbol(
      Map<String, dynamic> mutateUserParams) async {
    final response = await apiProvider.QueryWithParams(
        futureQueries.updateFutureFavSymbol, mutateUserParams);
    return CommonModel.fromJson(response);
  }

  ///  Future ends

  /// One Step Withdraw starts
}
