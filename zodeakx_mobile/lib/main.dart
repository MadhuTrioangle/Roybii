import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
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
import 'package:zodeakx_mobile/Common/SecurityVerification/ViewModel/SecurityVerificationViewModel.dart';
import 'package:zodeakx_mobile/Common/SocialMediaScreen/ViewModel/SocialMediaViewModel.dart';
import 'package:zodeakx_mobile/Common/SplashScreen/View/SplashView.dart';
import 'package:zodeakx_mobile/Common/UpdatePhoneNumber/ViewModel/UpdatePhoneNumberViewModel.dart';
import 'package:zodeakx_mobile/Common/VerifyGoogleAuthCode/ViewModel/VerifyGoogleAuthenticateViewModel.dart';
import 'package:zodeakx_mobile/Common/Wallets/funding_coin_details/view_model/funding_coin_details_view_model.dart';
import 'package:zodeakx_mobile/Common/transfer/viewModel/transfer_view_model.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core'
    '/ColorHandler/AppTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/getDevicedetails.dart';
import 'package:zodeakx_mobile/ZodeakX/AntiPhishingCode/ViewModel/AntiPhishingViewModel.dart';
import 'package:zodeakx_mobile/ZodeakX/AntiPhishingCode/ViewModel/GetUserByJwtViewModel.dart';
import 'package:zodeakx_mobile/ZodeakX/CreateAccountScreen/ViewModel/CreateAccountScreenViewModel.dart';
import 'package:zodeakx_mobile/ZodeakX/CurrencyPreferenceScreen/ViewModel/CurrencyPreferenceViewModel.dart';
import 'package:zodeakx_mobile/ZodeakX/HomeScreen/ViewModel/HomeViewModel.dart';
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

import 'Common/CryptoDeposit/ViewModel/crypto_deposit_view_model.dart';
import 'Common/DeleteAccount/ViewModel/DeleteAccountViewModel.dart';
import 'Common/DeletePassword/ViewModel/DeletePasswordViewModel.dart';
import 'Common/EmailVerificationScreen/ViewModel/EmailVerificationViewModel.dart';
import 'Common/Exchange/ViewModel/ExchangeViewModel.dart';
import 'Common/GoogleAuthentication/ViewModel/GoogleAuthenticateCommonViewModel.dart';
import 'Common/OrderBook/ViewModel/OrderBookViewModel.dart';
import 'Common/Orders/ViewModel/OrdersViewModel.dart';
import 'Common/SiteMaintenance/ViewModel/SiteMaintenanceViewModel.dart';
import 'Common/SplashScreen/ViewModel/SplashViewModel.dart';
import 'Common/TradeView/ViewModel/TradeViewModel.dart';
import 'Common/Wallets/CoinDetailsViewModel/CoinDetailsViewModel.dart';
import 'Common/Wallets/CoinDetailsViewModel/GetcurrencyViewModel.dart';
import 'Common/Wallets/CommonWithdraw/ViewModel/CommonWithdrawViewModel.dart';
import 'Common/Wallets/ViewModel/WalletViewModel.dart';
import 'Common/wallet_select/viewModel/wallet_select_view_model.dart';
import 'Utils/Languages/English/StringVariables.dart';
import 'Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import 'ZodeakX/DashBoardScreen/ViewModel/DashBoardViewModel.dart';
import 'ZodeakX/FiatDepositScreen/ViewModel/FiatDepositViewModel.dart';
import 'ZodeakX/ReferralScreen/ViewModel/ReferralViewModel.dart';
import 'ZodeakX/Security/ViewModel/SecurityViewModel.dart';
import 'funding_wallet/funding_history/view_model/funding_history_view_model.dart';
import 'funding_wallet/wallet_details/view_model/funding_wallet_view_model.dart';

