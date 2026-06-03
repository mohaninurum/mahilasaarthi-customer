import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mahilasaarthi/constants/app_strings.dart';
import 'package:mahilasaarthi/extensions/string.dart';
import 'package:mahilasaarthi/services/auth.service.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/utils/utils.dart';
import 'package:mahilasaarthi/view_models/wallet.vm.dart';
import 'package:mahilasaarthi/views/pages/wallet/wallet.page.dart';
import 'package:mahilasaarthi/widgets/busy_indicator.dart';
import 'package:mahilasaarthi/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class PlainWalletManagementView extends StatefulWidget {
  const PlainWalletManagementView({
    this.viewmodel,
    Key? key,
  }) : super(key: key);

  final WalletViewModel? viewmodel;

  @override
  State<PlainWalletManagementView> createState() =>
      _PlainWalletManagementViewState();
}

class _PlainWalletManagementViewState extends State<PlainWalletManagementView>
    with WidgetsBindingObserver {
  WalletViewModel? mViewmodel;
  @override
  void initState() {
    super.initState();

    mViewmodel = widget.viewmodel;
    mViewmodel ??= WalletViewModel(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      mViewmodel?.initialise();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      mViewmodel?.initialise();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Colors.white;
    final textColor = Utils.textColorByColor(bgColor);
    //
    return ViewModelBuilder<WalletViewModel>.reactive(
      viewModelBuilder: () => mViewmodel!,
      disposeViewModel: widget.viewmodel == null,
      builder: (context, vm, child) {
        return StreamBuilder(
          stream: AuthServices.listenToAuthState(),
          builder: (ctx, snapshot) {
            //
            if (!snapshot.hasData) {
              return UiSpacer.emptySpace();
            }
            //view
            return VStack(
              [
                //
                Visibility(
                  visible: vm.isBusy,
                  child: BusyIndicator(),
                ),

                //
                HStack(
                  [
                    VStack(
                      [
                        "Wallet Balance"
                            .tr()
                            .text
                            .size(23)
                            .bold
                            .color(Colors.white)
                            .make(),
                        UiSpacer.vSpace(3),
                        "${AppStrings.currencySymbol} ${vm.wallet != null ? vm.wallet?.balance : 0.00}"
                            .currencyFormat()
                            .text
                            .size(22)
                            .color(Colors.white)
                            .xl2
                            .extraBold
                            .make(),
                      ],
                    ).expand(),
                    UiSpacer.hSpace(10),
                    //buttons
                    Visibility(
                      visible: !vm.isBusy,
                      child: VStack(
                        [
                          //topup button
                          CustomButton(
                            padding: EdgeInsets.all(6),
                            height: 30,
                            color: Color(0xff732150),
                            shapeRadius: 12,
                            onPressed: vm.showAmountEntry,
                            child: HStack(
                              [
                                "Top-Up"
                                    .tr()
                                    .text
                                    .bold
                                    .color(Colors.white)
                                    .make(),
                                UiSpacer.hSpace(5),

                                Icon(
                                  // Icons.add,
                                  FlutterIcons.plus_ant,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                //
                              ],
                              crossAlignment: CrossAxisAlignment.center,
                              alignment: MainAxisAlignment.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 10,),
                // "Tap for more info/action".tr().text.color(Colors.white).sm.makeCentered(),
              ],
            ).p(10).wFull(context).onInkTap(
              () {
                context.nextPage(WalletPage());
              },
            );
          },
        );
      },
    );
  }
}
