import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:mahilasaarthi/constants/app_colors.dart';
import 'package:mahilasaarthi/constants/app_images.dart';
import 'package:mahilasaarthi/constants/app_strings.dart';
import 'package:mahilasaarthi/extensions/string.dart';
import 'package:mahilasaarthi/models/order.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/widgets/currency_hstack.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class TaxiOrderListItem extends StatelessWidget {
  const TaxiOrderListItem({
    required this.order,
    this.onPayPressed,
    required this.orderPressed,
    Key? key,
  }) : super(key: key);

  final Order order;
  final Function? onPayPressed;
  final Function orderPressed;
  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = order.taxiOrder?.currency != null
        ? order.taxiOrder?.currency?.symbol
        : AppStrings.currencySymbol;
    //
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DottedBorder(
        padding: EdgeInsets.zero,
        radius: Radius.circular(10),
        borderPadding: EdgeInsets.zero,
        borderType: BorderType.RRect,strokeWidth: 2,strokeCap: StrokeCap.butt,
        color: Color(0xffC70774),
        // decoration: BoxDecoration(border: Border.all(color: Color(0xffC70774),style: BorderStyle.solid)),
        child: VStack(
          [
            //
            VStack(
              [
                //
                HStack(
                  [
                    Image.asset(AppImages.pickupLocation).wh(12, 12),
                    UiSpacer.horizontalSpace(space: 10),
                    "${order.taxiOrder?.pickupAddress}"
                        .text
                        .medium.color(Color(0xffC70774))
                        .overflow(TextOverflow.ellipsis)
                        .make()
                        .expand(),
                  ],
                ),
                DottedLine(
                  direction: Axis.vertical,
                  lineThickness: 2,
                  dashGapLength: 1,
                  dashColor: Color(0xffC70774),
                ).wh(1, 15).px4(),
                HStack(
                  [
                    Image.asset(AppImages.dropoffLocation).wh(12, 12),
                    UiSpacer.horizontalSpace(space: 10),
                    "${order.taxiOrder?.dropoffAddress}"
                        .text
                        .medium.color(Color(0xffC70774))
                        .overflow(TextOverflow.ellipsis)
                        .make()
                        .expand(),
                  ],
                ),
              ],
            ).p20(),
            DottedLine(
              direction: Axis.horizontal,
              lineThickness: 2,
              dashGapLength: 1,
              dashColor: Color(0xffC70774),
            ),
            //
            HStack(
              [
                //price
                CurrencyHStack(
                  [
                    "$currencySymbol ".text.semiBold.xl.color(Color(0xffC70774)).make(),
                    "${order.total.currencyValueFormat()}".text.semiBold.xl.color(Color(0xffC70774)).make()
                  ],
                ).expand(),
                //status
                "${order.Taxistatus}"
                    .tr()
                    .text.color(Color(0xffC70774)).color(Color(0xffC70774))
                    .make(),
              ],
            ).py8().px20(),
          ],
        )
            .onInkTap(
              () => orderPressed(),
            )
            // .card
            // .elevation(3)
            // .clip(Clip.antiAlias)
            // .roundedSM/
            // .make(),
      ),
    );
  }
}
