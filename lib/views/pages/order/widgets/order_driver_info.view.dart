import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mahilasaarthi/constants/app_colors.dart';
import 'package:mahilasaarthi/models/order.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/utils/utils.dart';
import 'package:mahilasaarthi/widgets/buttons/custom_button.dart';
import 'package:mahilasaarthi/widgets/custom_image.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../constants/app_ui_settings.dart';
import '../../../../view_models/order_details.vm.dart';

class OrderDriverInfoView extends StatelessWidget {
  OrderDriverInfoView(
    this.order, {
      required this.vm,
    required this.rateDriverAction,
    Key? key,
  }) : super(key: key);

  final Order order;
  final Function rateDriverAction;
  OrderDetailsViewModel vm;
  @override
  Widget build(BuildContext context) {
    double avatarSize = context.percentWidth * 14;

    //
    return order.driver != null
        ? Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Color(0xffF0F0F0),borderRadius: BorderRadius.circular(10)),
          child: VxBox(
              child: VStack(
                [
                  //driver info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                    child: HStack(
                      [
                        //driver profile
                        // Stack(
                        //   children: [
                        //     // CustomImage(
                        //     //   imageUrl: order.driver!.photo,
                        //     //   width: avatarSize,
                        //     //   height: avatarSize,
                        //     // ),
                        //     //rating
                        //     Positioned(
                        //       bottom: 0,
                        //       left: 0,
                        //       right: 0,
                        //       child: HStack(
                        //         [
                        //           Icon(
                        //             FlutterIcons.star_ant,
                        //             size: 14,
                        //             color: Utils.textColorByTheme(),
                        //           ),
                        //           UiSpacer.hSpace(2),
                        //           //
                        //           "${order.driver?.rating}"
                        //               .text
                        //               .sm
                        //               .color(Utils.textColorByTheme())
                        //               .make(),
                        //         ],
                        //         crossAlignment: CrossAxisAlignment.center,
                        //         alignment: MainAxisAlignment.center,
                        //       )
                        //           .pSymmetric(v: 2, h: 6)
                        //           .box
                        //           .roundedLg
                        //           .color(AppColor.ratingColor)
                        //           .makeCentered(),
                        //     ),
                        //   ],
                        // ),
                        // UiSpacer.hSpace(12),

                        VStack(
                          [
                            UiSpacer.hSpace(8),
                            "${order.driver?.name}".text.medium.xl.make(),
                            "Phone ${order.driver?.phone}".text.medium.sm .make(),

                            VxRating(
                              isSelectable: false,
                              onRatingUpdate: (value) {},
                              maxRating: 5.0,
                              count: 5,
                              value: order.driver?.rating ?? 0.0,
                              selectionColor: AppColor.ratingColor,
                            ),
                          ],
                        ).expand(),

                        if (AppUISettings.canDriverChat)
                          GestureDetector(onTap: (){
                            vm.chatDriver();
                          },child: Container(padding: EdgeInsets.symmetric(horizontal: 24,vertical: 7),decoration: BoxDecoration(color: AppColor.primaryColor,borderRadius: BorderRadius.circular(10)),child: Text("Chat",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),))

                      ],
                      crossAlignment: CrossAxisAlignment.center,
                    ),
                  ),
                  //vehicle info
                  Visibility(
                    visible: order.driver?.vehicle != null,
                    child: VStack(
                      [
                        DottedLine(
                          direction: Axis.horizontal,
                          lineThickness: 2,
                          dashGapLength: 3,
                          dashColor: Color(0xffC70774),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                            "Booking/Verification Code".tr().text.light.italic.lg.make(),
                            "${order.verificationCode}".text.color(AppColor.primaryColor).xl.semiBold.make(),
                          ],),
                        )



                        // HStack(
                        //   [
                        //     "${order.driver?.vehicle?.carMake} - ${order.driver?.vehicle?.carModel}"
                        //         .text
                        //         .medium
                        //         .make(),
                        //     UiSpacer.expandedSpace(),
                        //     "${order.driver?.vehicle?.reg_no}"
                        //         .text
                        //         .lg
                        //         .semiBold
                        //         .make(),
                        //   ],
                        // ),
                      ],
                    ),
                  ),

                  //has driver been rated
                  Visibility(
                    visible: order.canRateDriver,
                    child: VStack(
                      [
                        //rate driver button with action
                        UiSpacer.divider().py8(),
                        CustomButton(
                          title: "Rate Driver".tr(),
                          onPressed: rateDriverAction,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).make(),
        )
        : 0.heightBox;
  }
}
