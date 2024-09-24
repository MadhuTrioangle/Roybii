import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../Constant/AppConstants.dart';

extension StringValidatorFunction on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isValidPassword() {
    return RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W).{8,}$")
        .hasMatch(this);
  }

  bool isValidSpecialCharacter() {
    return RegExp(r"^[a-z0-9,A-Z]+$").hasMatch(this);
  }

  bool isValidCharacter() {
    return RegExp(r'[a-zA-Z]').hasMatch(this);
  }

  bool isValidDate() {
    return RegExp(
            r'^(0[1-9]|1[012])[-/.](0[1-9]|[12][0-9]|3[01])[-/.](19|20)\\d\\d$')
        .hasMatch(this);
  }

  bool isValidDigits() {
    return RegExp(r'[0-9]').hasMatch(this);
  }
}

String capitalize(String value) {
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}

/// StringFixed
String isDigit(String input) {
  if (input.contains('-')) {
    var d = double.parse(input);
    return (d < 0) ? d.toStringAsFixed(2) : d.toStringAsFixed(6);
  } else {
    var d = double.parse(input.replaceAll("-", ""));
    return (d > 1) ? d.toStringAsFixed(2) : d.toStringAsFixed(6);
  }
}

String trimAs2(String input) {
  var d = double.parse(input);
  return d.toStringAsFixed(2);
}

String trimAsLength(String input, int length) {
  var d = double.parse(input);
  return d.toStringAsFixed(length);
}

/// trim decimals
String trimDecimals(String input) {
  var d = double.parse(input);
  return (d >= 1)
      ? removeTrailingZeros(d.toStringAsFixed(2))
      : (d == 0)
          ? d.toStringAsFixed(2)
          : (d.toString().contains("e"))
              ? removeTrailingZeros(d.toStringAsFixed(8))
              : removeTrailingZeros(d.toStringAsFixed(8));
}

removeTrailingZeros(String n) {
  return n.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
}

trimDecimalsForVolume(String input) {
  var val = num.parse(input);
  if (val < 1000000) {
    return trimDecimals(input.toString());
  } else if (val > 1000000 && val < 1000000000) {
    return "${(val / 1000000).toStringAsFixed(2)}M";
  } else if (val > 1000000000) {
    return "${(val / 1000000000).toStringAsFixed(2)}B";
  } else {
    return trimDecimals(val.toString());
  }
}

/// trim decimals
String trimDecimalsForBalance(String input) {
  var d = double.parse(input);
  bool afterDigit = false;

  if (input.contains(".")) {
    if (double.parse(input.split(".").last) > 0)
      afterDigit = true;
    else
      afterDigit = false;
  } else {
    afterDigit = false;
  }
  return (d >= 1)
      ? afterDigit
          ? removeTrailingZeros(d.toStringAsFixed(afterDigit ? 8 : 2))
          : d.toStringAsFixed(2)
      : (d == 0)
          ? d.toStringAsFixed(2)
          : (d.toString().contains("e"))
              ? removeTrailingZeros(d.toStringAsFixed(9))
              : removeTrailingZeros(d.toStringAsFixed(8));
}

