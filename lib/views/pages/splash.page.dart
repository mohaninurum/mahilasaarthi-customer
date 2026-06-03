import 'package:flutter/material.dart';
import 'package:mahilasaarthi/constants/app_colors.dart';
import 'package:mahilasaarthi/constants/app_images.dart';
import 'package:mahilasaarthi/view_models/splash.vm.dart';
import 'package:mahilasaarthi/widgets/base.page.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Adjust the duration as needed
    );

    _controller.repeat(reverse: true); // Repeat the animation with reverse

  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Colors.white,
      body: ViewModelBuilder<SplashViewModel>.reactive(
        viewModelBuilder: () => SplashViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, model, child) {
          return VStack(
            [
              //
              Image.asset(AppImages.appLogo)
                  .wh(context.percentWidth * 60, context.percentWidth * 60)
                  .box
                  .clip(Clip.antiAlias)
                  .roundedSM
                  .makeCentered()
                  .py12(),
              SizedBox(height: 10,),
              //linear progress indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: MediaQuery.of(context).size.width * 0.6,
                height: 13.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10), // Customize border radius
                  border: Border.all(color: AppColor.primaryColor,width: 2,), // Add a red border
                ),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left:  200 * _controller.value,
                          child: Container(
                            decoration: BoxDecoration(color: AppColor.primaryColor,borderRadius: BorderRadius.circular(10)),
                            width: _controller.value * 200 + 100,
                            height: 7.0,
                            // Color of the liquid
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 40,),
              // LinearProgressIndicator(
              //   minHeight: 2,
              //   backgroundColor: Colors.grey.shade300,
              //   valueColor: AlwaysStoppedAnimation<Color>(
              //     context.theme.primaryColor,
              //   ),
              // ).wOneThird(context).centered(),
            ],
            crossAlignment: CrossAxisAlignment.center,
            alignment: MainAxisAlignment.center,
          ).centered();
        },
      ),
    );
  }
}
