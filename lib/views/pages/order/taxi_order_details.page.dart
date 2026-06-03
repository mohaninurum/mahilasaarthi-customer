import 'package:dotted_line/dotted_line.dart';
import 'package:firestore_chat/models/chat_entity.dart';
import 'package:firestore_chat/models/peer_user.dart';
import 'package:flutter/material.dart';
import 'package:mahilasaarthi/extensions/string.dart';
import 'package:mahilasaarthi/models/order.dart';
import 'package:mahilasaarthi/constants/app_strings.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/view_models/order_details.vm.dart';
import 'package:mahilasaarthi/views/pages/cart/widgets/amount_tile.dart';
import 'package:mahilasaarthi/views/pages/order/widgets/basic_taxi_trip_info.view.dart';
import 'package:mahilasaarthi/views/pages/order/widgets/order_payment_info.view.dart';
import 'package:mahilasaarthi/views/pages/order/widgets/order_driver_info.view.dart';
import 'package:mahilasaarthi/views/pages/order/widgets/taxi_order_trip_verification.view.dart';
import 'package:mahilasaarthi/widgets/base.page.dart';
import 'package:mahilasaarthi/widgets/cards/order_summary.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_ui_settings.dart';
import '../../../requests/auth.request.dart';
import '../../../services/auth.service.dart';
import '../../../services/chat.service.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_text_form_field.dart';
import 'widgets/taxi_trip_map.preview.dart';

class TaxiOrderDetailPage extends StatefulWidget {
  const TaxiOrderDetailPage({
    required this.order,
    Key? key,
  }) : super(key: key);

  //
  final Order order;

  @override
  _TaxiOrderDetailPageState createState() => _TaxiOrderDetailPageState();
}

class _TaxiOrderDetailPageState extends State<TaxiOrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderDetailsViewModel>.reactive(
      viewModelBuilder: () => OrderDetailsViewModel(context, widget.order),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        //
        print("Order Status : "+ vm.order.status .toString());

        String currencySymbol = vm.order.taxiOrder!.currencySymbol;

        //
        return BasePage(
          title: "Trip Details".tr(),
          elevation: 0,
          showAppBar: true,
          showLeadingAction: true,
          isLoading: vm.isBusy,
          backgroundColor: Colors.white,
          body: VStack(
            [
              //taxi trip map preview
              TaxiTripMapPreview(vm.order),
              //basic info
              BasicTaxiTripInfoView(vm.order),
              UiSpacer.vSpace(),

              //payment status
              OrderPaymentInfoView(vm),

              //driver
              OrderDriverInfoView(
                vm.order,
                rateDriverAction: vm.rateDriver,
                vm: vm,
              ),
SizedBox(height: 20,),
              //trip codes
              // TaxiOrderTripVerificationView(vm.order),

              vm.order.status.toString().lowerCamelCase  != "cancelled"  && vm.order.status.toString().lowerCamelCase  != "pending" ?
           Align(alignment: Alignment.centerRight,child: GestureDetector(onTap: () async {
             print(widget.order.driver!.phone.toString());
             print((await AuthServices.getCurrentUser()).phone.toString());
             String CustomerPhone = (await AuthServices.getCurrentUser()).phone.toString();
             String DriverPhone = widget.order.driver!.phone.toString();
                Utils.showLoadingDialog(context);
                await AuthRequest().CallDriverApi((DriverPhone.toString().contains("+91")) ?(DriverPhone.toString().substring(3,DriverPhone.length)) : DriverPhone, (CustomerPhone.toString().contains("+91")) ?(CustomerPhone.toString().substring(3,CustomerPhone.length)) : CustomerPhone);
                Navigator.pop(context);
              },child: Container(decoration: BoxDecoration(color: AppColor.primaryColor),padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),child: Center(child: Text("Call",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),)),)))
               : Center()
              ,
              //order summary
              OrderSummary(
                subTotal: vm.order.subTotal!,
                discount: vm.order.discount ?? 0,
                driverTip: vm.order.tip ?? 0,
                total: vm.order.total!,
                mCurrencySymbol:
                    "${vm.order.taxiOrder!.currency != null ? vm.order.taxiOrder!.currency!.symbol : AppStrings.currencySymbol}",
                //
                customWidget: VStack(
                  [
                    AmountTile(
                      "Base Fare".tr(),
                      "${currencySymbol} ${vm.order.taxiOrder!.base_fare ?? 0}"
                          .currencyFormat(currencySymbol),
                    ).py2(),
                    AmountTile(
                      ("Trip Distance".tr() + " (Km)"),
                      ("${vm.order.taxiOrder!.trip_distance ?? 0} " +
                          "(${vm.order.taxiOrder!.distance_fare ?? 0}/Km)"),
                    ).py2(),
                    AmountTile(
                      "Trip Duration".tr(),
                      ("${vm.order.taxiOrder!.trip_time ?? 0} " +
                          "(${vm.order.taxiOrder!.time_fare ?? 0}/Minute)"),
                    ).py2(),
                    DottedLine(dashColor: AppColor.primaryColor)
                        .py8(),
                  ],
                ),
              )
                  ,
              UiSpacer.vSpace(),
            ],
          ).scrollVertical(),
        );
      },
    );
  }

}
