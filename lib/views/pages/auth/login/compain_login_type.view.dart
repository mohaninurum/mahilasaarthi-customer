import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:mahilasaarthi/constants/app_colors.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/view_models/login.view_model.dart';
import 'package:mahilasaarthi/views/pages/auth/login/email_login.view.dart';
import 'package:mahilasaarthi/views/pages/auth/login/otp_login.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class CombinedLoginTypeView extends StatefulWidget {
  const CombinedLoginTypeView(this.model, {Key? key}) : super(key: key);

  final LoginViewModel model;

  @override
  State<CombinedLoginTypeView> createState() => _CombinedLoginTypeViewState();
}

class _CombinedLoginTypeViewState extends State<CombinedLoginTypeView> {

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        // UiSpacer.vSpace(),
        //
        // useOTP ? OTPLoginView(widget.model) : EmailLoginView(widget.model),


      ],
    );
  }
}
