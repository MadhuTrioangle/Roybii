import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/BankDetails/Model/BankDetailsModel.dart';
import 'package:zodeakx_mobile/Common/BankDetailsHistory/Model/BankDetailHistoryModel.dart';
import 'package:zodeakx_mobile/Common/BankDetailsHistory/ViewModel/BankDetailHistoryViewModel.dart';
import 'package:zodeakx_mobile/Common/Repositories/CommonRepository.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/ZodeakX/Repositories/ProductRepositories.dart';

class AddBankDetailsViewModel extends ChangeNotifier {
  bool checkBoxStatus = false;
  bool checkBoxStatusNO = false;
  bool closedPage = false;
  bool noInternet = false;
  bool needToLoad = false;
  bool positiveStatus = false;
  bool showSnackbar = false;
  AddBankDetails? addBankDetailsUserResponse;
  GetBankdetailsHistoryViewModel? viewModel;
  List<GetBankHistoryDetails>? getBankDetailsHistory;
  bool hasInputError1 = false;
  bool hasInputError2 = false;
  bool hasInputError3 = false;
  bool hasInputError4 = false;
  bool hasInputError5 = false;
  FocusNode focusNode = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();

  AddBankDetailsViewModel() {
    showSnackbar = false;
    closedPage = false;
    checkFocus();
  }

  checkFocus() {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        hasInputError1 = (closedPage) ? false : !focusNode.hasFocus;
        notifyListeners(); //Check your conditions on text variable
      }
    });
    focusNode2.addListener(() {
      if (!focusNode2.hasFocus) {
        hasInputError2 = (closedPage)
            ? false
            : !focusNode2.hasFocus; //Check your conditions on text variable
        notifyListeners();
      }
    });
    focusNode3.addListener(() {
      if (!focusNode3.hasFocus) {
        hasInputError3 = (closedPage) ? false : !focusNode3.hasFocus;
        notifyListeners(); //Check your conditions on text variable
      }
    });
    focusNode4.addListener(() {
      if (!focusNode4.hasFocus) {
        hasInputError4 = (closedPage) ? false : !focusNode4.hasFocus;
        //Check your conditions on text variable
        notifyListeners();
      }
    });
    focusNode5.addListener(() {
      if (!focusNode5.hasFocus) {
        hasInputError5 = (closedPage) ? false : !focusNode5.hasFocus;
        notifyListeners(); //Check your conditions on text variable
      }
    });
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// Loader
  setCheckbox(bool checkBoxStatus) async {
    this.checkBoxStatus = checkBoxStatus;
    notifyListeners();
  }

  /// checkbox onChanged value yes using provider

  bool active = false;
  bool checkAlert = true;

  Future<void> setActive(bool value) async {
    active = value;
    checkAlert = active;
    notifyListeners(); //  Consumer to rebuild
  }

  /// checkbox onChanged value no using provider

  bool select = false;
  bool checkAlertBox = true;

  Future<void> setSelect(bool value) async {
    select = value;
    checkAlertBox = select;
    notifyListeners(); //  Consumer to rebuild
  }

  /// radiobutton onChanged value using provider
  int id = 2;

  Future<void> setActiveR(BuildContext context, int index) async {
    id = index;
    notifyListeners(); //  Consumer to rebuild
  }

  /// Create user response
  getBankDetails(context, AddBankDetails? createUserResponse) {
    addBankDetailsUserResponse = createUserResponse;

    getSnackBarstatus(context, createUserResponse);
  }

  getSnackBarstatus(context, AddBankDetails? createUserResponse) {
    positiveStatus =
        ((addBankDetailsUserResponse?.statusCode ?? 200) == 200) ? true : false;
    ((createUserResponse?.statusCode ?? 403) == 200)
        ? getBankDetailHistory()
        : () {};
    showSnackbar = true;
  }

  Future<bool> createUserBankDetails(
      String accNum,
      String userName,
      String bankName,
      String ibanNum,
      String bankAddress,
      bool primary,
      BuildContext context) async {
    setLoading(true);
    var popFlag = false;
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "label_key": {
          "account_number": accNum,
          "account_holder_name": userName,
          "bank_name": bankName,
          "iban_number": ibanNum,
          "bank_address": bankAddress,
        },
        "primary": primary
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await commonRepository.MutatecreateUserBankDetails(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          popFlag = false;
          setLoading(false);
          break;
        case 1:
          getBankDetails(context, decodeResponse.data);

          if (decodeResponse.data?.statusCode == 200) {
            popFlag = true;
            setCheckbox(false);
            setActiveR(context, 2);
          } else {
            popFlag = false;
          }
          popFlag == true ? () {} : () {};
          setLoading(false);
          break;
        default:
          popFlag = false;
          setLoading(false);
          break;
      }
    } else {
      popFlag = false;
      noInternet = true;
      setLoading(true);
    }
    return popFlag;
  }

  /// set bankdetails history
  setBankDetailsHistory(List<GetBankHistoryDetails>? bankDetails) {
    var getBankdetailsHistoryViewModel =
        Provider.of<GetBankdetailsHistoryViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    getBankdetailsHistoryViewModel.getBankDetails = bankDetails;
    getBankDetailsHistory = bankDetails;
    notifyListeners();
  }

  /// Get bank details history

  getBankDetailHistory() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchBankDetailsHistory();
      var decodeResponse = HandleResponse.completed(response);

      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setBankDetailsHistory(decodeResponse.data?.result);
          closeFocus();
          setLoading(false);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      setLoading(true);
      noInternet = true;
      notifyListeners();
    }
  }

  closeFocus() {
    hasInputError1 = false;
    hasInputError2 = false;
    hasInputError3 = false;
    hasInputError4 = false;
    hasInputError5 = false;
    notifyListeners();
  }

  openPage() {
    closedPage = false;
    notifyListeners();
  }
}
