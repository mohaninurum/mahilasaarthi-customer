import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mahilasaarthi/constants/app_colors.dart';
import 'package:mahilasaarthi/constants/app_images.dart';
import 'package:mahilasaarthi/constants/app_strings.dart';
import 'package:mahilasaarthi/services/auth.service.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/view_models/login.view_model.dart';
import 'package:mahilasaarthi/views/pages/auth/login/compain_login_type.view.dart';
import 'package:mahilasaarthi/views/pages/auth/login/email_login.view.dart';
import 'package:mahilasaarthi/views/pages/auth/login/otp_login.view.dart';
import 'package:mahilasaarthi/views/pages/auth/login/social_media.view.dart';
import 'package:mahilasaarthi/widgets/base.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../view_models/profile.vm.dart';
import '../../../widgets/buttons/custom_button.dart';
import 'login/scan_login.view.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.required = false, Key? key}) : super(key: key);

  final bool required;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool useOTP = true;
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            if (widget.required) {
              context.pop();
            }
            return true;
          },
          child: BasePage(
            showLeadingAction: !widget.required,
            showAppBar: false,
            appBarColor: AppColor.primaryColor,
            leading: IconButton(
              icon: Icon(
                FlutterIcons.arrow_left_fea,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Login",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            isLoading: model.isBusy,
            body: Column(
              children: [
                SizedBox(
                  height: 225,
                  child: Stack(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [Color(0xffC70774), Color(0xff610339)]),
                          color: AppColor.primaryColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 35,
                            ),
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
                                      ProfileViewModel(context)
                                          .changeLanguage();
                                    },
                                    splashColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.language,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            AuthServices.getLocale(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: Colors.white,
                                            size: 20,
                                          )
                                        ],
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 6),
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
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
                                      "Welcome Back"
                                          .tr()
                                          .text
                                          .xl3
                                          .bold
                                          .white
                                          .make(),
                                      "Login to continue"
                                          .tr()
                                          .text
                                          .light
                                          .white
                                          .make(),
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
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: CustomSlidingSegmentedControl<int>(
                            isStretch: true,
                            initialValue: 1,
                            padding: 10,
                            children: {
                              1: Text("Phone Number".tr(),
                                  style: TextStyle(
                                      color: !useOTP
                                          ? Colors.black
                                          : Colors.white)),
                              2: Text("Email Address".tr(),
                                  style: TextStyle(
                                      color: useOTP
                                          ? Colors.black
                                          : Colors.white)),
                            },
                            decoration: BoxDecoration(
                              color: context.theme.colorScheme.background,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.fromBorderSide(
                                BorderSide(
                                  color: AppColor.primaryColor,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            thumbDecoration: BoxDecoration(
                              // color: AppColor.primaryColor,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Color(0xffC70774),
                                    Color(0xff610339)
                                  ]),
                              borderRadius: BorderRadius.circular(20),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(.4),
                              //     blurRadius: 5.0,
                              //     spreadRadius: 1.5,
                              //     offset: Offset(
                              //       0.0,
                              //       2.0,
                              //     ),
                              //   ),
                              // ],
                            ),
                            duration: Duration(milliseconds: 400),
                            // customSegmentSettings: CustomSegmentSettings(
                            //   highlightColor: Colors.red,
                            //   splashColor: Colors.green,
                            // ),
                            curve: Curves.ease,
                            onValueChanged: (value) {
                              setState(() {
                                useOTP = value == 1;
                                if (!useOTP) {
                                  controller.nextPage(
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.ease);
                                } else {
                                  controller.previousPage(
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.ease);
                                }
                              });
                            },
                          ).centered(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: context.mq.viewInsets.bottom),
                  child: VStack(
                    [
                      SizedBox(
                        height: 10,
                      ),
                      //
                      VStack(
                        [
                          //

                          //LOGIN Section
                          //both login type
                          if (AppStrings.enableOTPLogin &&
                              AppStrings.enableEmailLogin)
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              height: useOTP ? 165 : 250,
                              child: PageView(
                                physics: NeverScrollableScrollPhysics(),
                                controller: controller,
                                children: [
                                  OTPLoginView(model),
                                  EmailLoginView(model),
                                ],
                              ),
                            ),
                          // CombinedLoginTypeView(model),
                          //only email login
                          if (AppStrings.enableEmailLogin &&
                              !AppStrings.enableOTPLogin)
                            EmailLoginView(model),
                          //only otp login
                          if (AppStrings.enableOTPLogin &&
                              !AppStrings.enableEmailLogin)
                            OTPLoginView(model),
                        ],
                      ).wFull(context).px20(),
                      //
                      //register
                      // HStack(
                      //   [
                      //     UiSpacer.divider().expand(),
                      //     "OR".tr().text.light.make().px8(),
                      //     UiSpacer.divider().expand(),
                      //   ],
                      // ),
                      "New user?"
                          .richText
                          .withTextSpanChildren([
                            " ".textSpan.make(),
                            "Create An Account"
                                .tr()
                                .textSpan
                                .semiBold
                                .color(AppColor.primaryColor)
                                .make(),
                          ])
                          .makeCentered()
                          .onInkTap(model.openRegister),
                      SocialMediaView(model, bottomPadding: 0),
                      ScanLoginView(model),
                      // Align(alignment: Alignment.topCenter,child: Padding(
                      //   padding:  EdgeInsets.symmetric(horizontal: 10),
                      //   child: GestureDetector(onTap: (){ProfileViewModel(context).changeLanguage();},child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      //
                      //     children: [
                      //       Text("Languages",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                      //       SizedBox(width: 10,),
                      //       Icon(Icons.language,color: AppColor.primaryColor,size: 35,),
                      //     ],
                      //   )),
                      // )),
                    ],
                  ).scrollVertical(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
