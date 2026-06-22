import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mahilasaarthi/constants/app_strings.dart';
import 'package:mahilasaarthi/constants/home_screen.config.dart';
import 'package:mahilasaarthi/models/search.dart';
import 'package:mahilasaarthi/services/navigation.service.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/utils/utils.dart';
import 'package:mahilasaarthi/view_models/welcome.vm.dart';
import 'package:mahilasaarthi/views/pages/vendor/widgets/banners.view.dart';
import 'package:mahilasaarthi/views/pages/vendor/widgets/section_vendors.view.dart';
import 'package:mahilasaarthi/views/shared/widgets/section_coupons.view.dart';
import 'package:mahilasaarthi/widgets/cards/custom.visibility.dart';
import 'package:mahilasaarthi/widgets/list_items/plain_vendor_type.vertical_list_item.dart';
import 'package:mahilasaarthi/widgets/states/loading.shimmer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:measure_size/measure_size.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../services/app.service.dart';
import '../../../../view_models/base.view_model.dart';
import '../../../../widgets/inputs/search_bar.input.dart';
import 'plain_welcome_header.section.dart';

class PlainEmptyWelcome extends StatefulWidget {
  const PlainEmptyWelcome({
    required this.vm,
    Key? key,
  }) : super(key: key);

  final WelcomeViewModel vm;

  @override
  State<PlainEmptyWelcome> createState() => _PlainEmptyWelcomeState();
}

class _PlainEmptyWelcomeState extends State<PlainEmptyWelcome> {
  double headerHeight = 200;
  //
  @override
  Widget build(BuildContext context) {
    //
    return SafeArea(
      top: true,
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                //
                MeasureSize(
                  onChange: (size) {
                    setState(() {
                      headerHeight = size.height;
                      if (headerHeight > 100) {
                        headerHeight -= 45;
                      }
                    });
                  },
                  child: PlainWelcomeHeaderSection(widget.vm),
                ),

                Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: headerHeight),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SearchBarInput(
                    onTap: () {
                      AppService().homePageIndex.add(2);
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                //
                VStack(
                  [
                    UiSpacer.vSpace(),
                    "Our services"
                        .tr()
                        .text
                        .bold
                        .xl2
                        .color(Color(0xff610339))
                        .make()
                        .px12(),
                    UiSpacer.vSpace(),
                    //gridview

                    InkWell(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        final rideVendors = widget.vm.vendorTypes.where(
                            (element) =>
                                element.name.toLowerCase().contains("ride") ||
                                element.slug.toLowerCase().contains("taxi"));
                        if (rideVendors.isNotEmpty) {
                          NavigationService.pageSelected(
                            rideVendors.first,
                            context: context,
                          );
                        } else {
                          widget.vm
                              .toastError("Ride service is not available.");
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: AssetImage("assets/images/ride.png"))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Ride",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 24),
                            ),
                          ),
                        ),
                      ).px12(),
                    ),
                    SizedBox(
                      height: 7,
                    ),

                    InkWell(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        MyBaseViewModel().toastSuccessful("Coming soon");
                      },
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/ecommarce.png"))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Ecommerce",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 24),
                            ),
                          ),
                        ),
                      ).px12(),
                    ),

                    SizedBox(
                      height: 7,
                    ),

                    InkWell(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        MyBaseViewModel().toastSuccessful("Coming soon");
                      },
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/phermacy.png"))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Pharmacy",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 24),
                            ),
                          ),
                        ),
                      ).px12(),
                    ),

                    SizedBox(
                      height: 7,
                    ),

                    InkWell(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        MyBaseViewModel().toastSuccessful("Coming soon");
                      },
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: AssetImage("assets/images/percel.png"))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Parcel Delivery",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 24),
                            ),
                          ),
                        ),
                      ).px12(),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    // CustomVisibilty(
                    //   visible: HomeScreenConfig.isVendorTypeListingGridView &&
                    //       widget.vm.showGrid &&
                    //       widget.vm.isBusy,
                    //   child: LoadingShimmer().px20().centered(),
                    // ),
                    // CustomVisibilty(
                    //   visible: HomeScreenConfig.isVendorTypeListingGridView &&
                    //       widget.vm.showGrid &&
                    //       !widget.vm.isBusy,
                    //   child: AnimationLimiter(
                    //     child: MasonryGrid(
                    //       column: HomeScreenConfig.vendorTypePerRow,
                    //       crossAxisSpacing: 15,
                    //       mainAxisSpacing: 15,
                    //       children: List.generate(
                    //         widget.vm.vendorTypes.length,
                    //         (index) {
                    //           final vendorType = widget.vm.vendorTypes[index];
                    //           return PlainVendorTypeVerticalListItem(
                    //             vendorType,
                    //             onPressed: () {
                    //               if(widget.vm.vendorTypes[index].name.toString() == "Ride"){
                    //
                    //                 NavigationService.pageSelected(
                    //                 vendorType,
                    //                 context: context,
                    //                 );
                    //               }else{
                    //                 MyBaseViewModel().toastSuccessful("Coming soon");
                    //               }
                    //             },
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),

                //botton banner
                CustomVisibilty(
                  visible: HomeScreenConfig.showBannerOnHomeScreen &&
                      !HomeScreenConfig.isBannerPositionTop,
                  child: Banners(
                    null,
                    featured: true,
                  ).py12(),
                ),

                //coupons
                SectionCouponsView(
                  null,
                  title: "Promo".tr(),
                  scrollDirection: Axis.horizontal,
                  itemWidth: context.percentWidth * 70,
                  height: 100,
                  itemsPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  bPadding: 10,
                ),
                //featured vendors
                SectionVendorsView(
                  null,
                  title: "Featured Vendors".tr(),
                  scrollDirection: Axis.horizontal,
                  type: SearchFilterType.featured,
                  itemWidth: context.percentWidth * 48,
                  byLocation: AppStrings.enableFatchByLocation,
                  hideEmpty: true,
                  titlePadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  itemsPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
                //spacing
                UiSpacer.vSpace(100),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
