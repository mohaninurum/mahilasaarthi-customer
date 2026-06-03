import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mahilasaarthi/constants/app_colors.dart';
import 'package:mahilasaarthi/constants/app_strings.dart';
import 'package:mahilasaarthi/extensions/string.dart';
import 'package:mahilasaarthi/models/order.dart';
import 'package:mahilasaarthi/utils/utils.dart';
import 'package:mahilasaarthi/widgets/currency_hstack.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:timelines/timelines.dart';
import 'package:velocity_x/velocity_x.dart';

class BasicTaxiTripInfoView extends StatelessWidget {
  BasicTaxiTripInfoView(this.order, {Key? key}) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return VxBox(
      child: VStack(
        [
          //date, code, amount
          HStack(
            [
              VStack(
                [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4,horizontal: 6),
                    decoration: BoxDecoration(color: Color(0xffF0F0F0),borderRadius: BorderRadius.circular(5)),
                    child: Row(mainAxisSize: MainAxisSize.min,children: [
                      Icon(Icons.calendar_month,color: AppColor.primaryColor,size: 18,),
                      SizedBox(width: 5,),
                      "${DateFormat("dd MMM y").format(order.createdAt)}"
                          .text
                          .medium
                          .sm
                          .make(),
                      SizedBox(width: 8,),
                      Icon(Icons.access_time_outlined,color: AppColor.primaryColor,size: 18,),
                      SizedBox(width: 5,),
                      "${DateFormat("H:m a").format(order.createdAt)}"
                          .text
                          .medium
                          .sm
                          .make(),
                    ],),
                  ),


                 SizedBox(height: 8,),
                  CurrencyHStack(
                    [
                      "${order.taxiOrder!.currency != null ? order.taxiOrder!.currency!.symbol : AppStrings.currencySymbol}"
                          .text
                          .semiBold
                          .xl.color(Color(0xff610339))
                          .make(),
                      "${(order.total ?? 0.00).currencyValueFormat()}"
                          .text
                          .semiBold
                          .xl2.color(Color(0xff610339))
                          .make()
                    ],
                  ),
                ],
              ).expand(),
              //total amount
              VStack(
                [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6,horizontal: 15),
                    decoration: BoxDecoration(color: Color(0xffC70774).withOpacity(0.2),borderRadius: BorderRadius.circular(15)),
                    child:order.Taxistatus.tr()
                        .text
                        .color(Color(0xffC70774))
                        .medium
                        .xl
                        .make(),
                  ),

                ],
                crossAlignment: CrossAxisAlignment.end,
                alignment: MainAxisAlignment.end,
              ),
            ],
            crossAlignment: CrossAxisAlignment.start,
          ),
          //pickup/dropoff
          Timeline.tileBuilder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            builder: TimelineTileBuilder.connected(
              itemCount: 2,
              contentsAlign: ContentsAlign.basic,
              nodePositionBuilder: (context, index) => 0.00,
              indicatorBuilder: (context, index) {
                return DotIndicator(
                  color: AppColor.primaryColor,
                  size: 38,
                  child: Icon(
                    index == 0
                        ? FlutterIcons.my_location_mdi
                        : FlutterIcons.location_pin_ent,
                    size: 30,
                    color: Utils.textColorByTheme(),
                  ).p4(),
                );
              },
              connectorBuilder: (context, index, connectorType) {
                return DashedLineConnector(
                  color: AppColor.primaryColor,
                  gap: 3,
                  space: 2,
                  indent: 5,
                );
              },
              contentsBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                  decoration: BoxDecoration(color: Color(0xffF0F0F0),borderRadius: BorderRadius.circular(10)),
                  child: VStack(
                    [
                      //if created at is not null
                      Text(
                        index == 0
                            ? "Pickup Location".tr()
                            : "Drop Off Location".tr(),
                        style: context.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColor.primaryColor
                        ),
                      ),
                      Text(
                        index == 0
                            ? order.taxiOrder!.pickupAddress
                            : order.taxiOrder!.dropoffAddress,
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ).p(Vx.dp20);
              },
            ),
          ),
        ],
      ).px20().py12(),
    ).make();
  }
}
