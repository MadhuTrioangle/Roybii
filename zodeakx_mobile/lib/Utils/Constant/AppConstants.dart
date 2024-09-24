import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/DeviceDetailsModel/DeviceDetails.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';

class AppConstants with ChangeNotifier {
  /// Variable Declaration
  /// WebConstants

  String baseUrl = "https://roybitsserver.zodeak-dev.com/graphql";
  //  "https://frontloops.zodeak-dev.com/graphql"; // demo backend url
  String demoUrl = "http://10.10.8.5:3000/graphql"; // Demo URL
  String baseSocketUrl = "https://frontsox.zodeak-dev.com"; // demo socket url
  String wssSocketOkxUrl =
      "wss://ws.okx.com:8443/ws/v5/public"; //  OKX Socket URL
  String wssSocketUrl =
      "wss://stream.binance.com:9443/stream?streams="; // Binance Socket URL
  String demoSocketUrl = "http://10.10.8.5:3335/"; // Demo Socket URL
  String secretCode = '0kYUuE4dzbi7tQxWHA2D7g=='; //pi secret
  String googleClientId =
      '952688507162-tf9jlm2ilbsn4t4ofk58c2pli9ua4c0j.apps.googleusercontent.com';
  String googleIosClientId =
      '952688507162-r1k46psccig27hb9v5b496vd3inhllfi.apps.googleusercontent.com';
  bool isLive = false;
  bool isdemo = false; // Need to run demo
  bool p2pStatus = true; // P2P Status
  bool fundingStatus = true; // funding status
  late String ambassadorReferalLink;
  late String viplink;
  late String encrytAndDecryptCode;
  late String privacy;
  late String termsAndConditions;
  late String appUrl;
  late String chartUrl;
  late String mlmTreeUrl;
  late String marginDataUrl;
  late String isolatedMarginTierDataUrl;
  var searchResultJson = "assets/json/countryJson.json";
  String appName = "Roybits";
  String appVersion = "1.0.0";
  late String appEmail;
  late String referralUrl;
  late String launchpadAnnuncement;
  late String launchpadFaq;
  ValueNotifier<String> userEmail = ValueNotifier("");
  Dio dio = Dio();
  String downloadUrl1 =
      "https://zodeak-dev.com/assets/img/11.png"; //"https://dev.Zodeak X.io/assets/img/11.png"
  String downloadUrl2 =
      "https://zodeak-dev.com/assets/img/11.png"; //"https://dev.Zodeak X.io/assets/img/11.png"
  String downloadUrl3 =
      "https://zodeak-dev.com/assets/img/11.png"; //"https://dev.Zodeak X.io/assets/img/11.png"
  String downloadUrl4 =
      "https://zodeak-dev.com/assets/img/11.png"; //"https://dev.Zodeak X.io/assets/img/11.png"

  AppConstants() {
    appEmail = 'roybits@gmail.com';
    userEmail = ValueNotifier(appEmail);
    appUrl =
        "https://zodeak-dev.com/"; //"https://dev.Zodeak X.io/""https://trade.Zodeak X.io/"
    privacy = '${appUrl}/#/privacy';
    termsAndConditions =
        "${appUrl}/#/footer-content-view?type=Terms_and_Conditions";
    chartUrl = "${appUrl}/#/basic-exchange/";
    referralUrl = "${appUrl}/#/register?id=";
    launchpadAnnuncement = "${appUrl}/#/launchpad/announcement/";
    launchpadFaq = "${appUrl}/#/launchpad/faq";
    ambassadorReferalLink = "${appUrl}/#/register?refid=";
    viplink = "${appUrl}/#/vip/fee";
    mlmTreeUrl = "${appUrl}/#/ambassador-program/ambassador-program-mobile-app";
    marginDataUrl = "${appUrl}margin/margin-fee";
    isolatedMarginTierDataUrl = "${appUrl}margin/margin-data";
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
    'TRY': "₺",
    'NGN': "₦",
    'INR': "₹",
    'MXN': "\$",
    'ARS': "\$",
    'COP': "\$",
    'BRL': "R\$",
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
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNjUwMzBhOTc2MzhlYWZhZDk3OGEyNjczIiwiZGQiOnsiaXAiOiIxMzkuMTY3LjU2LjEzNCIsImxvY2F0aW9uIjoiQ29pbWJhdG9yZSwgSW5kaWEiLCJkZXZpY2UiOiJkZXNrdG9wIiwic291cmNlIjoid2ViIiwib3MiOiJPUyBYIiwiYnJvd3NlciI6IkNocm9tZSIsInBsYXRmb3JtIjoiQXBwbGUgTWFjIn0sImlhdCI6MTcxOTIyMTQ0NSwiZXhwIjoxNzE5MjIzMjQ1fQ.zyprS8fBQuoCyOYMwqSGb0d01gubG25-evHHPA5S7sg'); // User Token
  ValueNotifier<bool> userLoginStatus = ValueNotifier(false);
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
  ValueNotifier<String> selectCurrency = ValueNotifier("USD");
  ValueNotifier<String> spotDefaultPair = ValueNotifier("BTC/USDT");
  ValueNotifier<String> marginDefaultPair = ValueNotifier("ETH/USDT");
  ValueNotifier<String> futureUsdsDefaultPair = ValueNotifier("BTCUSDT");
  ValueNotifier<String> futureCoinDefaultPair = ValueNotifier("ETHUSD");
  ValueNotifier<String> googleAuthentciate = ValueNotifier("123456");
  ValueNotifier<String> token =
      ValueNotifier('JQeTbnrGYrf4Vt2qBxj79P'); // User Token
  ValueNotifier<String> location = ValueNotifier('');
  ValueNotifier<String> reactivateMessage = ValueNotifier(
      'Your Account Activated Successfully. Please Login to Continue');
  ValueNotifier<ScreenType> previousScreen = ValueNotifier(ScreenType.Login);
  ValueNotifier<String> contactMail =
      ValueNotifier('sales@cryptocurrencyscript.com');
  ValueNotifier<bool> binanceStatus = ValueNotifier(false);
  ValueNotifier<bool> okxStatus = ValueNotifier(false);
  ValueNotifier<bool> siteMaintenanceStatus = ValueNotifier(false);
  ValueNotifier<dynamic> siteMaintenanceStartDate = ValueNotifier(null);
  ValueNotifier<dynamic> siteMaintenanceEndDate = ValueNotifier(null);
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

AppConstants constant = AppConstants();

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

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
