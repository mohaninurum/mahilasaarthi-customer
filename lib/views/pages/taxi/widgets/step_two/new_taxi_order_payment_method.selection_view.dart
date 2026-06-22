import 'package:flutter/material.dart';
import 'package:mahilasaarthi/view_models/taxi_new_order_summary.vm.dart';
import 'package:mahilasaarthi/widgets/custom_image.view.dart';
import 'package:mahilasaarthi/widgets/directional_chevron.dart';
import 'package:velocity_x/velocity_x.dart';

class NewTaxiOrderPaymentMethodSelectionView extends StatelessWidget {
  const NewTaxiOrderPaymentMethodSelectionView({
    required this.vm,
    Key? key,
  }) : super(key: key);

  final NewTaxiOrderSummaryViewModel vm;
  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        CustomImage(
          imageUrl: vm.taxiViewModel.selectedPaymentMethod!.photo,
        ).wh(40, 40),
        "${vm.taxiViewModel.selectedPaymentMethod!.name}"
            .text
            .make()
            .px12()
            .expand(),
        DirectionalChevron(),
      ],
    )
        .onInkTap(
          vm.openPaymentMethodSelection,
        )
        .box
        .roundedSM
        .color(context.theme.brightness == Brightness.dark ? Colors.grey[800]! : Colors.grey[200]!)
        .px8
        .make();
  }
}
