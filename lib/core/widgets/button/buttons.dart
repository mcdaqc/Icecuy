// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../custom_widgets.dart';
import 'platform_button.dart';

class Buttons {
  ///Expanded Full Width Button
  ///
  ///Customizable with custom width
  ///
  ///[Default isLoading is false]
  static Widget expanded({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    double? width,
    Color? backgroundColor,
    bool isLoading = false,
    bool isDisabled = false,
    double hPadding = 0,
    double vPadding = 0,
    double borderRadius = 8,
  }) {
    return PlatformButton(
      width: width ?? double.infinity,
      height: rh(40),
      isDisabled: isDisabled,
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColorDark,
      borderRadius: BorderRadius.circular(rf(borderRadius)),
      padding: EdgeInsets.symmetric(
        horizontal: rw(hPadding),
        vertical: rh(vPadding),
      ),
      onPressed: isLoading || isDisabled ? () {} : onPressed,
      child: isLoading
          ? const FittedBox(child: CircularProgressIndicator())
          : Text(
              text.toUpperCase(),
              style: Theme.of(context).textTheme.button,
            ),
    );
  }

  ///Flexible button
  ///
  ///[Default isLoading is false]
  static Widget flexible({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    double? width,
    Color? backgroundColor,
    bool isLoading = false,
    bool isDisabled = false,
    double hPadding = 16,
    double vPadding = 0,
    double borderRadius = 8,
  }) {
    return PlatformButton(
      width: width,
      height: rh(40),
      isDisabled: isDisabled,
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColorDark,
      borderRadius: BorderRadius.circular(rf(borderRadius)),
      padding: EdgeInsets.symmetric(
        horizontal: rw(hPadding),
        vertical: rh(vPadding),
      ),
      onPressed: isLoading || isDisabled ? () {} : onPressed,
      child: isLoading
          ? const FittedBox(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : Text(
              text.toUpperCase(),
              style: Theme.of(context).textTheme.button!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
    );
  }

  ///Normal Text Button with default 8 padding
  ///
  ///[Default isLoading is false]
  static Widget text({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    double left = 16,
    double right = 16,
    double top = 0,
    double bottom = 0,
    double borderRadius = 8,
  }) {
    return PlatformButton(
      isDisabled: isDisabled,
      borderRadius: BorderRadius.circular(rf(borderRadius)),
      padding: EdgeInsets.only(
        left: rw(left),
        right: rw(right),
        top: rh(top),
        bottom: rh(bottom),
      ),
      onPressed: isLoading || isDisabled ? () {} : onPressed,
      child: isLoading
          ? const FittedBox(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 1.4, color: Colors.white)),

              ),
              child: Column(
                children: [
                  UpperCaseText(
                    text,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(height: rh(2)),
                ],
              ),
            ),
    );
  }

  ///Icon Button
  ///
  ///if icon provided -> material Icon
  ///
  ///if svgPath provided -> svgAsset Icon
  ///
  ///[Default isLoading is false]
  static Widget icon({
    required BuildContext context,
    required String semanticLabel,
    required VoidCallback onPressed,
    Color? iconColor,
    IconData? icon,
    String? svgPath,
    bool isLoading = false,
    bool isDisabled = false,
    double size = 24,
    double top = 0,
    double bottom = 0,
    double left = 0,
    double right = 0,
    double borderRadius = 0,
  }) {
    return PlatformButton(
      isDisabled: isDisabled,
      borderRadius: BorderRadius.circular(rf(borderRadius)),
      padding: EdgeInsets.only(
        top: top,
        right: right,
        bottom: bottom,
        left: left,
      ),
      onPressed: isLoading || isDisabled ? () {} : onPressed,
      child: isLoading
          ? const FittedBox(child: CircularProgressIndicator())
          : icon != null
              ? CIcons.fromMaterial(
                  icon: icon,
                  size: rf(size),
                  color: iconColor,
                  semanticLabel: semanticLabel,
                )
              : svgPath == null
                  ? Container()
                  : CIcons.fromSvg(
                      iconPath: svgPath,
                      height: rf(size),
                      semanticLabel: semanticLabel,
                      color: iconColor,
                    ),
    );
  }
}
