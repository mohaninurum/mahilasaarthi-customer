// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:mahilasaarthi/constants/app_languages.dart';
import 'package:mahilasaarthi/services/auth.service.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/utils/utils.dart';
import 'package:mahilasaarthi/widgets/custom_grid_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class AppLanguageSelector extends StatelessWidget {
  const AppLanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        height: 500,
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: VStack(
          [
            //
            // "Select your preferred language"
            //     .tr()
            //     .text
            //     .xl
            //     .semiBold
            //     .make()
            //     .py20()
            //     .px12(),
            // UiSpacer.divider(),

            //
            //
            ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: AppLanguages.codes.length,
              itemBuilder: (ctx, index) {
                return VStack(

                  [
                    // //
                    // Flag.fromString(
                    //   AppLanguages.flags[index],
                    //   height: 40,
                    //   width: 40,
                    // ),
                    // UiSpacer.verticalSpace(space: 5),
                    //
                    12.heightBox,
                    AppLanguages.names[index].text.make().px12(),
                    8.heightBox,
                  ],
                  crossAlignment: CrossAxisAlignment.start,
                  alignment: MainAxisAlignment.center,
                )

                    .box
                    .withRounded(value: 8)
                    .color(Color(0xffCCCCCC).withOpacity(0.3))
                .margin(EdgeInsets.only(bottom: 8))
                    .border(color:Color(0xffCCCCCC) )
                    .make().onTap(() {
                  _onSelected(context, AppLanguages.codes[index]);
                });
              },
            ).expand(),

          ],
          axisSize:MainAxisSize.min,
        ),
      ),
    ).hThreeForth(context);
  }

  void _onSelected(BuildContext context, String code) async {
    await AuthServices.setLocale(code);
    //
    await translator.setNewLanguage(
      context,
      newLanguage: code,
      remember: true,
      restart: true,
    );
    await Utils.setJiffyLocale();
    //
    context.pop(true);
  }
}
