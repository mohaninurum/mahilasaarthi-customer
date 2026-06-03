import 'package:flutter/material.dart';
import 'package:mahilasaarthi/constants/app_images.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/view_models/location_fetch.view_model.dart';
import 'package:mahilasaarthi/widgets/buttons/custom_button.dart';
import 'package:mahilasaarthi/widgets/buttons/custom_text_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class LocationFetchPage extends StatelessWidget {
  const LocationFetchPage({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LocationFetchViewModel>.reactive(
        viewModelBuilder: () => LocationFetchViewModel(context, child),
        disposeViewModel: true,
        onViewModelReady: (vm) => vm.initialise(),
        builder: (ctx, vm, child) {
          return Scaffold(
            body: VStack(
              [
                //skip
                HStack([
                  UiSpacer.expandedSpace(),
                  CustomTextButton(
                    title: "Skip".tr(),
                    onPressed: vm.loadNextPage,
                  ),
                ]).safeArea(),
                Center(
                  child: VStack(
                    [
                      FittedBox(
                        child: Image.asset(AppImages.locationGif)
                            .wh(context.percentWidth * 30,
                                context.percentWidth * 30)
                            .box
                            .roundedFull
                            .clip(Clip.antiAlias)
                            .make(),
                      ),
                      UiSpacer.vSpace(),
                      //
                      Visibility(
                        visible: !vm.showManuallySelection,
                        child: VStack(
                          [
                            "Trying to find your current location."
                                .tr()
                                .text
                                .lg
                                .medium
                                .center
                                .makeCentered(),
                            "Please wait while we get it"
                                .tr()
                                .text
                                .lg
                                .medium
                                .center
                                .makeCentered(),
                          ],
                        ),
                      ),

                      Visibility(
                        visible: vm.showManuallySelection,
                        child: VStack(
                          [
                            "We are unable to determine current location. Please try again or manually select location"
                                .tr()
                                .text
                                .lg
                                .medium
                                .center
                                .makeCentered()
                                .px(40),
                            UiSpacer.vSpace(),
                            // CustomButton(
                            //   title: "Choose On Map".tr(),
                            //   onPressed: vm.pickFromMap,
                            // ).w40(context),
                            InkWell(
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onTap: vm.pickFromMap,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xffC70774),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(child: Text("Choose On Map".tr(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),)),

                              ).centered(),
                            ),
                            UiSpacer.vSpace(10),

                            InkWell(
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onTap: vm.handleFetchCurrentLocation,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffC70774)),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(child: Text("Try again".tr(),style: TextStyle(color:Color(0xffC70774),fontWeight: FontWeight.bold,fontSize: 16),)),

                              ).centered(),
                            ),

                            // CustomTextButton(
                            //   title: "Try again".tr(),
                            //   onPressed: vm.handleFetchCurrentLocation,
                            // ).w24(context)
                          ],
                          crossAlignment: CrossAxisAlignment.center,
                        ).p20(),
                      ),
                      UiSpacer.vSpace(),
                    ],
                    crossAlignment: CrossAxisAlignment.center,
                  ),
                ).expand(),
              ],
            ),
          );
        });
  }
}
