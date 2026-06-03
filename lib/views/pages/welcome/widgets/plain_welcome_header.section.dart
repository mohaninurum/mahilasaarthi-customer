import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mahilasaarthi/constants/app_colors.dart';
import 'package:mahilasaarthi/constants/home_screen.config.dart';
import 'package:mahilasaarthi/models/address.dart';
import 'package:mahilasaarthi/services/alert.service.dart';
import 'package:mahilasaarthi/services/app.service.dart';
import 'package:mahilasaarthi/services/auth.service.dart';
import 'package:mahilasaarthi/services/location.service.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/utils/utils.dart';
import 'package:mahilasaarthi/view_models/welcome.vm.dart';
import 'package:mahilasaarthi/widgets/cards/custom.visibility.dart';
import 'package:mahilasaarthi/widgets/custom_image.view.dart';
import 'package:mahilasaarthi/widgets/finance/plain_wallet_management.view.dart';
import 'package:mahilasaarthi/widgets/inputs/search_bar.input.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class PlainWelcomeHeaderSection extends StatelessWidget {
  const PlainWelcomeHeaderSection(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final WelcomeViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //location section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: HStack(
                [
                  Icon(
                    FlutterIcons.location_pin_ent,
                    size: 30,
                    color: Utils.textColorByTheme(),
                  ),
                  UiSpacer.hSpace(5),
                  VStack(
                    [
                      "Deliver To"
                          .tr()
                          .text
                          .bold
                          .color(Utils.textColorByTheme())
                          .size(16)
                          .make(),
                      StreamBuilder<Address?>(
                        stream: LocationService.currenctAddressSubject,
                        builder: (conxt, snapshot) {
                          return (snapshot.hasData
                                  ? "${snapshot.data?.addressLine}"
                                  : "Current Location".tr())
                              .text
                              .color(Utils.textColorByTheme())
                              .medium
                              .maxLines(1)
                              .ellipsis
                              .make();
                        },
                      ).flexible(),
                    ],
                  ).flexible(),
                  UiSpacer.hSpace(5),
                  Icon(
                    FlutterIcons.chevron_down_ent,
                    size: 25,
                    color: Utils.textColorByTheme(),
                  ),
                ],
              ),
            ).expand(),

            //profile is login
            StreamBuilder<dynamic>(
              stream: AuthServices.listenToAuthState(),
              initialData: false,
              builder: (ctx, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data is bool &&
                    snapshot.data) {
                  return Container(
                    margin: EdgeInsets.only(right: 15),
                    child: CustomImage(
                      imageUrl: AuthServices.currentUser?.photo ?? "",
                    )
                        .wh(35, 35)
                        .box
                        .roundedFull
                        .clip(Clip.antiAlias)
                        .make()
                        .onInkTap(
                      () {
                        AppService().homePageIndex.add(3);
                      },
                    ),
                  );
                } else {
                  return UiSpacer.emptySpace();
                }
              },
            ),
          ],
        ).onTap(
          () async {
            await onLocationSelectorPressed();
          },
        ),
        StreamBuilder<dynamic>(
          stream: AuthServices.listenToAuthState(),
          initialData: false,
          builder: (ctx, snapshot) {
            if (snapshot.hasData && snapshot.data is bool && snapshot.data) {
              return CustomVisibilty(
                visible: HomeScreenConfig.showWalletOnHomeScreen,
                child: PlainWalletManagementView().py(15),
              );
            } else {
              return UiSpacer.emptySpace().h(20);
            }
          },
        ),

        //search button
        // UiSpacer.vSpace(),

        // UiSpacer.vSpace(5),

        //wallet UI for login user
        //finance section

        //
        UiSpacer.vSpace(20),
      ],
    ).wFull(context).safeArea().p12().box.linearGradient(
        [Color(0xffC70774), Color(0xff610339)],
        begin: Alignment.bottomLeft, end: Alignment.topRight).make();
  }

  Future<void> onLocationSelectorPressed() async {
    try {
      vm.pickDeliveryAddress(onselected: () {
        vm.pageKey = GlobalKey<State>();
        vm.notifyListeners();
      });
    } catch (error) {
      AlertService.stopLoading();
    }
  }
}
