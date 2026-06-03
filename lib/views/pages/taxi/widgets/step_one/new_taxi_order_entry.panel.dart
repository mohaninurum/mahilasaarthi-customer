import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mahilasaarthi/constants/app_colors.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/view_models/taxi.vm.dart';
import 'package:mahilasaarthi/view_models/taxi_new_order_location_entry.vm.dart';
import 'package:mahilasaarthi/views/pages/taxi/widgets/step_one/new_taxi_order_schedule.view.dart';
import 'package:mahilasaarthi/views/pages/taxi/widgets/step_one/new_taxi_pick_on_map.view.dart';
import 'package:mahilasaarthi/widgets/busy_indicator.dart';
import 'package:mahilasaarthi/widgets/buttons/custom_button.dart';
import 'package:mahilasaarthi/widgets/custom_list_view.dart';
import 'package:mahilasaarthi/widgets/custom_timeline_connector.dart';
import 'package:mahilasaarthi/widgets/list_items/address.list_item.dart';
import 'package:mahilasaarthi/widgets/taxi_custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../../widgets/custom_text_form_field.dart';

class NewTaxiOrderEntryPanel extends StatelessWidget {
  const NewTaxiOrderEntryPanel(this.taxiNewOrderViewModel, {Key? key})
      : super(key: key);

  final NewTaxiOrderLocationEntryViewModel taxiNewOrderViewModel;

  @override
  Widget build(BuildContext context) {
    final TaxiViewModel vm = taxiNewOrderViewModel.taxiViewModel;
    return VxBox(
      child: vm.isBusy
          ? BusyIndicator().centered().p20()
          : VStack(
              [
                VStack(
                  [
                    //
                    HStack(
                      [
                        Icon(
                          FlutterIcons.close_ant,color: AppColor.primaryColor,
                        ).onTap(taxiNewOrderViewModel.closePanel),
                        "Your route".tr().text.bold.xl.make().px12().expand(),
                      ],
                    ),

                    UiSpacer.verticalSpace(),
                    //schedule order
                    NewTaxiOrderScheduleView(taxiNewOrderViewModel),
                    //entry
                    HStack(
                      [
                        //
                        CustomTimelineConnector(height: 50),
                        UiSpacer.hSpace(10),
                        //
                        VStack(
                          [
                            CustomTextFormField(
                              hintText: "Pickup Location".tr(),
                              textEditingController: vm.pickupLocationTEC,
                              focusNode: vm.pickupLocationFocusNode,
                              onChanged: taxiNewOrderViewModel.searchPlace,
                            ).py12(),

                            UiSpacer.vSpace(5),
                            CustomTextFormField(
                              hintText: "Drop-off Location".tr(),
                              textEditingController: vm.dropoffLocationTEC,
                              focusNode: vm.dropoffLocationFocusNode,
                              onChanged: taxiNewOrderViewModel.searchPlace,
                            ),
                          ],
                        ).expand(),
                      ],
                    ),
                  ],
                )
                    .p20()
                    .safeArea()

                    .color(context.theme.colorScheme.background)
                   ,
                SizedBox(height: 10,),
                //list of search result,
                CustomListView(
                  padding: EdgeInsets.zero,
                  isLoading:
                      taxiNewOrderViewModel.busy(taxiNewOrderViewModel.places),
                  dataSet: taxiNewOrderViewModel.places != null
                      ? taxiNewOrderViewModel.places!
                      : [],
                  itemBuilder: (contex, index) {
                    final place = taxiNewOrderViewModel.places![index];
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(horizontal: 14,vertical: 0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xffFAFAFA)),
                      child: AddressListItem(
                        place,
                        onAddressSelected:
                            taxiNewOrderViewModel.onAddressSelected,
                      ),
                    );
                  },
                  separatorBuilder: (ctx, index) => SizedBox(height: 8,),
                ).expand(),
                //select on map
                NewTaxiPickOnMapButton(
                  taxiNewOrderViewModel: taxiNewOrderViewModel,
                ),
                Visibility(
                  visible: !vm.pickupLocationFocusNode.hasFocus &&
                      !vm.dropoffLocationFocusNode.hasFocus,
                  child: CustomButton(
                    title: "Next".tr(),
                    onPressed: taxiNewOrderViewModel.moveToNextStep,
                  ).p8().safeArea(top: false),
                ),
              ],
            ),
    )
        .color(vm.isBusy
            ? context.theme.colorScheme.background.withOpacity(0.5)
            : context.theme.colorScheme.background)
        .make()
        .pOnly(bottom: context.mq.viewInsets.bottom);
  }
}
