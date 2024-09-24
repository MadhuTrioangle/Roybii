import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../MarketScreen/Model/TradePairModel.dart';
import '../../MarketScreen/Model/TradePairOkxModel.dart';
import '../../MarketScreen/ViewModel/MarketViewModel.dart';
import '../../Repositories/ProductRepositories.dart';
import '../Model/HomeModel.dart';


class HomeViewModel extends ChangeNotifier{

  bool initSocket = false;
  bool needToLoad = true;
  bool noInternet = false;
  Overview? marketOverview;
  List<Gainer>? highlight;
  List<Gainer>? gainer;
  List<Gainer>? vol;
  late TabController homeTabController;
  bool passwordVisible = false;
  List<String> pair=[];

  HomeViewModel(){
    initSocket = true;
  }

  void changeIcon() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }



  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }


    getHomeSocket() async {
      var marketViewModel = Provider.of<MarketViewModel>(
          NavigationService.navigatorKey.currentContext!,
          listen: false);
      initSocket = false;
      if (!constant.binanceStatus.value && !constant.okxStatus.value) {
        getHomeLocalSocket();
      } else if (constant.binanceStatus.value) {
        binanceSocket();
      } else if (constant.okxStatus.value) {
        okxSocket();
      }

      marketViewModel.setViewModel(this);
    }

  binanceSocket() async {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    marketViewModel.ws = await WebSocket.connect(getUrl());
    print(marketViewModel.ws);
    marketViewModel.ws?.listen(
          (data) {
       // print("data>binance>>>${data}");
        TradePairModel tradePairModel =
        TradePairModel.fromJson(json.decode(data));
       updateMarket(tradePairModel.data);

      },
      onDone: () {
        marketViewModel.ws?.close();
        marketViewModel.ws = null;
      },
      onError: (error) {
        marketViewModel.ws?.close();
        marketViewModel.ws = null;
      },
    );
    notifyListeners();
  }

  String getUrl() {
    String url = constant.wssSocketUrl;


// Combine all elements from the three lists into the `pair` list
    for (var item in marketOverview!.highlight) {
      pair.add('${item.code}/USDT');
    }

    for (var item in marketOverview!.gainer) {
      pair.add('${item.code}/USDT');
    }

    for (var item in marketOverview!.volume) {
      pair.add('${item.code}/USDT');
    }

    print("pairee$pair");

    for (int i = 0; i < (pair ?? []).length; i++) {
      url +=
          "${pair?[i]?.replaceAll("/", "").toLowerCase()}" +
              "@ticker${(i == (pair ?? []).length - 1) ? "" : "/"}";
    }
    print("url$url");
    return url;
  }




  getMarketOverview()async{
    var hasInternet = await checkInternet.hasInternet();
      if (hasInternet) {
        var response = await productRepository.getMarketOverview();
        var decodeResponse = HandleResponse.completed(response);
        switch (decodeResponse.status?.index) {
          case 0:
            setLoading(false);
            break;
          case 1:
            setMarketOverview(decodeResponse.data!.result);
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

  setMarketOverview(Overview? Overview) {
    marketOverview = Overview;
    highlight = Overview?.highlight;
    gainer = Overview?.gainer;
    vol = Overview?.volume;
    notifyListeners();
  }

  void getHomeLocalSocket() {}


  updateMarket(TradePair tradePairModel) {
    TradePair? tradePair = tradePairModel;

    highlight?.forEach((element) {
      if (tradePair.s.contains(element.code)) {
        element.price = tradePair.c;
        element.changePercent = tradePair.P;
        element.volume24H = tradePair.q;
      }
    });

    gainer?.forEach((element) {
      if (tradePair.s.contains(element.code)) {
        element.price = tradePair.c;
        element.changePercent = tradePair.P;
        element.volume24H = tradePair.q;
      }
    });
    vol?.forEach((element) {
      if (tradePair.s.contains(element.code)) {
        element.price = tradePair.c;
        element.changePercent = tradePair.P;
        element.volume24H = tradePair.q;
      }
    });
 notifyListeners();
  }

  okxSocket() {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.webSocketChannel = WebSocketChannel.connect(
      Uri.parse(constant.wssSocketOkxUrl),
    );
    for (var item in marketOverview!.highlight) {
      pair.add('${item.code}/USDT');
    }
    for (var item in marketOverview!.gainer) {
      pair.add('${item.code}/USDT');
    }
    for (var item in marketOverview!.volume) {
      pair.add('${item.code}/USDT');
    }
    print("pairee$pair");
    List allPairChannels = [];
    Map<String, Object>? channels;

    for (int i = 0; i < pair.length; i++) {
      allPairChannels.add({
        "channel": "tickers",
        "instId": pair?[i].replaceAll("/", "-")
      });
      channels = {
        "op": "subscribe",
        "args": allPairChannels,
      };
    }
    marketViewModel.webSocketChannel.sink.add(
      jsonEncode(channels),
    );
    marketViewModel.webSocketChannel.stream.listen(
          (data) {
            print("data>OKX>>>${data}");
            TradePairOkxModel tradePairOkxModel =
            TradePairOkxModel.fromJson(json.decode(data));
            if (tradePairOkxModel.data!.isNotEmpty) {
              updateOkxTradePairs(tradePairOkxModel.data!.first);
            } else {}
      },
      onError: (error) {},
      onDone: () => {},
    );
  }

   updateOkxTradePairs(OkxTradePairs okxTradePairModel) {

     OkxTradePairs? okxTradePair = okxTradePairModel;

     highlight?.forEach((element) {
       if (okxTradePair.instId!.contains(element.code)) {
         element.price = okxTradePair.last!;
         element.changePercent = ((double.parse(okxTradePair.last.toString()) -
             double.parse(okxTradePair.open24H.toString())) *
             100 /
             double.parse(okxTradePair.open24H.toString()))
             .toString();
         element.volume24H = okxTradePair.vol24H;
       }
     });
     gainer?.forEach((element) {
       if (okxTradePair.instId!.contains(element.code)) {
         element.price = okxTradePair.last!;
         element.changePercent = ((double.parse(okxTradePair.last.toString()) -
             double.parse(okxTradePair.open24H.toString())) *
             100 /
             double.parse(okxTradePair.open24H.toString()))
             .toString();
         element.volume24H = okxTradePair.vol24H;
       }
     });

     vol?.forEach((element) {
       if (okxTradePair.instId!.contains(element.code)) {
         element.price = okxTradePair.last!;
         element.changePercent = ((double.parse(okxTradePair.last.toString()) -
             double.parse(okxTradePair.open24H.toString())) *
             100 /
             double.parse(okxTradePair.open24H.toString()))
             .toString();
         element.volume24H = okxTradePair.vol24H;
       }
     });
     notifyListeners();
   }

}