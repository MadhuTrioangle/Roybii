import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Common/model/MerchantPaymentLinkModel.dart';
import 'package:zodeakx_mobile/Common/Common/model/MerchantRecurringInvoiceModel.dart';
import 'package:zodeakx_mobile/Common/OrderBook/ViewModel/OrderBookViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import 'package:zodeakx_mobile/ZodeakX/Repositories/ProductRepositories.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/FiatDepositScreen/Model/FiatCommonDepositModel.dart';
import '../../Exchange/ViewModel/ExchangeViewModel.dart';
import '../../TradeView/ViewModel/TradeViewModel.dart';
import '../model/SocketStatusModel.dart';

class CommonViewModel extends ChangeNotifier {
  /// Bottom Navigation bar onChanged value using provider
  int id = 0;
  bool noInternet = false;
  bool needToLoad = false;
  Widget? drawer;
  TextEditingController searchPairController = TextEditingController();
  MerchantPaymentLink? merchantPaymentLink;
  MerchantRecurringInvoice? merchantRecurringInvoice;
  SocketStatus? socketStatus;
  MarketViewModel? marketViewModel;

  CommonViewModel() {
    setConstValue();
    setLoading(false);
  }

  setConstValue() {}

  Future<void> setActive(int index, [bool searchTrigger = false]) async {
    id = index;
    securedPrint("id>>>>>>${id}");
    notifyListeners(); //  Consumer to rebuild
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// Drawer
  setDrawer(Widget? widget) async {
    drawer = widget;
    notifyListeners();
  }

  /// get Crypto Withdraw
  getCryptoWithdraw(String id, BuildContext context) async {
    Map<String, dynamic> mutateUserParams = {
      'data': {"id": id}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.mutateCryptoWithdraw(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setCryptoWithdraw(decodeResponse.data, context);
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

  /// get fiat Withdraw
  getFiatWithdraw(String id, BuildContext context) async {
    Map<String, dynamic> mutateUserParams = {
      'data': {"id": id}
    };
  }

  setCryptoWithdraw(
      CreateFiatDepositModel? devicelogout, BuildContext context) {
    if (devicelogout?.statusCode == 200) {
      // CoinDetailViewModel viewModel = Provider.of<CoinDetailViewModel>(context, listen: false);
      // SpotWalletViewModel spotWalletViewModel = Provider.of<SpotWalletViewModel>(context, listen: false);
      // WalletViewModel walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
      // ExchangeViewModel exchangeViewModel = Provider.of<ExchangeViewModel>(context, listen: false);
      // viewModel.fetchData();
      // spotWalletViewModel.fetchData();
      // walletViewModel.getBalancePairs();
      // exchangeViewModel.getBalance(exchangeViewModel.pair);
      customSnackBar.showSnakbar(context,
          devicelogout!.statusMessage.toString(), SnackbarType.positive);
    } else {
      customSnackBar.showSnakbar(context,
          devicelogout!.statusMessage.toString(), SnackbarType.negative);
    }
  }

  getLiquidityStatus(String pageView) async {
    marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    await marketViewModel?.webSocket?.connect();
    securedPrint("socketConnect${marketViewModel?.webSocket?.connected}");
    marketViewModel?.webSocket?.on('LiquidityStatus', (data) {
      securedPrint("LiquidityStatus$data");
      var decodeResponse =
          HandleResponse.completed(SocketStatus.fromJson(data));
      switch (decodeResponse.status?.index) {
        case 0:
          break;
        case 1:
          updateSocketStatus(decodeResponse.data, pageView);
          break;
        default:
          break;
      }
    });
  }

  updateSocketStatus(SocketStatus? result, String pageView) {
    MarketViewModel marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    ExchangeViewModel exchangeViewModel = Provider.of<ExchangeViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    TradeViewModel tradeViewModel = Provider.of<TradeViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    OrderBookViewModel orderBookViewModel = Provider.of<OrderBookViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    socketStatus = result;
    securedPrint("socketStatusokxStatus${socketStatus?.okxStatus}");
    securedPrint("socketStatusbinanceStatus${socketStatus?.binanceStatus}");

    /// OKX Status Changes Notify

    if (socketStatus?.okxStatus == true) {
      constant.okxStatus.value = true;
      constant.binanceStatus.value = false;
      if (pageView == "MarketView") {
        marketViewModel.getMarketSocket();
      } else if (pageView == "ExchangeView") {
        exchangeViewModel.getExchangeSocket();
      } else if (pageView == "TradeView") {
        tradeViewModel.getTradeSocket();
      }
    } else {
      constant.okxStatus.value = false;
      if (pageView == "MarketView") {
        marketViewModel.unSubscribeChannel();
      } else if (pageView == "ExchangeView") {
        exchangeViewModel.unSubscribeChannel();
        exchangeViewModel.unSubscribeAllTradePairsChannel();
      } else if (pageView == "TradeView") {
        tradeViewModel.unSubscribeChannel();
        tradeViewModel.unSubscribeAllTradePairsChannel();
      }
    }

    /// BINANCE Status Changes Notify

    if (socketStatus?.binanceStatus == true) {
      constant.binanceStatus.value = true;
      constant.okxStatus.value = false;
      if (pageView == "MarketView") {
        marketViewModel.getMarketSocket();
      } else if (pageView == "ExchangeView") {
        exchangeViewModel.getExchangeSocket();
      } else if (pageView == "TradeView") {
        tradeViewModel.getTradeSocket();
      }
    } else {
      constant.binanceStatus.value = false;
      //  exchangeViewModel.leaveSocket();
    }

    /// OWN Liquidation Status Changes Notify

    if (socketStatus?.binanceStatus == false &&
        socketStatus?.okxStatus == false) {
      constant.binanceStatus.value = false;
      constant.okxStatus.value = false;
      if (pageView == "MarketView") {
        marketViewModel.unSubscribeChannel();
        marketViewModel.getMarketSocket();
      } else if (pageView == "ExchangeView") {
        exchangeViewModel.unSubscribeChannel();
        exchangeViewModel.unSubscribeAllTradePairsChannel();
        exchangeViewModel.getExchangeSocket();
      } else if (pageView == "TradeView") {
        tradeViewModel.unSubscribeChannel();
        tradeViewModel.unSubscribeAllTradePairsChannel();
        tradeViewModel.getTradeSocket();
      }
    }

    // if (pageView == "") {}

    // getLiquidityStatus("");
    notifyListeners();
  }
}
