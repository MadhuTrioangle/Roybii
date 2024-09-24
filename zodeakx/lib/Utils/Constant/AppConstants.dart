import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/DeviceDetailsModel/DeviceDetails.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';

class AppConstants with ChangeNotifier {
  /// Variable Declaration
  /// WebConstants
  String baseUrl =
    "https://frontloops.zodeak-dev.com/graphql"; // Demo URL
  //  "https://stagingfrontloops.zodeak-dev.com/graphql"; // Staging // Demo URL
  String demoUrl = "http://10.10.8.5:3000/graphql"; // Demo URL
  String baseSocketUrl =
    "https://frontsox.zodeak-dev.com/"; // Demo Socket URL
  // "wss://stagingfrontsox.zodeak-dev.com/socket.io"; // Staging Socket URL
  String wssSocketUrl = "wss://stream.binance.com:9443/stream?streams=";
  String demoSocketUrl = "http://10.10.8.5:3335/"; // Demo Socket URL
  String secretCode = '0kYUuE4dzbi7tQxWHA2D7g=='; // Api secret
  bool isdemo = false; // Need to run demo
  bool p2pStatus = true; // P2P Status
  bool stakingStatus = true; // Staking Status
  bool fundingStatus = true; // Funding Status
  late String encrytAndDecryptCode;
  String privacy = 'http://zodeakx.cryptocurrencyscript.com/#/privacy';
  late String appUrl;
  late String chartUrl;
  var searchResultJson = "assets/json/countryJson.json";
  String appName = "Zodeak X";
  String appVersion = "1.0.0";
  late String appEmail;
  late String referralUrl;
  late String launchpadAnnuncement;
  late String launchpadFaq;
  ValueNotifier<String> userEmail = ValueNotifier("");

  AppConstants() {
    appEmail = 'zodeak@gmail.com';
    userEmail = ValueNotifier(appEmail);
    appUrl = "http://zodeak-dev.com";
    chartUrl = "${appUrl}/#/basic-exchange/";
    referralUrl = "${appUrl}/#/register?id=";
    launchpadAnnuncement = "${appUrl}/#/launchpad/announcement/";
    launchpadFaq = "${appUrl}/#/launchpad/faq";
    setEncrytAndDecryptCode();
  }

  setEncrytAndDecryptCode() async {
    String encoded = await loadEncrytAndDecryptCode();
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    encrytAndDecryptCode = stringToBase64.decode(encoded);
  }

  Map<String, String> currencySymbol = {
    'USD': "\$",
    'GBP': "£",
    'EUR': "€",
    'NGN': "₦"
  };

  Map<String, Color> paymentCardColors = {
    'IMPS': Colors.purple,
    'UPI': Colors.indigo,
    'Paytm': Colors.cyan,
    'bank_transfer': Colors.brown,
    '': Colors.red
  };

  /// AppConstants
  SharedPreferences? pref; // Constant Local Presit data
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin(); // Get Device Details
  DeviceDetails? deviceDetails;
  ValueNotifier<String> userToken = ValueNotifier(
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNjIyZWVmOTAzZTc3ODUzZGMxZGUyYTZkIiwiZGQiOnsiaXAiOiIxMzYuMjMyLjIyMi4xMzAiLCJsb2NhdGlvbiI6IiwgSW5kaWEiLCJkZXZpY2UiOiJkZXNrdG9wIiwic291cmNlIjoid2ViIiwib3MiOiJMaW51eCA2NCIsImJyb3dzZXIiOiJDaHJvbWUiLCJwbGF0Zm9ybSI6IkxpbnV4In0sImlhdCI6MTY1MDUzNzQ0NiwiZXhwIjoxNjUwNTM5MjQ2fQ.JQeTbnrGYrf4Vt2qBxj79PbC7AZkRIGsg8sulZBtwpI'); // User Token
  ValueNotifier<bool> userLoginStatus = ValueNotifier(false);
  ValueNotifier<bool> binanceStatus = ValueNotifier(false);
  ValueNotifier<bool> p2pPop = ValueNotifier(false);
  ValueNotifier<String> tokenType = ValueNotifier('ForgetPassword');
  ValueNotifier<String> userCurrency = ValueNotifier("USD");
  ValueNotifier<String> cryptoCurrency = ValueNotifier("BTC");
  ValueNotifier<String> QRSecertCode =
      ValueNotifier("MQYFK6RFKRTEOZ3DGJKDSQK3");
  ValueNotifier<String> buttonValue = ValueNotifier("Enable");
  ValueNotifier<String> antiCodeStatus = ValueNotifier("Create");
  ValueNotifier<String> antiCode = ValueNotifier("1234");
  ValueNotifier<String> bankName = ValueNotifier("tmb");
  ValueNotifier<int> googleAuthIndex = ValueNotifier(0);
  ValueNotifier<String> walletCurrency = ValueNotifier("USD");
  ValueNotifier<String> googleAuthentciate = ValueNotifier("123456");
  ValueNotifier<String> token =
      ValueNotifier('JQeTbnrGYrf4Vt2qBxj79P'); // User Token
  ValueNotifier<String> location = ValueNotifier('');
  ValueNotifier<String> reactivateMessage = ValueNotifier(
      'Your Account Activated Successfully. Please Login to Continue');
  ValueNotifier<String> marketPair = ValueNotifier('ETH/BTC');
  ValueNotifier<ScreenType> previousScreen = ValueNotifier(ScreenType.Login);
  ValueNotifier<String> contactMail =
      ValueNotifier('sales@cryptocurrencyscript.com');

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

AppConstants constant = AppConstants();

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class ScaffoldService {
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<String> loadEncrytAndDecryptCode() async {
  String code = await loadAsset('assets/encrytAndDecryptCode.txt');
  if (code != null)
    return await code;
  else
    return "";
}

Future loadAsset(String path) async {
  try {
    return await rootBundle.loadString(path);
  } catch (_) {
    return null;
  }
}
