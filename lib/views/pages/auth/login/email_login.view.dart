import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mahilasaarthi/services/validator.service.dart';
import 'package:mahilasaarthi/view_models/login.view_model.dart';
import 'package:mahilasaarthi/widgets/buttons/custom_button.dart';
import 'package:mahilasaarthi/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class EmailLoginView extends StatelessWidget {
  const EmailLoginView(this.model, {Key? key}) : super(key: key);

  final LoginViewModel model;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: model.emailFormKey,
      child: VStack(
        [
          //
          CustomTextFormField(
            labelText: "Email".tr(),
            keyboardType: TextInputType.emailAddress,
            textEditingController: model.emailTEC,
            validator: FormValidator.validateEmail,
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                RegExp(' '),
              ),
            ],
          ).py12(),
          CustomTextFormField(
            labelText: "Password".tr(),
            obscureText: true,
            textEditingController: model.passwordTEC,
            validator: FormValidator.validatePassword,
          ).py12(),

          //
          "Forgot Password ?".tr().text.underline.make().onInkTap(
                model.openForgotPassword,
              ),
          //
          // CustomButton(
          //   title: "Login".tr(),
          //   loading: model.isBusy,
          //   onPressed: model.processLogin,
          // ).centered().py12(),
          SizedBox(height: 12,),
          InkWell(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {model.processLogin();},
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
    ).py12();
  }
}
