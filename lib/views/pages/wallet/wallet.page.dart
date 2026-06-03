import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mahilasaarthi/view_models/wallet.vm.dart';
import 'package:mahilasaarthi/widgets/base.page.dart';
import 'package:mahilasaarthi/widgets/custom_list_view.dart';
import 'package:mahilasaarthi/widgets/finance/wallet_management.view.dart';
import 'package:mahilasaarthi/widgets/list_items/wallet_transaction.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../utils/utils.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with WidgetsBindingObserver {
  //
  WalletViewModel? vm;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      vm?.initialise();
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    vm ??= WalletViewModel(context);

    //
    return BasePage(
      backgroundColor: Color(0xffF8F7F7),
      title: "Wallet".tr(),
      showLeadingAction: true,
      showAppBar: false,
      body: ViewModelBuilder<WalletViewModel>.reactive(
        viewModelBuilder: () => vm!,
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return SmartRefresher(
            controller: vm.refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: vm.loadWalletData,
            onLoading: () => vm.getWalletTransactions(initialLoading: false),
            child: VStack(
              [

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xffC70774),Color(0xff610339)],begin:Alignment.bottomLeft ,end:  Alignment.topRight)
                  ),height: 100,width: double.infinity,child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                  SizedBox(height: 50,),
                  Row(children: [
                    IconButton(
                      icon: Icon(
                        !Utils.isArabic
                            ? FlutterIcons.arrow_left_fea
                            : FlutterIcons.arrow_right_fea,
                        color:Colors.white
                        ,
                      ),
                      onPressed:  () => Navigator.pop(context),
                    ),
                    SizedBox(width: 15,),
                    "Wallet".tr().text.xl2.semiBold.white.make(),
                  ],)
                ],),),
                SizedBox(height: 25,),

                //
                WalletManagementView(
                  viewmodel: vm,
                ).px(16),
               SizedBox(height: 10,),
                //transactions list
                "Wallet Transactions".tr().text.bold.xl.make().px(16),
                SizedBox(height: 20,),

                CustomListView(
                  padding: EdgeInsets.zero  ,
                  noScrollPhysics: true,
                  isLoading: vm.busy(vm.walletTransactions),
                  onRefresh: vm.getWalletTransactions,
                  onLoading: () =>
                      vm.getWalletTransactions(initialLoading: false),
                  dataSet: vm.walletTransactions,
                  itemBuilder: (context, index) {
                    return WalletTransactionListItem(
                        vm.walletTransactions[index]);
                  },
                ).px(16),
              ],
            ).scrollVertical(),
          );
        },
      ),
    );
  }
}
