import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';

import '../../../Common/RegisterScreen/ViewModel/RegisterViewModel.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomSlider.dart';
import '../ViewModel/CreateAccountScreenViewModel.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView>
    with SingleTickerProviderStateMixin {
  late CreateAccountViewModel viewModel;
  late RegisterViewModel registerViewModel;

  @override
  void initState() {
    // TODO: implement initState
    viewModel = Provider.of<CreateAccountViewModel>(context, listen: false);
    registerViewModel = Provider.of<RegisterViewModel>(context, listen: false);
    viewModel.pageController = PageController(viewportFraction: 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageNavigate();
    });

    super.initState();
  }

  pageNavigate() {
    Future.delayed(
        Duration(
          seconds: 5,
        ), () {
      viewModel.setActivePage(1);
      nextPage(viewModel.activePage + 1);
    });
  }

  void nextPage(int page) {
    viewModel.pageController!.animateToPage(page,
        duration: Duration(milliseconds: 400), curve: Curves.bounceIn);
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<CreateAccountViewModel>();
    registerViewModel = context.watch<RegisterViewModel>();
    return Provider<CreateAccountViewModel>(
      create: (context) => viewModel,
      child: CustomScaffold(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageSlider(
                  images: [welcome1, welcome2],
                  pageController: viewModel.pageController,
                  onPageChanged: (page) {
                    viewModel.setActivePage(page);
                    if (viewModel.activePage == 0) {
                      pageNavigate();
                    }
                  },
                  activePage: viewModel.activePage),
              CustomSizedBox(
                height: 0.02,
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    CustomText(
                      text: viewModel.activePage == 0
                          ? stringVariables.createAccountHeader1
                          : stringVariables.createAccountHeader2,
                      maxlines: 2,
                      fontWeight: FontWeight.bold,
                      fontsize: 31,
                    ),
                    CustomSizedBox(
                      height: 0.025,
                    ),
                    CustomText(
                      text: viewModel.activePage == 0
                          ? stringVariables.createAccountContent1
                          : stringVariables.createAccountContent2,
                      fontsize: 16,
                      fontWeight: FontWeight.w400,
                      color: contentFontColor,
                      strutStyleHeight: 1.8,
                    ),
                    CustomSizedBox(
                      height: 0.025,
                    ),
                    CustomElevatedButton(
                        text: stringVariables.createAccount,
                        multiClick: true,
                        color: white,
                        press: () {
                          moveToRegister(context, true);
                        },
                        radius: 16,
                        buttoncolor: themeColor,
                        fillColor: themeColor,
                        width: 1,
                        height: MediaQuery.of(context).size.height / 50,
                        isBorderedButton: false,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                        icons: false,
                        icon: null),
                    CustomSizedBox(
                      height: 0.025,
                    ),
                    CustomElevatedButton(
                        text: stringVariables.login,
                        multiClick: true,
                        color: themeColor,
                        press: () {
                          moveToRegister(context, true);

                          registerViewModel.setIsLogin(false);
                        },
                        radius: 16,
                        buttoncolor: themeColor,
                        width: 1,
                        height: MediaQuery.of(context).size.height / 50,
                        isBorderedButton: true,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                        icons: false,
                        icon: null),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