///test future v - 2
InAppLocalhostServer localhostServer = InAppLocalhostServer(port: 8082);

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  constant.pref = await SharedPreferences.getInstance();
  bool userSelected = constant.pref?.getBool('userSelectedTheme') ?? false;
  checkBrightness.value = userSelected ? Brightness.dark : Brightness.light;

  await localhostServer.start();
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
  bool toggled = false;

  @override
  void initState() {
    super.initState();
    defaultIntilizers();
    GetDeviceDetails().getDeviceDetails();
    WidgetsBinding.instance.addObserver(this);
    _handleIncomingLinks();
    _handleInitialUri();
  }

  Future<void> _handleInitialUri() async {
    try {
      final uri = await getInitialUri();
      if (!mounted) return;
      processWithdraw(uri);
    } on PlatformException {
    } on FormatException catch (err) {
      if (!mounted) return;
    }
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        processWithdraw(uri);
      }, onError: (Object err) {
        if (!mounted) return;
      });
    }
  }

  processWithdraw(Uri? uri) {
    bool login = constant.pref?.getBool("loginStatus") ?? false;
    if (!login && uri != null) {
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          stringVariables.mustLogin, SnackbarType.negative);
      return;
    }
    if (uri.toString().contains("id")) {
      String id = uri.toString().split("id").last.substring(1);
      CommonViewModel commonViewModel = Provider.of<CommonViewModel>(
          NavigationService.navigatorKey.currentContext!,
          listen: false);
      if (uri.toString().contains("fiat-withdraw")) {
        commonViewModel.getFiatWithdraw(
            id, NavigationService.navigatorKey.currentContext!);
      }
      if (uri.toString().contains("crypto-withdraw")) {
        commonViewModel.getCryptoWithdraw(
            id, NavigationService.navigatorKey.currentContext!);
      }
    }
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
      localhostServer.close();
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
    P2POrderCreationViewModel p2pordercreationvm =
        Provider.of<P2POrderCreationViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    marketViewModel.ws?.close();
    //p2pordercreationvm.offP2pSocket();
  }

  Future _inactive() async {}

  Future _resumed() async {
    appPaused = false;
    MarketViewModel marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    ExchangeViewModel exchangeViewModel = Provider.of<ExchangeViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    P2POrderCreationViewModel p2pordercreteion =
        Provider.of<P2POrderCreationViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    MarketViewModel marketVwModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    await localhostServer.start();

    //  if (!constant.okxStatus.value) return;
    if (marketViewModel.viewModel is MarketViewModel) {
      marketViewModel.getMarketSocket();
    } else if (marketViewModel.viewModel is TradeViewModel) {
      marketViewModel.getTradeSocket();
    } else if (marketViewModel.viewModel is OrderBookViewModel) {
      exchangeViewModel.getExchangeSocket();
    } else if (marketViewModel.viewModel is ExchangeViewModel) {
      exchangeViewModel.getExchangeSocket();
    } else if (marketViewModel.viewModel is P2POrderCreationViewModel) {
      p2pordercreteion.getP2pSocket();
    }
  }

// Getting default Theme s
  void defaultIntilizers() async {
    constant.pref = await SharedPreferences.getInstance();
    userSelected = constant.pref?.getBool('userSelectedTheme') ?? false;
    if (userSelected && !toggled) {
      Color temp = themeColor;
      themeColor = darkThemeColor;
      darkThemeColor = temp;
    }
    setState(() {
      checkBrightness.value = userSelected ? Brightness.dark : Brightness.light;
      checkBrightness.notifyListeners();
    });
  }

  /// User Toggle
  void toggleDarkMode() {
    Color temp = themeColor;
    themeColor = darkThemeColor;
    darkThemeColor = temp;
    toggled = true;
    defaultIntilizers();
  }

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: getAllProviers(),
        child: MaterialApp(
            navigatorObservers: [routeObserver],
            theme: ThemeData(
              textSelectionTheme: const TextSelectionThemeData(
                selectionHandleColor: Colors.transparent,
              ),
            ),
            routes: appRoutes(),
            navigatorKey: NavigationService.navigatorKey,
            debugShowCheckedModeBanner: false,
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
      /// spot starts
      ChangeNotifierProvider(create: (_) => SecurityVerificationViewModel()),
      ChangeNotifierProvider(create: (_) => SocialMediaViewModel()),
      ChangeNotifierProvider(create: (_) => MarketViewModel()),
      ChangeNotifierProvider(create: (_) => HomeViewModel()),
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
      ChangeNotifierProvider(create: (_) => CreateAccountViewModel()),

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
      ChangeNotifierProvider(create: (_) => CryptoDepositViewModel()),
      ChangeNotifierProvider(create: (_) => CommonWithdrawViewModel()),
      ChangeNotifierProvider(create: (_) => DeleteAccountViewModel()),
      ChangeNotifierProvider(create: (_) => DeletePasswordViewModel()),
      ChangeNotifierProvider(create: (_) => SiteMaintenanceViewModel()),
      ChangeNotifierProvider(create: (_) => UpdatePhoneNumberViewModel()),
      ChangeNotifierProvider(create: (_) => TransferViewModel()),
      ChangeNotifierProvider(create: (_) => WalletSelectViewModel()),

      /// spot ends

      ///p2p starts
      ChangeNotifierProvider(create: (_) => P2PCommonViewModel()),
      ChangeNotifierProvider(create: (_) => P2PHomeViewModel()),
      ChangeNotifierProvider(create: (_) => P2POrderViewModel()),
      ChangeNotifierProvider(create: (_) => P2PAdsViewModel()),
      ChangeNotifierProvider(create: (_) => P2PProfileViewModel()),
      ChangeNotifierProvider(create: (_) => P2POrderCreationViewModel()),
      ChangeNotifierProvider(create: (_) => P2PPaymentMethodsViewModel()),
      ChangeNotifierProvider(create: (_) => P2PCounterProfileViewModel()),

      ///p2p ends

      /// funding starts
      ChangeNotifierProvider(create: (_) => FundingHistoryViewModel()),
      ChangeNotifierProvider(create: (_) => FundingWalletViewModel()),
      ChangeNotifierProvider(create: (_) => FundingCoinDetailsViewModel()),

      ///funding ends
    ];
  }
}
