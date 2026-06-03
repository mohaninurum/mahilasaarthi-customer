import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mahilasaarthi/constants/app_colors.dart';
import 'package:mahilasaarthi/constants/app_ui_settings.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/view_models/taxi.vm.dart';
import 'package:mahilasaarthi/views/pages/order/widgets/taxi_order_trip_verification.view.dart';
import 'package:mahilasaarthi/views/pages/taxi/widgets/driver_info.view.dart';
import 'package:mahilasaarthi/views/pages/taxi/widgets/safety.view.dart';
import 'package:mahilasaarthi/widgets/buttons/call.button.dart';
import 'package:mahilasaarthi/widgets/buttons/custom_text_button.dart';
import 'package:mahilasaarthi/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:measure_size/measure_size.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:timelines/timelines.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../utils/utils.dart';

class TaxiTripReadyView extends StatelessWidget {
  const TaxiTripReadyView(this.vm, {Key? key}) : super(key: key);
  final TaxiViewModel vm;
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      backdropColor: Colors.transparent,
      minHeight: 300,
      maxHeight: context.percentHeight * 70,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      ),
      panelBuilder: (sc) {
        return MeasureSize(
          onChange: (size) {
            vm.updateGoogleMapPadding(height: 320);
          },
          child: VStack(
            [
              //driver info
              // TaxiDriverInfoView(vm.onGoingOrderTrip!.driver!),
              
              Container(
                padding: EdgeInsets.only(right: 10,top: 10,bottom: 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10,),color: Color(0xff555555).withOpacity(0.1)),
                child: Row(children: [
                  VStack(
                    [
                      "${vm.onGoingOrderTrip?.driver?.name ?? ''}".text.medium.xl.make(),
                      //rating
                      VxRating(
                        size: 14,
                        maxRating: 5.0,
                        value: vm.onGoingOrderTrip?.driver?.rating ?? 0.0,
                        isSelectable: false,
                        onRatingUpdate: (value) {},
                        selectionColor: AppColor.ratingColor,
                      ),
                    ],
                  ).px12().expand(),
                
                  
                  VStack(
                    [
                      "${vm.onGoingOrderTrip?.driver?.vehicle?.reg_no ?? ''}".text.xl2.semiBold.make(),
                      "${vm.onGoingOrderTrip?.driver?.vehicle?.vehicleInfo ?? ''}".text.medium.sm.make(),
                    ],
                    crossAlignment: CrossAxisAlignment.end,
                  ),
                ],),
              ),
              SizedBox(height: 10,),
              //contact info
              HStack(
                [
                  //message box
                  if (AppUISettings.canDriverChat)
                    CustomTextFormField(
                      hintText: "Message".tr() +
                          " ${(vm.onGoingOrderTrip?.driver?.name ?? '')}",
                      isReadOnly: true,
                      onTap: vm.openTripChat,
                      suffixIcon: Container(
                        padding: EdgeInsets.all(8),
                        child: CallButton(
                          null,
                          phone: vm.onGoingOrderTrip?.driver?.phone,
                        ),
                      ),
                    ).expand(),
                  // if (AppUISettings.canCallDriver)
                  //   CallButton(
                  //     null,
                  //     phone: vm.onGoingOrderTrip?.driver!.phone,
                  //   ),
                  // UiSpacer.horizontalSpace(),
                  // Spacer(),
                  //call button
                
                ],
              ),

              // UiSpacer.divider().py12(),

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
                                ? "${vm.onGoingOrderTrip?.taxiOrder?.pickupAddress ?? ''}"
                                : "${vm.onGoingOrderTrip?.taxiOrder?.dropoffAddress ?? ''}",
                            style: context.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ).p(Vx.dp8);
                  },
                ),
              ),



              //trip location details
              // "Pickup Location".tr().text.sm.light.make(),
              // "${vm.onGoingOrderTrip?.taxiOrder?.pickupAddress}"
              //     .text
              //     .lg
              //     .medium
              //     .make(),
              // UiSpacer.verticalSpace(),
              // "Dropoff Location".tr().text.sm.light.make(),
              // "${vm.onGoingOrderTrip?.taxiOrder?.dropoffAddress}"
              //     .text
              //     .lg
              //     .medium
              //     .make(),

              // UiSpacer.divider().py12(),

              //trip codes
              // TaxiOrderTripVerificationView(vm.onGoingOrderTrip!),
                 SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10,),color: Color(0xff555555).withOpacity(0.1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Booking/Verification Code".tr().text.light.italic.lg.make(),
                    "${vm.onGoingOrderTrip?.verificationCode ?? ''}".text.xl.bold.make(),
                  ],
                ),
              ),
              SizedBox(height: 10,),


              // UiSpacer.divider().py12(),
              //emergency
              SafetyView(),
              // UiSpacer.verticalSpace(),
              // UiSpacer.divider().py12(),
              //cancel order button
              //only show if driver is yet to be assigned
              SizedBox(height: 10,),


              Visibility(
                visible: vm.onGoingOrderTrip?.canCancelTaxi ?? false,
                child:InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: vm.cancelTrip,
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xffC70774),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: Text("Cancel Booking".tr(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),)),

                  ).centered(),
                ),


                // CustomTextButton(
                //   title: "Cancel Booking".tr(),
                //   titleColor: AppColor.getStausColor("failed"),
                //   loading: vm.busy(vm.onGoingOrderTrip),
                //   onPressed: vm.cancelTrip,
                // ).centered(),
              ),
            ],
          )
              .p20()
              .scrollVertical(controller: sc)
              .box
              .color(context.theme.colorScheme.background)
              .topRounded(value: 30)
              .shadow5xl
              .make(),
        );
      },
      // panel:,
      // ),
    );
  }
}
