import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mahilasaarthi/services/validator.service.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/view_models/delivery_address/new_delivery_addresses.vm.dart';
import 'package:mahilasaarthi/views/pages/delivery_address/widgets/what3words.view.dart';
import 'package:mahilasaarthi/widgets/base.page.dart';
import 'package:mahilasaarthi/widgets/buttons/custom_button.dart';
import 'package:mahilasaarthi/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../utils/utils.dart';

class NewDeliveryAddressesPage extends StatelessWidget {
  const NewDeliveryAddressesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewDeliveryAddressesViewModel>.reactive(
      viewModelBuilder: () => NewDeliveryAddressesViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: false,
          showLeadingAction: true,
          title: "New Delivery Address".tr(),
          body: Form(
              key: vm.formKey,
              child: VStack(
                [

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
                      "New Delivery Address".tr().text.xl2.semiBold.white.make(),
                    ],)
                  ],),),
                  SizedBox(height: 15,),
                  //
                  CustomTextFormField(
                    labelText: "Name".tr(),
                    textEditingController: vm.nameTEC,
                    validator: FormValidator.validateName,
                  ).px(15),
                  //what3words
                  What3wordsView(vm),
                  //
                  CustomTextFormField(
                    labelText: "Address".tr(),
                    isReadOnly: true,
                    textEditingController: vm.addressTEC,
                    validator: (value) => FormValidator.validateEmpty(value,
                        errorTitle: "Address".tr()),
                    onTap: vm.openLocationPicker,
                  ).py2().px(15),
                  // description
                  UiSpacer.verticalSpace(space: 10),
                  CustomTextFormField(
                    labelText: "Description".tr(),
                    textEditingController: vm.descriptionTEC,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    textInputAction: TextInputAction.newline,
                  ).py2().px(15),
                  //
                  HStack(
                    [
                      Checkbox(
                        side: BorderSide(width: 0.5),
                        value: vm.isDefault,
                        onChanged: vm.toggleDefault,
                      ),
                      //
                      "Default".tr().text.make(),
                    ],
                  )
                      .onInkTap(
                        () => vm.toggleDefault(!vm.isDefault),
                      )
                      .wFull(context)
                      .py12().px(5),

                  CustomButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    isFixedHeight: true,
                    height: Vx.dp48,
                    title: "Save".tr(),
                    onPressed: vm.saveNewDeliveryAddress,
                    loading: vm.isBusy,
                  ).px(15).centered(),
                ],
              )
                    .scrollVertical()
                  .pOnly(bottom: context.mq.viewInsets.bottom)),
        );
      },
    );
  }
}
