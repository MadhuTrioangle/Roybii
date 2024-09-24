import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/CommonModel/CommonModel.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../../ZodeakX/Setting/Model/GetUserByJwtModel.dart';
import '../Model/IdentityVerificationModel.dart';
import '../Model/SearchResultModel.dart';

class IdentityVerificationCommonViewModel extends ChangeNotifier {
  bool personalVerificationStatus = false;
  bool idVerificationStatus = false;
  bool facialVerificationStatus = false;
  List<dynamic> citiesList = [];
  List<String> citiesNameList = [];
  String? cityName;
  CommonModel? commonModel;
  List<dynamic> countriesList = [];
  List<String> countriesNameList = [];
  String? countryCode;
  GetIdInfo? getIdInfo;
  int id = 0;
  XFile? imageBackPic;
  String? imageBackPicName;
  XFile? imageFacialPic;
  String? imageFacialPicName;
  GetUserJwt? viewModelVerification;
  List<String> statesNameList = [];
  String? countryName;
  String? stateName;
  late SearchResultModel searchResultModel;
  String? imageFrontPicName;
  XFile? imageFrontPic;
  String? img641;
  String? img642;
  String? img643;
  bool needToLoad = true;
  int index = 0;
  bool noInternet = false;
  String? formatDate;
  String splitText = '/image_picker_';
  bool buttonLoading = false;

  DateTime date = DateTime(
    DateTime.now().year - 18,
    DateTime.now().month,
    DateTime.now().day,
  );

  IdentityVerificationCommonViewModel() {
    getSearchResult();
  }

  /// cancel open order
  getSearchResult() async {
    String jsonResponse =
    await rootBundle.loadString(constant.searchResultJson);
    searchResultModel = SearchResultModel.fromJson(json.decode(jsonResponse));
    List<String> countryList = [];
    searchResultModel.countries!.forEach((element) {
      countryList.add(element.countryName);
    });
    setCountryList(countryList);
  }

  /// radiobutton onChanged value using provider

  Future<void> setActive(BuildContext context, int index) async {
    id = index;
    notifyListeners(); //  Consumer to rebuild
  }

  Future<void> setButtonLoading(bool value) async {
    buttonLoading = value;
    notifyListeners(); //  Consumer to rebuild
  }

  final ImagePicker imagePicker = ImagePicker();

  Future imageFront() async {
    var source = ImageSource.gallery;
    XFile? image = await imagePicker.pickImage(
      source: source,
    );
    imageFrontPic = XFile(image!.path);

    if (Platform.isAndroid) splitText = '/scaled_image_picker';

    imageFrontPicName = imageFrontPic?.path.split(splitText).last;
    final bytes = File(imageFrontPic!.path).readAsBytesSync();
    img641 = base64Encode(bytes);
    notifyListeners();
  }

  Future imageBack() async {
    var source = ImageSource.gallery;
    XFile? image = await imagePicker.pickImage(
      source: source,
    );
    imageBackPic = XFile(image!.path);
    if (Platform.isAndroid) splitText = '/scaled_image_picker';
    imageBackPicName = imageBackPic?.path.split(splitText).last;
    final bytes = File(imageBackPic!.path).readAsBytesSync();
    img642 = base64Encode(bytes);
    notifyListeners();
  }

