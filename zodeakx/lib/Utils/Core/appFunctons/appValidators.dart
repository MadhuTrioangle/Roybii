import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
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
      ? d.toStringAsFixed(2)
      : (d == 0)
          ? d.toStringAsFixed(2)
          : (d.toString().contains("e"))
              ? removeTrailingZeros(d.toStringAsFixed(8))
              : d.toStringAsFixed(8);
}

removeTrailingZeros(String n) {
  return n.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
}

///Date Format
String getDateFromTimeStamp(String timeStamp) {
  DateTime parseDate =
      new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(timeStamp);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String getDateTimeStamp(String timeStamp) {
  DateTime parseDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(timeStamp);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('yyyy-MM-dd');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String getDate(String timeStamp) {
  DateTime parseDate =
      new DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").parse(timeStamp);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String getDateWithoutSeconds(String timeStamp) {
  DateTime parseDate =
      new DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").parse(timeStamp);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('yyyy-MM-dd hh:mm');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String getDateTime(String timeStamp) {
  DateTime parseDate =
      new DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").parse(timeStamp);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('MM-dd hh:mm:ss');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String convertToIST(String timeStamp) {
  securedPrint("Date${DateTime.now().day}");
  var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss.SSSZ").parse(timeStamp, true);
  var dateLocal = dateTime.toLocal();
  var inputDate = DateTime.parse(dateLocal.toString());
  var outputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String getTimeForstake(String timeStamp) {
  securedPrint("Date${DateTime.now().day}");
  var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss.SSSZ").parse(timeStamp, true);
  // var dateLocal = dateTime.toLocal();
  var inputDate = DateTime.parse(dateTime.toString());
  var outputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

double get _ppi => (Platform.isAndroid || Platform.isIOS) ? 150 : 96;

Size size(BuildContext c) => MediaQuery.of(c).size;

Size inches(BuildContext c) {
  Size pxSize = size(c);
  return Size(pxSize.width / _ppi, pxSize.height / _ppi);
}

double heightInches(BuildContext c) => inches(c).height;

bool isSmallScreen(context) => heightInches(context) < 5;

String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
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
      ? removeTrailingZeros(d.toStringAsFixed(afterDigit ? 8 : 2))
      : (d == 0)
      ? d.toStringAsFixed(2)
      : (d.toString().contains("e"))
      ? removeTrailingZeros(d.toStringAsFixed(8))
      : removeTrailingZeros(d.toStringAsFixed(8));
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

String capitalize(String value) {
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}