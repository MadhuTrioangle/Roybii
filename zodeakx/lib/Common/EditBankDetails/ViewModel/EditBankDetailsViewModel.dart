import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Common/BankDetailsHistory/Model/BankDetailHistoryModel.dart';
import 'package:zodeakx_mobile/Common/EditBankDetails/Model/DeleteBankdetailsModel.dart';
import 'package:zodeakx_mobile/Common/EditBankDetails/Model/EditBankDetailsModel.dart';
import 'package:zodeakx_mobile/Common/Repositories/CommonRepository.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/ZodeakX/Repositories/ProductRepositories.dart';

class EditBankDetailsViewModel extends ChangeNotifier {
  bool checkBoxStatus = false;
  bool noInternet = false;
  bool needToLoad = false;
  bool positiveStatus = false;
  bool showSnackbar = false;
  EditBankDetails? editBankDetailsUserResponse;
  List<GetBankHistoryDetails>? getBankDetails;

  /// delete bank details
  DeleteBankDetail? deleteBankDetailsUserResponse;

  EditBankDetailsViewModel() {
    //getBankDetailsHistory();
    showSnackbar = false;
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// get edit bank details response
  getEditBankDetails(context, EditBankDetails? createUserResponse) {
    editBankDetailsUserResponse = createUserResponse;
    getSnackBarstatus(context, createUserResponse);
  }

  getSnackBarstatus(context, EditBankDetails? createUserResponse) {
    positiveStatus = ((editBankDetailsUserResponse?.statusCode ?? 200) == 200)
        ? true
        : false;
    ((createUserResponse?.statusCode ?? 403) == 200)
        ? getBankDetailsHistory()
        : () {};
    moveToBankDetailsHistory(context);
    showSnackbar = true;
  }

  createUserEditBankDetails(BankDetail bankDetail, BuildContext context) async {
    setLoading(true);

    Map<String, dynamic> mutateUserParams = {
      "data": {
        "label_key": {
          "account_holder_name": bankDetail.accountHolderName,
          "account_number": bankDetail.accountNumber,
          "bank_name": bankDetail.bankName,
          "iban_number": bankDetail.ibanNumber,
          "bank_address": bankDetail.bankAddress
        },
        "primary": bankDetail.primary,
        "_id": bankDetail.id
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

  /// set bankdetails history
  setBankDetailsHistory(List<GetBankHistoryDetails>? bankDetails) {
    getBankDetails = bankDetails;
    notifyListeners();
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
    ((deleteUserResponse?.statusCode ?? 403) == 200)
        ? moveToBankDetailsHistory(context)
        : () {};
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
}