  Future imageFacial() async {
    var source = ImageSource.gallery;
    XFile? image = await imagePicker.pickImage(
      source: source,
    );
    imageFacialPic = XFile(image!.path);
    if (Platform.isAndroid) splitText = '/scaled_image_picker';
    imageFacialPicName = imageFacialPic?.path.split(splitText).last;
    final bytes = File(imageFacialPic!.path).readAsBytesSync();
    img643 = base64Encode(bytes);
    notifyListeners();
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  removeListner() {
    this.dispose();
  }

  /// set IdVerification
  setIdVerification(GetUserJwt? status) {
    viewModelVerification = status;
    notifyListeners();
  }

  /// set Update Personal Information
  setUpdatePersonalInfo(CommonModel? result, BuildContext context) {
    commonModel = result;
    setButtonLoading(false);
    if (commonModel?.statusCode == 200) {
      personalVerificationStatus = true;
      setActive(context, index = 1);
    }
    customSnackBar.showSnakbar(
        context,
        '${commonModel?.statusMessage}',
        commonModel?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    notifyListeners();
  }

  /// set Update Id Information
  setUpdateIdInfo(GetIdInfo? result) {
    setButtonLoading(false);
    getIdInfo = result;
    notifyListeners();
  }

  /// set countrycode
  setCountryName(String? result) {
    countryName = result;
    List<Country>? countries = searchResultModel.countries!
        .where((element) => element.countryName == countryName)
        .toList();
    List<String> stateList = [];
    countries.first.states!
        .forEach((element) => stateList.add(element.stateName));
    setStateList(stateList);
    notifyListeners();
  }

  /// set state code
  setStateName(String? result) {
    stateName = result;
    notifyListeners();
  }

  /// set country list
  setCountryList(List<String> result) {
    countriesNameList = result;
    notifyListeners();
  }

  /// set state list
  setStateList(List<String> result) {
    statesNameList = result;
    notifyListeners();
  }

  /// set Update Facial Information
  setUpdateFacialInfo(CommonModel? result, BuildContext context) {
    setButtonLoading(false);
    commonModel = result;
    if (commonModel?.statusCode == 200) {
      personalVerificationStatus = true;
      setActive(context, index = 3);
      getIdVerification();
    }
    customSnackBar.showSnakbar(
        context,
        '${commonModel?.statusMessage}',
        commonModel?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    notifyListeners();
  }

  /// update personal Information
  UpdatePersonalInfo(
      String UserFirstName,
      String UserMiddleName,
      String UserLastName,
      String UserDob,
      String UserAddress,
      String UserCountry,
      String UserState,
      String UserCity,
      String UserPostalCode,
      BuildContext context,
      ) async {
    String dob = UserDob.replaceAll("/", "-").toString();
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "firstname": UserFirstName,
        "middlename": UserMiddleName,
        "lastname": UserLastName,
        "DOB": dob,
        "address": UserAddress,
        "zip": UserPostalCode,
        "state": UserState,
        "country": UserCountry,
        "city": UserCity
      }
    };

    if (UserMiddleName.isEmpty) {
      mutateUserParams = {
        "data": {
          "firstname": UserFirstName,
          "lastname": UserLastName,
          "DOB": dob,
          "address": UserAddress,
          "zip": UserPostalCode,
          "state": UserState,
          "country": UserCountry,
          "city": UserCity
        }
      };
    }
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
      await productRepository.updatePersonalInfo(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setUpdatePersonalInfo(decodeResponse.data, context);
          notifyListeners();
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

  ///Update Identity Verification
  UpdateIdInfo(
      BuildContext context,
      String? frontView,
      String? backView,
      String text,
      ) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "id_proof_type": text,
        "id_proof_front_status": true,
        "id_proof_front": {"image": frontView, "type": imageFrontPicName},
        "id_proof_back_status": true,
        "id_proof_back": {"image": backView, "type": imageBackPicName},
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
      await productRepository.updateIdInformation(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setUpdateIdInfo(decodeResponse.data?.result);
          if (decodeResponse.data?.statusCode == 200) {
            setActive(context, index = 2);
            getIdVerification();
          }
          customSnackBar.showSnakbar(
              context,
              '${decodeResponse.data?.statusMessage}',
              decodeResponse.data?.statusCode == 200
                  ? SnackbarType.positive
                  : SnackbarType.negative);
          notifyListeners();
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

  ///Update Facial Imformation
  UpdateFacialInfo(
      BuildContext context,
      String? frontView,
      ) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "facial_proof": {"image": frontView, "type": imageFacialPicName},
        "facial_proof_Status": true
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
      await productRepository.updateFacialInformation(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setUpdateFacialInfo(decodeResponse.data, context);
          notifyListeners();
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

  /// Get IdVerification

  getIdVerification() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchIdVerification();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          constant.QRSecertCode.value = response.result?.tfaEnableKey ?? '';
          personalVerificationStatus = decodeResponse.data?.statusCode == 200
              ? decodeResponse.data?.result?.kyc?.idProof?.firstName == ''
              ? false
              : true
              : false;
          idVerificationStatus = decodeResponse
              .data?.result?.kyc?.idProof?.idProofFrontStatus ==
              "verified" ||
              decodeResponse.data?.result?.kyc?.idProof?.idProofFrontStatus ==
                  "pending";
          facialVerificationStatus = decodeResponse
              .data?.result?.kyc?.facialProof?.facialProofStatus ==
              "verified" ||
              decodeResponse
                  .data?.result?.kyc?.facialProof?.facialProofStatus ==
                  "pending";
          setIdVerification(decodeResponse.data?.result);
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

  Future<void> dateTime(DateTime pickedDate) async {
    date = pickedDate;
    String formattedDate = date.toString().substring(0, 10);
    formatDate = formattedDate;
    notifyListeners(); //  Consumer to rebuild
  }
}