///Date Format
String getDateFromTimeStamp(String timeStamp, [bool utc = true]) {
  DateTime parseDate =
      new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(timeStamp, utc);
  var dateLocal = parseDate.toLocal();
  var inputDate = DateTime.parse(dateLocal.toString());

  var outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String getDateTimeStamp(String timeStamp, [bool utc = true]) {
  DateTime parseDate =
      new DateFormat("yyyy-MM-dd hh:mm:ss").parse(timeStamp, utc);
  var dateLocal = parseDate.toLocal();
  var inputDate = DateTime.parse(dateLocal.toString());
  var outputFormat = DateFormat('yyyy-MM-dd');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String getDate(String timeStamp, [bool utc = false]) {
  DateTime parseDate =
      new DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").parse(timeStamp, utc);
  var dateLocal = parseDate.toLocal();
  var inputDate = DateTime.parse(dateLocal.toString());
  var outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String getDateForOrders(DateTime time) {
  var date = DateFormat('yyyy-MM-dd HH:mm:ss').format(time);
  return date;
}

String getDateForTrade(String time) {
  DateTime parseDate =
      new DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").parse(time, false);
  var dateLocal = parseDate.toLocal();
  var inputDate = DateTime.parse(dateLocal.toString());
  var outputFormat = DateFormat('hh:mm:ss');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String getNowDateForTrade(String time) {
  DateTime parseDate =
      new DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(time, true);
  var dateLocal = parseDate.toLocal();
  var inputDate = DateTime.parse(dateLocal.toString());
  var outputFormat = DateFormat('hh:mm:ss');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String getDateWithoutSeconds(String timeStamp) {
  DateTime parseDate =
      new DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").parse(timeStamp, true);
  var dateLocal = parseDate.toLocal();
  var inputDate = DateTime.parse(dateLocal.toString());
  var outputFormat = DateFormat('yyyy-MM-dd hh:mm');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String getDateTime(String timeStamp) {
  DateTime parseDate =
      new DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").parse(timeStamp, true);
  var dateLocal = parseDate.toLocal();
  var inputDate = DateTime.parse(dateLocal.toString());
  var outputFormat = DateFormat('MM-dd hh:mm:ss');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String convertToIST(String timeStamp) {
  var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss.SSSZ").parse(timeStamp, true);
  var dateLocal = dateTime.toLocal();
  var inputDate = DateTime.parse(dateLocal.toString());
  var outputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String convertToISTWithoutSeconds(String timeStamp) {
  var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss.SSSZ").parse(timeStamp);
  var dateLocal = dateTime.toLocal();
  var inputDate = DateTime.parse(dateLocal.toString());
  var outputFormat = DateFormat('yyyy-MM-dd hh:mm');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String getTimeForstake(String timeStamp) {
  var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss.SSSZ").parse(timeStamp, true);
  //var dateLocal = dateTime.toLocal();
  var inputDate = DateTime.parse(timeStamp);
  var outputFormat = DateFormat('yyyy-MM-dd hh:mm');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String getTimeForChart(String timeStamp) {
  var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss.SSSZ").parse(timeStamp, true);
  //var dateLocal = dateTime.toLocal();
  var inputDate = DateTime.parse(timeStamp);
  var outputFormat = DateFormat('MM-dd');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

check_two_times_is_before(String start_time, String end_time) {
  var format = DateFormat("HH:mm");
  var start = format.parse(start_time);
  var end = format.parse(end_time);

  end = end.add(Duration(days: 1));
  Duration diff = end.difference(start);
  final hours = diff.inHours;
  final minutes = diff.inMinutes % 60;
}

Duration durationToString(String value, int days) {
  var date = new DateTime.now();
  DateTime tomorrow = DateTime(date.year, date.month, date.day + days, 0, 0, 0);
  Duration timeLeft = tomorrow.difference(DateTime.now());
  List<String> parts = value.toString().split(':');
  List<String> tomorrowParts = timeLeft.toString().split(':');
  int hours = int.parse(parts[0].padLeft(2, '0')) * 60 +
      int.parse(tomorrowParts[0].padLeft(2, '0')) * 60;
  int mins = int.parse(parts[1].padLeft(2, '0')) +
      int.parse(tomorrowParts[1].padLeft(2, '0'));
  int secs = 1;
  int minutes = hours + mins + secs;
  var d = Duration(minutes: minutes);
  return d;
}

double get _ppi => (Platform.isAndroid || Platform.isIOS) ? 150 : 96;

Size size(BuildContext c) => MediaQuery.of(c).size;///retrieve the size of current page

Size inches(BuildContext c) {
  Size pxSize = size(c);
  return Size(pxSize.width / _ppi, pxSize.height / _ppi);
}

double heightInches(BuildContext c) => inches(c).height;

bool isSmallScreen(context) => heightInches(context) < 5;///5 ah vida less ah iruntha true

String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}

validator(GlobalKey<FormFieldState> fieldKey, FocusNode focusNode) {
  focusNode.addListener(() {
    if (!focusNode.hasFocus) {
      fieldKey.currentState!.validate();
    }
  });
}

String getImage(MarketViewModel marketViewModel,
    WalletViewModel walletViewModel, String crypto) {
  List<dynamic> list = [];
  list = constant.userLoginStatus.value
      ? (walletViewModel.viewModelDashBoardBalance != null)
          ? (walletViewModel.viewModelDashBoardBalance!.isNotEmpty)
              ? walletViewModel.viewModelDashBoardBalance!
                  .where((element) => element.currencyCode == crypto)
                  .toList()
              : []
          : []
      : (marketViewModel.getCurrencies != null)
          ? (marketViewModel.getCurrencies!.isNotEmpty)
              ? marketViewModel.getCurrencies!
                  .where((element) => element.currencyCode == crypto)
                  .toList()
              : []
          : [];
  return (list == null || list.isEmpty) ? "" : list.first.image;
}

bool hasValidUrl(String value) {

  String pattern =
      r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return false;
  } else if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}

Color randomColor() {
  return Color(Random().nextInt(0xffffffff)).withAlpha(0xff);
}
