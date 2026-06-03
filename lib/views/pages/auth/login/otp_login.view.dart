import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:mahilasaarthi/services/validator.service.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/view_models/login.view_model.dart';
import 'package:mahilasaarthi/widgets/buttons/custom_button.dart';
import 'package:mahilasaarthi/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OTPLoginView extends StatelessWidget {
  const OTPLoginView(this.model, {Key? key}) : super(key: key);

  final LoginViewModel model;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: model.otpFormKey,
      child: VStack(
        [
          //
          HStack(
            [
              CustomTextFormField(

                prefixIcon: HStack(
                  [
                    //icon/flag
                    Flag.fromString(
                      model.selectedCountry?.countryCode ?? "us",
                      width: 20,
                      height: 20,
                    ),
                    UiSpacer.horizontalSpace(space: 5),
                    //text
                    ("+" + (model.selectedCountry?.phoneCode ?? "1"))
                        .text
                        .make(),
                  ],
                ).px8().onInkTap(model.showCountryDialPicker),
                labelText: "Phone".tr(),
                hintText: "",
                keyboardType: TextInputType.phone,
                textEditingController: model.phoneTEC,
                validator: FormValidator.validatePhone,
              ).expand(),
            ],
          ).py12(),
          //
          SizedBox(height: 12,),
          InkWell(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {model.processOTPLogin();},
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
             color: Color(0xffC70774),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(child: Text("Login".tr(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),)),

            ).centered(),
          ),
        ],
        crossAlignment: CrossAxisAlignment.end,
      ).scrollVertical(),
    ).py20();
  }
}
