import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mahilasaarthi/constants/app_colors.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/view_models/delivery_address/delivery_addresses.vm.dart';
import 'package:mahilasaarthi/widgets/base.page.dart';
import 'package:mahilasaarthi/widgets/custom_list_view.dart';
import 'package:mahilasaarthi/widgets/list_items/delivery_address.list_item.dart';
import 'package:mahilasaarthi/widgets/states/delivery_address.empty.dart';
import 'package:mahilasaarthi/widgets/states/error.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../utils/utils.dart';

class DeliveryAddressesPage extends StatelessWidget {
  const DeliveryAddressesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeliveryAddressesViewModel>.reactive(
      viewModelBuilder: () => DeliveryAddressesViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: false,
          showLeadingAction: true,
          title: "Delivery Addresses".tr(),
          isLoading: vm.isBusy,
          fab: FloatingActionButton(
            backgroundColor: AppColor.primaryColor,
            child: Icon(
              FlutterIcons.plus_ant,
              color: Colors.white,
            ),
            onPressed: vm.newDeliveryAddressPressed,
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xffC70774),Color(0xff610339)],begin:Alignment.bottomLeft ,end:  Alignment.topRight)
                ),height: 100,width: double.infinity,child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                SizedBox(height: 45,),
                Row(children: [
                  IconButton(
                    icon: Icon(
                      !Utils.isArabic
                          ? FlutterIcons.arrow_left_fea
                          : FlutterIcons.arrow_right_fea,
                      color:Colors.white
                      ,
                    ),
                    onPressed:  () => Navigator.pop(context),
                  ),
                  SizedBox(width: 15,),
                  "Delivery Address".tr().text.xl2.semiBold.white.make(),
                ],)
              ],),),
              CustomListView(
                padding:
                    EdgeInsets.fromLTRB(20, 20, 20, context.percentHeight * 20),
                dataSet: vm.deliveryAddresses,
                isLoading: vm.busy(vm.deliveryAddresses),
                emptyWidget: EmptyDeliveryAddress(),
                errorWidget: LoadingError(
                  onrefresh: vm.fetchDeliveryAddresses,
                ),
                itemBuilder: (context, index) {
                  //
                  final deliveryAddress = vm.deliveryAddresses[index];
                  //
                  return DeliveryAddressListItem(
                    deliveryAddress: deliveryAddress,
                    onEditPressed: () => vm.editDeliveryAddress(deliveryAddress),
                    onDeletePressed: () =>
                        vm.deleteDeliveryAddress(deliveryAddress),
                  );
                },
                separatorBuilder: (context, index) =>
                    UiSpacer.verticalSpace(space: 10),
              ),
            ],
          ),
        );
      },
    );
  }
}
