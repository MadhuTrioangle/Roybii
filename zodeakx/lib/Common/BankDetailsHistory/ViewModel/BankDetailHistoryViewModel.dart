import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Common/BankDetailsHistory/Model/BankDetailHistoryModel.dart';
import 'package:zodeakx_mobile/Common/EditBankDetails/Model/DeleteBankdetailsModel.dart';
import 'package:zodeakx_mobile/Common/EditBankDetails/Model/EditBankDetailsModel.dart';
import 'package:zodeakx_mobile/Common/Repositories/CommonRepository.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import 'package:zodeakx_mobile/ZodeakX/Repositories/ProductRepositories.dart';

class GetBankdetailsHistoryViewModel extends ChangeNotifier {
  GetBankdetailsHistoryViewModel? viewModel;
  bool noInternet = false;
  bool needToLoad = false;
  bool positiveStatus = false;
  bool showSnackbar = false;
  bool checkBoxStatus = false;
  List<GetBankHistoryDetails>? getBankDetails;

  /// edit bank details
  EditBankDetails? editBankDetailsUserResponse;

  /// delete bank details
  DeleteBankDetail? deleteBankDetailsUserResponse;

  /// initilizing API
  GetBankdetailsHistoryViewModel() {
  }

  /// radiobutton onChanged value using provider
  int id = 2;

  Future<void> setActive(BuildContext context, int index) async {
    id = index;
    notifyListeners(); //  Consumer to rebuild
  }

  /// IconButton onChanged value using provider

  bool isButtonPressed = false;

  void changeIcon() {
    isButtonPressed = !isButtonPressed;
    notifyListeners();
  }

  /// Loader
  setCheckbox(bool checkBoxStatus) async {
    this.checkBoxStatus = checkBoxStatus;
    notifyListeners();
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// set bankdetails history
  setBankDetailsHistory(List<GetBankHistoryDetails>? bankDetails) {
    getBankDetails = bankDetails;
    notifyListeners();
  }

  /// Get bank details history
  getBankDetailsHistory() async {
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

  /// edit bank details response
  getEditBankDetails(context, EditBankDetails? createUserResponse) {
    editBankDetailsUserResponse = createUserResponse;
    getSnackBarstatus(context, createUserResponse);
  }

  getSnackBarstatus(context, EditBankDetails? createUserResponse) {
    positiveStatus = ((editBankDetailsUserResponse?.statusCode ?? 200) == 200)
        ? true
        : false;

    if ((createUserResponse?.statusCode ?? 403) == 200) {
      getBankDetailsHistory();
      Navigator.pop(context);
    }
    customSnackBar.showSnakbar(
        context,
        editBankDetailsUserResponse?.statusMessage ?? '',
        editBankDetailsUserResponse?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    showSnackbar = true;
  }

  createUserEditBankDetails(
      String userName,
      String accNum,
      String bankName,
      String ibanNum,
      String bankAddress,
      bool primary,
      String id,
      BuildContext context) async {
    setLoading(true);

    Map<String, dynamic> mutateUserParams = {
      "data": {
        "label_key": {
          "account_holder_name": userName,
          "account_number": accNum,
          "bank_name": bankName,
          "iban_number": ibanNum,
          "bank_address": bankAddress
        },
        "primary": primary,
        "_id": id
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await commonRepository.MutatecreateUserEditBankDetails(
          mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getEditBankDetails(context, decodeResponse.data);
          setLoading(false);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      noInternet = true;
      setLoading(true);
    }
  }

  /// get deleted list
  getDeleteBankDetails(context, DeleteBankDetail? deleteUserResponse) {
    deleteBankDetailsUserResponse = deleteUserResponse;
    getSnackBarDeletestatus(context, deleteUserResponse);
  }

  getSnackBarDeletestatus(context, DeleteBankDetail? deleteUserResponse) {
    positiveStatus = ((deleteBankDetailsUserResponse?.statusCode ?? 200) == 200)
        ? true
        : false;
    ((deleteUserResponse?.statusCode ?? 403) == 200) ? () {} : () {};
    customSnackBar.showSnakbar(
        context,
        deleteBankDetailsUserResponse?.statusMessage ?? '',
        deleteBankDetailsUserResponse?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    showSnackbar = true;
  }

  /// delete user bank details
  deleteUserBankDetails(BankDetail bankDetail, BuildContext context) async {
    setLoading(true);

    Map<String, dynamic> mutateUserParams = {
      "data": {"bank_id": bankDetail.id}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await commonRepository.MutateDeleteBankDetails(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getDeleteBankDetails(context, decodeResponse.data);
          setLoading(false);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      noInternet = true;
      setLoading(true);
    }
  }
}
