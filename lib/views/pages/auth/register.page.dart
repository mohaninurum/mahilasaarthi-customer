import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icon.dart';
import 'package:mahilasaarthi/constants/app_colors.dart';
import 'package:mahilasaarthi/constants/app_images.dart';
import 'package:mahilasaarthi/constants/app_strings.dart';
import 'package:mahilasaarthi/services/validator.service.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/view_models/register.view_model.dart';
import 'package:mahilasaarthi/widgets/base.page.dart';
import 'package:mahilasaarthi/widgets/buttons/custom_button.dart';
import 'package:mahilasaarthi/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../services/auth.service.dart';
import '../../../view_models/profile.vm.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({
    this.email,
    this.name,
    this.phone,
    Key? key,
  }) : super(key: key);

  final String? email;
  final String? name;
  final String? phone;
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.reactive(
      viewModelBuilder: () => RegisterViewModel(context),
      onViewModelReady: (model) {
        model.nameTEC.text = widget.name ?? "";
        model.emailTEC.text = widget.email ?? "";
        model.phoneTEC.text = widget.phone ?? "";
        model.initialise();
      },
      builder: (context, model, child) {
        return BasePage(
          showLeadingAction: true,

          showAppBar: false,
          body: Padding(
            padding: EdgeInsets.only(bottom: context.mq.viewInsets.bottom),
            child: VStack(
              [
                // Image.asset(
                //   AppImages.onboarding2,
                // ).hOneForth(context).centered(),

                Container(height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin:Alignment.bottomLeft ,end:  Alignment.topRight,colors: [Color(0xffC70774),Color(0xff610339)]),
                    color: AppColor.primaryColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 35,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              FlutterIcons.arrow_left_bold_mco,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            child: InkWell(
                              onTap: () {
                                ProfileViewModel(context).changeLanguage();
                              },
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,

                              child: Container(child: Row(children: [
                                Icon(Icons.language,color: Colors.white,size: 20,),
                                SizedBox(width: 5,),
                                Text(AuthServices.getLocale(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                SizedBox(width: 5,),
                                Icon(Icons.keyboard_arrow_down_outlined,color: Colors.white,size: 20,)

                              ],),padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6 ),decoration: BoxDecoration(color: Colors.transparent,border: Border.all(color: Colors.white),borderRadius: BorderRadius.circular(8)),),
                            ),
                          )
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: HStack(
                          [

                            VStack(
                              [
                                "Join Us".tr().text.xl3.bold.white.make(),
                                "Create an account now".tr().text.light.white.make(),
                              ],
                            ).expand(),
                            Image.asset(
                              AppImages.appLogo,
                            )
                                .h(60)
                                .w(60)
                                .box
                                .roundedFull
                                .clip(Clip.antiAlias)
                                .make(),
                            SizedBox(width: 10,),
                          ],
                        ),
                      ),
                    ],
                  ),),

                //
                VStack(
                  [
                    //
                    // "Join Us".tr().text.xl2.semiBold.make(),
                    // "Create an account now".tr().text.light.make(),

                    //form
                    Form(
                      key: model.formKey,
                      child: VStack(
                        [
                          //
                          CustomTextFormField(
                            labelText: "Name".tr(),
                            textEditingController: model.nameTEC,
                            validator: FormValidator.validateName,
                          ).py8(),
                          //
                          CustomTextFormField(
                            labelText: "Email".tr(),
                            keyboardType: TextInputType.emailAddress,
                            textEditingController: model.emailTEC,
                            validator: FormValidator.validateEmail,
                            //remove space
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                RegExp(' '),
                              ), // removes spaces
                            ],
                          ).py8(),
                          //
                          HStack(
                            [
                              CustomTextFormField(
                                prefixIcon: HStack(
                                  [
                                    //icon/flag
                                    Flag.fromString(
                                      model.selectedCountry!.countryCode,
                                      width: 20,
                                      height: 20,
                                    ),
                                    UiSpacer.horizontalSpace(space: 5),
                                    //text
                                    ("+" + model.selectedCountry!.phoneCode)
                                        .text
                                        .make(),
                                  ],
                                ).px8().onInkTap(model.showCountryDialPicker),
                                labelText: "Phone".tr(),
                                hintText: "",
                                keyboardType: TextInputType.phone,
                                textEditingController: model.phoneTEC,
                                validator: FormValidator.validatePhone,
                                //remove space
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                    RegExp(' '),
                                  ), // removes spaces
                                ],
                              ).expand(),
                            ],
                          ).py8(),
                          //
                          CustomTextFormField(
                            labelText: "Password".tr(),
                            obscureText: true,
                            textEditingController: model.passwordTEC,
                            validator: FormValidator.validatePassword,
                            //remove space
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                RegExp(' '),
                              ), // removes spaces
                            ],
                          ).py8(),
                          //
                          AppStrings.enableReferSystem
                              ? CustomTextFormField(
                                  labelText: "Referral Code(optional)".tr(),
                                  textEditingController:
                                      model.referralCodeTEC,
                                ).py8()
                              : UiSpacer.emptySpace(),

                          //terms
                          SizedBox(height: 10,),
                          HStack(
                            [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  side: MaterialStateBorderSide.resolveWith(
                                        (states) => BorderSide(width: 1.0, color: AppColor.primaryColor),
                                  ),
                                  focusColor: Colors.white,
                                  activeColor: AppColor.primaryColor,
                                  value: model.agreed,
                                  onChanged: (value) {
                                    model.agreed = value ?? false;
                                    model.notifyListeners();
                                  },
                                ),
                              ),
                              SizedBox(width: 7,),
                              //
                              "I agree with".tr().text.make(),
                              UiSpacer.horizontalSpace(space: 2),
                              "Terms & Conditions"
                                  .tr()
                                  .text
                                  .color(AppColor.primaryColor)
                                  .bold
                                  .underline
                                  .make()
                                  .onInkTap(model.openTerms)
                                  .expand(),
                            ],
                          ),
                          SizedBox(height: 10,),

                          //
                          // CustomButton(
                          //   title: "Create Account".tr(),
                          //   loading: model.isBusy,
                          //   onPressed: model.processRegister,
                          // ).centered().py12(),
                          SizedBox(height: 12,),
                          InkWell(
                            onTap: () {model.processRegister();},

                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            child: Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0xffC70774),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(child: Text("Create Account".tr(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),)),

                            ).centered(),
                          ),

                          //register
                          // "OR".tr().text.light.makeCentered(),
                          "Already have an Account"
                              .tr()
                              .text
                              .semiBold
                              .makeCentered()
                              .py12()
                              .onInkTap(model.openLogin),
                        ],
                        crossAlignment: CrossAxisAlignment.end,
                      ),
                    ),
                  ],
                ).wFull(context).p20(),

                //
              ],
            ).scrollVertical(),
          ),
        );
      },
    );
  }
}
