import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTextformfield.dart';

import '../../../Common/Wallets/CoinDetailsModel/get_currency.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../viewModel/search_coins_view_model.dart';

class SearchCoinsView extends StatefulWidget {
  final bool isHistory;

  const SearchCoinsView({Key? key, required this.isHistory}) : super(key: key);

  @override
  State<SearchCoinsView> createState() => _SearchCoinsViewState();
}

class _SearchCoinsViewState extends State<SearchCoinsView> {
  late SearchCoinsViewModel viewModel;
  TextEditingController searchController = TextEditingController();
  List<GetCurrency> _searchResult = [];
  String filteredText = "";

  @override
  void initState() {
    viewModel = Provider.of<SearchCoinsViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
      searchController.clear();
      onSearchTextChanged("");
      searchController.addListener(() {
        searchController.text.isEmpty
            ? viewModel.setSearchControllerText(false)
            : viewModel.setSearchControllerText(true);
      });
    });
    viewModel.getCryptoCurrency();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<SearchCoinsViewModel>();
    return Provider<SearchCoinsViewModel>(
      create: (context) => viewModel,
      builder: (context, child) {
        return searchCoinsView(
          context,
        );
      },
    );
  }

  Widget searchCoinsView(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: CustomContainer(
          width: 1,
          height: 1,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: SvgPicture.asset(
                      backArrow,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      child: CustomCard(
        radius: 15,
        outerPadding: 8,
        edgeInsets: 8,
        elevation: 0,
        child: viewModel.needToLoad
            ? Center(
                child: CustomLoader(),
              )
            : Column(
                children: [
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  CustomTextFormField(
                    size: 30,
                    isContentPadding: false,
                    prefixIcon: GestureDetector(
                        child: Icon(
                      Icons.search,
                      color: textGrey,
                      size: 25,
                    )),
                    text: stringVariables.search,
                    hintfontsize: 16,
                    controller: searchController,
                    onChanged: onSearchTextChanged,
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  buildSearchList(),
                ],
              ),
      ),
    );
  }

  onSearchTextChanged(
    String text,
  ) async {
    _searchResult.clear();
    if (!viewModel.searchControllerText) {
      return;
    }

    List<GetCurrency> searchResult = viewModel.cryptoCurrency ?? [];

    _searchResult = searchResult
        .where((element) =>
            element.currencyCode!.toLowerCase().contains(text.toLowerCase()) ||
            element.name!.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  Widget buildNoRecord() {
    return Center(
      child: Column(
        children: [
          CustomSizedBox(
            height: 0.04,
          ),
          SvgPicture.asset(
            stakingNotFound,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomText(
            fontfamily: 'GoogleSans',
            fontsize: 20,
            fontWeight: FontWeight.bold,
            text: stringVariables.notFound,
            color: hintLight,
          ),
        ],
      ),
    );
  }

  Widget buildSearchList() {
    List<GetCurrency> cryptoCurrency = viewModel.searchControllerText
        ? _searchResult
        : viewModel.cryptoCurrency ?? [];
    int listCount = cryptoCurrency.length;
    return Flexible(
      fit: FlexFit.loose,
      child: CustomContainer(
        height: 1,
        child: listCount != 0
            ? ListView.builder(
                itemCount: listCount,
                itemBuilder: (context, index) {
                  String image = cryptoCurrency[index].image ?? "";
                  String code = cryptoCurrency[index].currencyCode ?? "";
                  String network = cryptoCurrency[index].name;
                  return GestureDetector(
                    onTap: () {
                      if (widget.isHistory) {
                        if (viewModel.selectedHistoryCurrency == code) {
                          viewModel.setSelectedHistoryCurrency(null);
                        } else {
                          viewModel.setSelectedHistoryCurrency(code);
                        }
                      } else {
                        if (viewModel.selectedCurrency == code) {
                          viewModel.setSelectedCurrency(null);
                        } else {
                          viewModel.setSelectedCurrency(code);
                        }
                      }
                      Navigator.pop(context);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: ListTile(
                      leading: Image.network(image, height: 40),
                      title: CustomText(
                        text: network,
                        fontsize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      subtitle: CustomText(
                        text: code,
                        fontsize: 13,
                        color: stackCardText,
                      ),
                      trailing: (widget.isHistory
                              ? (viewModel.selectedHistoryCurrency == code)
                              : (viewModel.selectedCurrency == code))
                          ? Icon(
                              Icons.done,
                              color: themeColor,
                            )
                          : CustomSizedBox(
                              width: 0,
                              height: 0,
                            ),
                    ),
                  );
                })
            : buildNoRecord(),
      ),
    );
  }
}
