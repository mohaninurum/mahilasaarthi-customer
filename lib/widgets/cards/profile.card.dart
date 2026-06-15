import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mahilasaarthi/constants/app_finance_settings.dart';
import 'package:mahilasaarthi/constants/app_images.dart';
import 'package:mahilasaarthi/constants/app_strings.dart';
import 'package:mahilasaarthi/constants/app_ui_settings.dart';
import 'package:mahilasaarthi/resources/resources.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/view_models/profile.vm.dart';
import 'package:mahilasaarthi/widgets/busy_indicator.dart';
import 'package:mahilasaarthi/widgets/cards/custom.visibility.dart';
import 'package:mahilasaarthi/widgets/menu_item.dart';
import 'package:mahilasaarthi/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(this.model, {Key? key}) : super(key: key);

  final ProfileViewModel model;
  @override
  Widget build(BuildContext context) {
    return model.authenticated
        ? VStack(
            [
              //profile card
              HStack(
                [
                  //
                  (model.currentUser?.photo == null || model.currentUser!.photo.isEmpty)
                      ? Image.asset(AppImages.user)
                      : CachedNetworkImage(
                          imageUrl: model.currentUser!.photo,
                          progressIndicatorBuilder: (context, imageUrl, progress) {
                            return BusyIndicator();
                          },
                          errorWidget: (context, imageUrl, progress) {
                            return Image.asset(
                              AppImages.user,
                            );
                          },
                        )
                      .wh(Vx.dp64, Vx.dp64)
                      .box
                      .roundedFull
                      .clip(Clip.antiAlias)
                      .make(),

                  //
                  VStack(
                    [
                      //name
                      model.currentUser!.name.text.xl.semiBold.make(),
                      //email
                      model.currentUser!.email.text.light.make(),
                      //share invation code
                      AppStrings.enableReferSystem
                          ? "Share referral code"
                              .tr()
                              .text
                              .sm
                              .color(Colors.black)
                              .make()
                              .box
                              .px8
                              .withRounded(value: 3)
                              .border(color: Colors.black)
                              .make()
                              .onInkTap(model.shareReferralCode)
                              .py8()
                          : UiSpacer.emptySpace(),
                    ],
                  ).px20().expand(),

                  //
                ],
              ).p12(),

              //
              VStack(
                [
                  MenuItem(
                    title: "Edit Profile".tr(),
                    onPressed: model.openEditProfile,
                    ic: AppIcons.edit,
                  ),
                  //Payment
                  // MenuItem(
                  //   title: "Payment".tr(),
                  //   onPressed: model.openPhonepe,
                  //   ic: AppIcons.loyaltyPoint,
                  // ),

                  //change password
                  MenuItem(
                    title: "Change Password".tr(),
                    onPressed: model.openChangePassword,
                    ic: AppIcons.password,
                  ),
                  //referral
                  CustomVisibilty(
                    visible: AppStrings.enableReferSystem,
                    child: MenuItem(
                      title: "Refer & Earn".tr(),
                      onPressed: model.openRefer,
                      ic: AppIcons.refer,
                    ),
                  ),
                  //loyalty point
                  CustomVisibilty(
                    visible: AppFinanceSettings.enableLoyalty,
                    child: MenuItem(
                      title: "Loyalty Points".tr(),
                      onPressed: model.openLoyaltyPoint,
                      ic: AppIcons.loyaltyPoint,
                    ),
                  ),
                  //Wallet
                  CustomVisibilty(
                    visible: AppUISettings.allowWallet,
                    child: MenuItem(
                      title: "Wallet".tr(),
                      onPressed: model.openWallet,
                      ic: AppIcons.wallet,
                    ),
                  ),
                  //addresses
                  MenuItem(
                    title: "Delivery Addresses".tr(),
                    onPressed: model.openDeliveryAddresses,
                    ic: AppIcons.homeAddress,
                  ),
                  //favourites
                  MenuItem(
                    title: "Favourites".tr(),
                    onPressed: model.openFavourites,
                    ic: AppIcons.favourite,
                  ),
                  //
                  MenuItem(
                    child: "Logout".tr().text.red500.make(),
                    onPressed: model.logoutPressed,
                    suffix: Icon(
                      FlutterIcons.logout_ant,
                      size: 16,
                    ),
                  ),
                  MenuItem(
                    child: "Delete Account".tr().text.red500.make(),
                    onPressed: model.deleteAccount,
                    suffix: Icon(
                      FlutterIcons.delete_ant,
                      size: 16,
                      color: Vx.red400,
                    ),
                  ),
                  //
                ],
              ).p12(),
            ],
          )
            .wFull(context)
            .box
            .make()
        : EmptyState(
            auth: true,
            showAction: true,
            actionPressed: model.openLogin,
          ).py12();
  }
}
