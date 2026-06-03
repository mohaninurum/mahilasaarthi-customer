import 'package:flutter/material.dart';
import 'package:mahilasaarthi/constants/app_strings.dart';
import 'package:mahilasaarthi/extensions/string.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/view_models/taxi.vm.dart';
import 'package:mahilasaarthi/widgets/buttons/custom_button.dart';
import 'package:mahilasaarthi/widgets/currency_hstack.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:supercharged/supercharged.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderTaxiButton extends StatelessWidget {
  const OrderTaxiButton(this.vm, {Key? key}) : super(key: key);

  final TaxiViewModel vm;

  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = (vm.selectedVehicleType?.currency != null
        ? vm.selectedVehicleType?.currency?.symbol
        : AppStrings.currencySymbol);
    //
    return Visibility(
      visible: vm.selectedVehicleType != null,
      child: CustomButton(
        loading: vm.isBusy,
        child: HStack(
          [
            "Order Now".tr().text.medium.lg.color(Colors.white).make(),
            UiSpacer.hSpace(10),
            CurrencyHStack(
              [
                "${currencySymbol} ".text.semiBold.color(Colors.white).xl.make(),
                Visibility(
                  visible: (vm.subTotal > vm.total),
                  child: HStack(
                    [
                      "${vm.subTotal.currencyValueFormat()}"
                          .text
                          .medium
                          .lineThrough.color(Colors.white)
                          .make(),
                      "${vm.total.currencyValueFormat()}"
                          .text
                          .semiBold
                          .xl.color(Colors.white)
                          .make(),
                    ],
                  ),
                ),
                Visibility(
                  visible: !(vm.subTotal > vm.total),
                  child: "${(vm.total.currencyValueFormat().toDouble()!.toInt()).toString()}"
                      .text
                      .semiBold
                      .xl.color(Colors.white)
                      .make(),
                ),
              ],
            ),
          ],
        ),
        onPressed: vm.selectedVehicleType != null ? vm.processNewOrder : null,
      ).wFull(context),
    );
  }
}
