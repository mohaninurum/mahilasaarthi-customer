import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/view_models/search.vm.dart';
import 'package:mahilasaarthi/widgets/inputs/search_bar.input.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader(
    this.model, {
    Key? key,
    this.subtitle,
    this.showCancel = true,
  }) : super(key: key);

  final SearchViewModel model;
  final bool showCancel;
  final String? subtitle;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //Appbar
        HStack(
          [
            // VStack(
            //   [
            //     "Search".tr().text.semiBold.xl2.make(),
            //     Visibility(
            //       visible: subtitle != null,
            //       child: "$subtitle".text.make(),
            //     ),
            //     Visibility(
            //       visible: subtitle == null,
            //       child: "Ordered by Nearby first".tr().text.make(),
            //     ),
            //   ],
            // ).expand(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xffC70774),Color(0xff610339)],begin:Alignment.bottomLeft ,end:  Alignment.topRight)
              ),height: 120,width: double.infinity,child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
              SizedBox(height: 55,),
              "Search".tr().text.xl2.semiBold.white.make(),
              "Ordered by Nearby first".tr().text.lg.light.white.make(),
            ],),).expand(),

            //
            showCancel
                ? Icon(
                    FlutterIcons.close_ant,
                  ).p4().onInkTap(context.pop)
                : UiSpacer.emptySpace(),
          ],
        ).pOnly(bottom: 10),
        //
        SearchBarInput(
          readOnly: false,
          showFilter: true,
          searchTEC: model.searchTEC,
          onSubmitted: (keyword) {
            model.keyword = keyword;
            model.startSearch();
          },
          onFilterPressed: () => model.showFilterOptions(),
        ).px(15),

        //search history, horizontal list
        Visibility(
          visible: model.searchHistory.isNotEmpty,
          child: VStack(
            [
              "Search History".tr().text.make(),
              UiSpacer.verticalSpace(space: 0.02),
              HStack(
                [
                  for (var history in model.searchHistory)
                    history.text
                        .color(Theme.of(context).primaryColor)
                        .make()
                        .p4()
                        .onInkTap(
                      () {
                        model.searchTEC.text = history;
                        model.keyword = history;
                        model.startSearch();
                      },
                    ),
                ],
              ),
            ],
          ).pOnly(top: 20),
        ),
      ],
    );
  }
}
