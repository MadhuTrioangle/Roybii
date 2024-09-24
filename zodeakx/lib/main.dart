import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeakx_mobile/Common/BankDetails/ViewModel/BankDetailsViewModel.dart';
import 'package:zodeakx_mobile/Common/BankDetailsHistory/ViewModel/BankDetailHistoryViewModel.dart';
import 'package:zodeakx_mobile/Common/Common/ViewModel/common_view_model.dart';
import 'package:zodeakx_mobile/Common/ConfirmPassword/ViewModel/ConfirmPasswordViewModel.dart';
import 'package:zodeakx_mobile/Common/Disable%20Google%20Authenticator/ViewModel/DiasbleGoogleAuthenticatorViewModel.dart';
import 'package:zodeakx_mobile/Common/ForgotPasswordScreen/ViewModel/ForgotPasswordViewModel.dart';
import 'package:zodeakx_mobile/Common/IdentityVerification/ViewModel/IdentityVerificationCommonViewModel.dart';
import 'package:zodeakx_mobile/Common/LoginPasswordChange/ViewModel/LoginPasswordChangeViewModel.dart';
import 'package:zodeakx_mobile/Common/LoginScreen/ViewModel/LoginViewModel.dart';
import 'package:zodeakx_mobile/Common/ReactiveAccount/ViewModel/ReactivateAccountViewModel.dart';
import 'package:zodeakx_mobile/Common/RegisterScreen/ViewModel/RegisterViewModel.dart';
import 'package:zodeakx_mobile/Common/RegisterScreen/Views/RegisterView.dart';
import 'package:zodeakx_mobile/Common/SplashScreen/View/SplashView.dart';
import 'package:zodeakx_mobile/Common/VerifyGoogleAuthCode/ViewModel/VerifyGoogleAuthenticateViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/AppTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/NativeChannelListener.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/getDevicedetails.dart';
import 'package:zodeakx_mobile/ZodeakX/AntiPhishingCode/ViewModel/AntiPhishingViewModel.dart';
import 'package:zodeakx_mobile/ZodeakX/AntiPhishingCode/ViewModel/GetUserByJwtViewModel.dart';
import 'package:zodeakx_mobile/ZodeakX/CurrencyPreferenceScreen/ViewModel/CurrencyPreferenceViewModel.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import 'package:zodeakx_mobile/ZodeakX/Setting/ViewModel/GetActivityViewModel.dart';
import 'package:zodeakx_mobile/p2p/ads/view_model/p2p_ads_view_model.dart';
import 'package:zodeakx_mobile/p2p/common_view/view_model/p2p_common_view_model.dart';
import 'package:zodeakx_mobile/p2p/counter_parties_profile/view_model/p2p_counter_profile_view_model.dart';
import 'package:zodeakx_mobile/p2p/home/view_model/p2p_home_view_model.dart';
import 'package:zodeakx_mobile/p2p/order_creation_view/ViewModel/p2p_order_creation_view_model.dart';
import 'package:zodeakx_mobile/p2p/orders/view_model/p2p_order_view_model.dart';
import 'package:zodeakx_mobile/p2p/payment_methods/view_model/p2p_payment_methods_view_model.dart';
import 'package:zodeakx_mobile/p2p/profile/view_model/p2p_profile_view_model.dart';
import 'package:zodeakx_mobile/staking/balance/view_model/staking_balance_view_model.dart';
import 'package:zodeakx_mobile/staking/home_page/viewModel/home_page_view_model.dart';
import 'package:zodeakx_mobile/staking/search_coins/viewModel/search_coins_view_model.dart';
import 'package:zodeakx_mobile/staking/stacking_creation/viewModel/stacking_creation_view_model.dart';
import 'package:zodeakx_mobile/staking/staking_history/view_model/staking_order_history_view_model.dart';
import 'package:zodeakx_mobile/staking/staking_redemption/viewModel/staking_redemption_view_model.dart';
import 'package:zodeakx_mobile/staking/staking_transaction/view_model/staking_transaction_view_model.dart';

