import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CommonModel/CommonModel.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';

import '../../../Common/VerifyGoogleAuthCode/ViewModel/VerifyGoogleAuthenticateViewModel.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import "../../../ZodeakX/Setting/Model/GetUserByJwtModel.dart";
import '../../profile/model/UserPaymentDetailsModel.dart';

class P2PPaymentMethodsViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = true;
  bool imageRequire = false;
  XFile? imageQrCode;
  final ImagePicker imagePicker = ImagePicker();
  String? imageQrCodeName;
  String? imageQrCodeEncoded;
  String? editQr;
  bool isValidInput = false;
  List<UserPaymentDetails>? paymentMethods;
  GetUserJwt? getUserByJwt;
  String? paymentDetails;
  List<String> paymentsList = [];
  Map<String, dynamic> paymentDetailsParams = {};

  Future pickImageForQrCode() async {
    var source = ImageSource.gallery;
    XFile? image = await imagePicker.pickImage(
      source: source,
    );
    if (image == null) return;
    imageQrCode = XFile(image!.path);
    imageQrCodeName = imageQrCode?.path.split('/image_picker_').last;
    final bytes = File(imageQrCode!.path).readAsBytesSync();
    imageQrCodeEncoded = base64Encode(bytes);
    editQr = null;
    notifyListeners();
  }

  P2PPaymentMethodsViewModel() {}

  setImageQrCodeEncoded(String? value) {
    imageQrCodeEncoded = value;
    notifyListeners();
  }

  setImageRequire(bool value) {
    imageRequire = value;
    notifyListeners();
  }

  setEditQr(String? value) {
    editQr = value;
    notifyListeners();
  }

  setPaymentDetails(String? value) {
    paymentDetails = value;
    notifyListeners();
  }

  setPaymentDetailsParams(Map<String, dynamic> value) {
    paymentDetailsParams = value;
    notifyListeners();
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setValidInput(bool loading) async {
    isValidInput = loading;
    notifyListeners();
  }

  //API
  fetchPaymentMethods() async {
    Map<String, dynamic> mutateUserParams = {"UserPaymentDetails": {}};
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchUserPaymentDetails(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getPaymentMethods(decodeResponse.data?.result);
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

  getPaymentMethods(List<UserPaymentDetails>? paymentMethods) {
    this.paymentMethods = paymentMethods;
    paymentsList.clear();
    paymentMethods?.forEach((element) {
      String title = element.paymentName ?? "";
      if (title == "bank_transfer") title = stringVariables.bankTransfer;
      paymentsList.add(title);
    });
    setLoading(false);
    notifyListeners();
  }

  addUserPaymentMethod(String code, String paymentDetails) async {
    print("pay - $paymentDetails");
    print("pay det - $paymentDetailsParams");
    var verifyGoogleAuthenticationViewModel =
        Provider.of<VerifyGoogleAuthenticationViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    String tfaType = verifyGoogleAuthenticationViewModel.mobileOtp == true
        ? "mobile_number"
        : "tfa";
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "tfa_code": code,
        "tfa_type": tfaType,
        "payment_method": paymentDetails,
        "payment_details": paymentDetailsParams
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.addUserPaymentMethod(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getUserPaymentMethod(decodeResponse.data);
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

  updateUserPaymentMethod(String code, String paymentDetails) async {
    String id = paymentMethods
            ?.where((element) => element.paymentName == paymentDetails)
            .first
            .id ??
        "";
    var verifyGoogleAuthenticationViewModel =
        Provider.of<VerifyGoogleAuthenticationViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    String tfaType = verifyGoogleAuthenticationViewModel.mobileOtp == true
        ? "mobile_number"
        : "tfa";
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "_id": id,
        "tfa_code": code,
        "tfa_type": tfaType,
        "payment_method": paymentDetails,
        "payment_details": paymentDetailsParams
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.updateUserPaymentMethod(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getUserPaymentMethod(decodeResponse.data);
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

  deleteUserPaymentMethod(String id) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"_id": id}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.deleteUserPaymentMethod(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getUserPaymentMethod(decodeResponse.data);
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

  getUserPaymentMethod(CommonModel? commonModel) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        commonModel?.statusMessage ?? "",
        commonModel?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    if (commonModel?.statusCode == 200) fetchPaymentMethods();
    notifyListeners();
  }

  setJwtUserResponse(GetUserJwt? getUserByJwt) {
    this.getUserByJwt = getUserByJwt;
    fetchPaymentMethods();
    notifyListeners();
  }

  getJwtUserResponse() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchIdVerification();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setJwtUserResponse(response.result);
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

  clearData() {
    noInternet = false;
    needToLoad = true;
    isValidInput = false;
    imageQrCode = null;
    imageQrCodeName = null;
    imageQrCodeEncoded = null;
    editQr = null;
    paymentMethods = null;
    getUserByJwt = null;
    paymentDetails = null;
    paymentsList = [];
    notifyListeners();
  }
}
