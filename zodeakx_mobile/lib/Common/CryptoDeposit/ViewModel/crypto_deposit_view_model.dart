import 'package:flutter/cupertino.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CommonModel/CommonModel.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';



import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';

class CryptoDepositViewModel extends ChangeNotifier {

  String wallet   = stringVariables.spotWallet;
  bool needToLoad = false;
  bool noInternet = false;
  CommonModel? commonModel;

  CryptoDepositViewModel(){
  }



  setWallet(String value) {
    wallet = value;
    notifyListeners();
  }

  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  updateUserDefaultWallet(String walletType) async {
    Map<String, dynamic> mutateUserParams = {
      "input": {"module": "crypto_deposit", "wallet_type": walletType == stringVariables.spotWallet ? "spot_wallet" :"funding_wallet"}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.updateUserDefaultWallet(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setUpdateUserDefaultWallet(decodeResponse.data,walletType);
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

  setUpdateUserDefaultWallet(CommonModel? data, String walletType) {
    commonModel = data;
    if(commonModel?.statusCode == 200){
      if(walletType == stringVariables.spotWallet){
        setWallet(stringVariables.spotWallet);
      }else{
        setWallet(stringVariables.fundingWallet);
      }

    }
    CustomSnackBar().showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        '${commonModel?.statusMessage}',
        commonModel?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    notifyListeners();
  }
}