import 'Common/EmailVerificationScreen/ViewModel/EmailVerificationViewModel.dart';
import 'Common/Exchange/ViewModel/ExchangeViewModel.dart';
import 'Common/GoogleAuthentication/ViewModel/GoogleAuthenticateCommonViewModel.dart';
import 'Common/OrderBook/ViewModel/OrderBookViewModel.dart';
import 'Common/Orders/ViewModel/OrdersViewModel.dart';
import 'Common/SplashScreen/ViewModel/SplashViewModel.dart';
import 'Common/TradeView/ViewModel/TradeViewModel.dart';
import 'Common/Transfer/ViewModel/TransferViewModel.dart';
import 'Common/Wallets/CoinDetailsViewModel/CoinDetailsViewModel.dart';
import 'Common/Wallets/CoinDetailsViewModel/GetcurrencyViewModel.dart';
import 'Common/Wallets/CommonWithdraw/ViewModel/CommonWithdrawViewModel.dart';
import 'Common/Wallets/ViewModel/WalletViewModel.dart';
import 'Common/wallet_select/viewModel/wallet_select_view_model.dart';
import 'ZodeakX/DashBoardScreen/ViewModel/DashBoardViewModel.dart';
import 'ZodeakX/FiatDepositScreen/ViewModel/FiatDepositViewModel.dart';
import 'ZodeakX/ReferralScreen/ViewModel/ReferralViewModel.dart';
import 'ZodeakX/Security/ViewModel/SecurityViewModel.dart';
import 'funding_wallet/funding_coin_details/view_model/funding_coin_details_view_model.dart';
import 'funding_wallet/funding_history/view_model/funding_history_view_model.dart';
import 'funding_wallet/wallet_details/view_model/funding_wallet_view_model.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  constant.pref = await SharedPreferences.getInstance();
  bool userSelected = constant.pref?.getBool('userSelectedTheme') ?? false;
  checkBrightness.value = userSelected ? Brightness.dark : Brightness.light;
   FlutterNativeCodeListenerMethodChannel.instance.configureChannel();
   
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarBrightness: checkBrightness.value == Brightness.dark
              ? Brightness.light
              : Brightness.dark) // Or Brightness.dark
      );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with WidgetsBindingObserver, ChangeNotifier {
  bool userSelected = true;
  bool lightToggle = true;
  bool appPaused = false;

  @override
  void initState() {
    super.initState();
    initialization();
    defaultIntilizers();
    GetDeviceDetails().getDeviceDetails();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Listen for when the app enter in background or foreground state.
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // user returned to our app, we push an event to the stream
      if (appPaused) _resumed();
    } else if (state == AppLifecycleState.inactive) {
      // app is inactive
      _inactive();
    } else if (state == AppLifecycleState.paused) {
      // user is about quit our app temporally
      _paused();
    } else if (state == AppLifecycleState.detached) {
      // detached from any host views
    }
  }

  Future _paused() async {
    appPaused = true;
    MarketViewModel marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.ws?.close();
    marketViewModel.webSocket?.clearListeners();
  }

  Future _inactive() async {}

  Future _resumed() async {
    appPaused = false;
    MarketViewModel marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    if (!constant.binanceStatus.value) return;
    if (marketViewModel.viewModel is MarketViewModel) {
      marketViewModel.viewModel.getMarketSocket();
    } else if (marketViewModel.viewModel is TradeViewModel) {
      marketViewModel.viewModel.getTradeSocket();
    } else if (marketViewModel.viewModel is OrderBookViewModel) {
      marketViewModel.viewModel.getOrderBookSocket();
    } else if (marketViewModel.viewModel is ExchangeViewModel) {
      marketViewModel.viewModel.getExchangeSocket();
    }
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

// Getting default Themes
  void defaultIntilizers() async {
    constant.pref = await SharedPreferences.getInstance();
    userSelected = constant.pref?.getBool('userSelectedTheme') ?? false;
    setState(() {
      checkBrightness.value = userSelected ? Brightness.dark : Brightness.light;
      checkBrightness.notifyListeners();
    });
  }

  /// User Toggle
  void toggleDarkMode() {
    defaultIntilizers();
  }

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: getAllProviers(),
        child: MaterialApp(
            theme: ThemeData(
              textSelectionTheme: TextSelectionThemeData(
                selectionHandleColor: Colors.transparent,
                //selectionHandleColor: themeColor,
              ),
            ),
            routes: appRoutes(),
            navigatorKey: NavigationService.navigatorKey!,
            debugShowCheckedModeBanner: false,
            // theme:  lightToggle ? AppThemes.lightTheme:AppThemes.darkTheme,
            darkTheme: lightToggle ? AppThemes.darkTheme : AppThemes.lightTheme,
            themeMode: (constant.pref?.getBool('userSelectedTheme') ?? false)
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const SplashView()));
  }

  Map<String, Widget Function(BuildContext)> appRoutes() {
    return {
      'register': (context) => RegisterView(),
    };
  }

  getAllProviers() {
    return [
      ChangeNotifierProvider(create: (_) => MarketViewModel()),
      ChangeNotifierProvider(create: (_) => CommonViewModel()),
      ChangeNotifierProvider(create: (_) => RegisterViewModel()),
      ChangeNotifierProvider(create: (_) => EmailVerificationViewModel()),
      ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
      ChangeNotifierProvider(create: (_) => ConfirmPasswordViewModel()),
      ChangeNotifierProvider(create: (_) => CurrencyPreferenceViewModel()),
      ChangeNotifierProvider(create: (_) => GetActivityViewModel()),
      ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ChangeNotifierProvider(create: (_) => DashBoardViewModel()),
      ChangeNotifierProvider(create: (_) => ReferralViewModel()),
      ChangeNotifierProvider(create: (_) => ReactivateAccountViewModel()),
      ChangeNotifierProvider(create: (_) => LoginPasswordChangeViewModel()),
      ChangeNotifierProvider(
          create: (_) => GoogleAuthenticateCommonViewModel()),
      ChangeNotifierProvider(
          create: (_) => DisableGoogleAuthenticatorChangeViewModel()),
      ChangeNotifierProvider(
          create: (_) => VerifyGoogleAuthenticationViewModel()),
      ChangeNotifierProvider(create: (_) => AntiPhishingViewModel()),
      ChangeNotifierProvider(create: (_) => GetUserByJwtViewModel()),
      ChangeNotifierProvider(
          create: (_) => IdentityVerificationCommonViewModel()),
      ChangeNotifierProvider(create: (_) => AddBankDetailsViewModel()),
      ChangeNotifierProvider(create: (_) => GetBankdetailsHistoryViewModel()),
      ChangeNotifierProvider(create: (_) => CoinDetailsViewModel()),
      ChangeNotifierProvider(create: (_) => FiatDepositViewModel()),
      ChangeNotifierProvider(create: (_) => GetCurrencyViewModel()),
      ChangeNotifierProvider(create: (_) => SecurityViewModel()),
      ChangeNotifierProvider(create: (_) => WalletViewModel()),
      ChangeNotifierProvider(create: (_) => SplashViewModel()),
      ChangeNotifierProvider(create: (_) => ExchangeViewModel()),
      ChangeNotifierProvider(create: (_) => OrderBookViewModel()),
      ChangeNotifierProvider(create: (_) => OrdersViewModel()),
      ChangeNotifierProvider(create: (_) => TradeViewModel()),
      ChangeNotifierProvider(create: (_) => CommonWithdrawViewModel()),
      //p2p starts
      ChangeNotifierProvider(create: (_) => P2PCommonViewModel()),
      ChangeNotifierProvider(create: (_) => P2PHomeViewModel()),
      ChangeNotifierProvider(create: (_) => P2POrderViewModel()),
      ChangeNotifierProvider(create: (_) => P2PAdsViewModel()),
      ChangeNotifierProvider(create: (_) => P2PProfileViewModel()),
      ChangeNotifierProvider(create: (_) => P2POrderCreationViewModel()),
      ChangeNotifierProvider(create: (_) => P2PPaymentMethodsViewModel()),
      ChangeNotifierProvider(create: (_) => P2PCounterProfileViewModel()),
      //p2p ends
      //staking starts
      ChangeNotifierProvider(create: (_) => StackingHomePageViewModel()),
      ChangeNotifierProvider(create: (_) => SearchCoinsViewModel()),
      ChangeNotifierProvider(create: (_) => WalletSelectViewModel()),
      ChangeNotifierProvider(create: (_) => TransferViewModel()),
      ChangeNotifierProvider(create: (_) => StackingCreationViewModel()),
      ChangeNotifierProvider(create: (_) => StakingBalanceViewModel()),
      ChangeNotifierProvider(create: (_) => StakingOrderHistoryViewModel()),
      ChangeNotifierProvider(create: (_) => StakingTransactionViewModel()),
      ChangeNotifierProvider(create: (_) => StakingRedemptionViewModel()),
      //staking ends
      // funding starts
      ChangeNotifierProvider(create: (_) => FundingHistoryViewModel()),
      ChangeNotifierProvider(create: (_) => FundingWalletViewModel()),
      ChangeNotifierProvider(create: (_) => FundingCoinDetailsViewModel()),

      // funding ends
    ];
  }
}
