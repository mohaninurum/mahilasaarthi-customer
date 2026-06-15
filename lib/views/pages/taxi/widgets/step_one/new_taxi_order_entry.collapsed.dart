import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mahilasaarthi/constants/app_colors.dart';
import 'package:mahilasaarthi/constants/app_strings.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/view_models/taxi.vm.dart';
import 'package:mahilasaarthi/view_models/taxi_new_order_location_entry.vm.dart';
import 'package:mahilasaarthi/widgets/busy_indicator.dart';
import 'package:mahilasaarthi/widgets/cards/custom.visibility.dart';
import 'package:mahilasaarthi/widgets/custom_list_view.dart';
import 'package:mahilasaarthi/widgets/list_items/taxi_order_location_history.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:measure_size/measure_size.dart';
import 'package:velocity_x/velocity_x.dart';

class NewTaxiOrderEntryCollapsed extends StatelessWidget {
  const NewTaxiOrderEntryCollapsed(this.taxiNewOrderViewModel, {Key? key})
      : super(key: key);

  final NewTaxiOrderLocationEntryViewModel taxiNewOrderViewModel;

  @override
  Widget build(BuildContext context) {
    final TaxiViewModel vm = taxiNewOrderViewModel.taxiViewModel;
    //
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
      child: MeasureSize(
        onChange: (size) {
          vm.updateGoogleMapPadding(
              height: taxiNewOrderViewModel.customViewHeight + 30);
        },
        child: VxBox(
          child: vm.isBusy
              ? BusyIndicator().centered().p20()
              : VStack(
                  [
                    UiSpacer.swipeIndicator(),
                    UiSpacer.vSpace(),
                    HStack(
                      [
                        Icon(
                          FlutterIcons.location_pin_ent,
                          size: 24,
                          color: AppColor.primaryColor,
                        ),
                        "Where to?".tr().text.semiBold.lg.color(Color(0xff9F9F9F)).make().px8().expand(),
                        CustomVisibilty(
                          visible: AppStrings.canScheduleTaxiOrder,
                          child: Icon(
                            FlutterIcons.calendar_ant,
                            size: 18,
                            color: AppColor.primaryColor,
                          )
                              .onInkTap(
                                taxiNewOrderViewModel.onScheduleOrderPressed,
                              )
                              .p2(),
                        ),
                      ],
                    )
                        .px16()
                        .py12()
                        .box
                        .color(context.theme.colorScheme.background)
                        .withRounded(value: 30)
                        .border(color: Color(0xffEEEEEE))
                        .make()
                        .onTap(
                          taxiNewOrderViewModel.onDestinationPressed,
                        ),
                    SizedBox(height: 5,),
                    //previous history
                    Padding(
                      padding: (taxiNewOrderViewModel
                              .shortPreviousAddressesList.isEmpty)
                          ? EdgeInsets.all(5)
                          : EdgeInsets.symmetric(vertical: 5),
                      child: CustomListView(
                        isLoading: taxiNewOrderViewModel.busy(
                          taxiNewOrderViewModel.previousAddresses,
                        ),
                        dataSet: taxiNewOrderViewModel.shortPreviousAddressesList,
                        noScrollPhysics: true,
                        padding: EdgeInsets.zero,
                        itemBuilder: (ctx, index) {
                          final orderAddressHistory = taxiNewOrderViewModel
                              .shortPreviousAddressesList[index];
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 14,vertical: 0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xffFAFAFA)),
                            child: TaxiOrderHistoryListItem(
                              orderAddressHistory,
                              onPressed:
                                  taxiNewOrderViewModel.onDestinationSelected,
                            ),
                          );
                        },
                        separatorBuilder: (ctx, index) => UiSpacer.divider(),
                      ),
                    ),
                  ],
                ).scrollVertical(),
        )
            .p20
            .color(context.theme.colorScheme.background)
            .topRounded(value: 25)
            .outerShadow2Xl
            .make(),
      ),
    );
  }
}
