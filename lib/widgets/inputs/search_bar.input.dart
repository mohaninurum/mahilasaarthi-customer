import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mahilasaarthi/constants/app_colors.dart';
import 'package:mahilasaarthi/models/search.dart';
import 'package:mahilasaarthi/services/navigation.service.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/input.styles.dart';

class SearchBarInput extends StatelessWidget {
  const SearchBarInput({
    this.hintText,
    this.onTap,
    this.onFilterPressed,
    this.onSubmitted,
    this.readOnly = true,
    this.showFilter = false,
    this.search,
    this.searchTEC,
    Key? key,
  }) : super(key: key);

  final String? hintText;
  final Function? onTap;
  final Function? onFilterPressed;
  final Function(String)? onSubmitted;
  final bool readOnly;
  final Search? search;
  final bool? showFilter;
  final TextEditingController? searchTEC;
  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //
        TextFormField(
          readOnly: readOnly,
          onTap: () {
            if (search != null) {
              //pages
              final page = NavigationService().searchPageWidget(search!);
              context.nextPage(page);
            } else if (onTap != null) {
              onTap!();
            }
          },
          controller: searchTEC,
          onFieldSubmitted: onSubmitted,
          decoration: InputDecoration(
            enabledBorder:  InputStyles.inputEnabledBorder(),
            errorBorder:  InputStyles.inputEnabledBorder(),
            focusedErrorBorder:InputStyles.inputFocusBorder(),
            focusedBorder:InputStyles.inputFocusBorder(),

            hintText: hintText ?? "Search".tr(),
            hintStyle: context.textTheme.bodyMedium!.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w100,
              color: AppColor.primaryColor,
            ),
            border: InputBorder.none,
            prefixIcon: Icon(
              FlutterIcons.search_fea,
              size: 20,
              color: AppColor.primaryColor,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            filled: true,
            fillColor: context.theme.colorScheme.background,
          ),
        )
            .box
            .color(context.theme.colorScheme.background)
            .outerShadowSm
            .roundedSM
            .clip(Clip.antiAlias)
            .make()
            .expand(),
        Visibility(
          visible: showFilter ?? true,
          child: HStack(
            [
              UiSpacer.horizontalSpace(space: 10),
              //filter icon
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  decoration: BoxDecoration(
                      color: context.theme.colorScheme.background,

                      borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColor.primaryColor.withOpacity(0.5))
                  ),
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    FlutterIcons.sliders_faw,
                    color: context.primaryColor,
                    size: 20,
                  ),
                )
                )

                    .onInkTap(
                      onFilterPressed != null ? () => onFilterPressed!() : () {},
                    )
                   ,
            ],
          ),
        ),
      ],
    );
  }
}
