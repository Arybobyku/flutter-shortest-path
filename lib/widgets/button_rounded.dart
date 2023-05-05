import 'package:flutter/material.dart';
import 'package:flutter_mapbox_blog/helper/color_palette.dart';

import '../helper/constants.dart';

class ButtonRounded extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool invert;
  final bool disabled;

  const ButtonRounded(
      {Key? key, this.onPressed, required this.text, this.invert = false,this.disabled=false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      decoration: kRoundedContainer.copyWith(
          color: invert
              ? ColorPalette.generalWhite
              : ColorPalette.generalPrimaryColor,
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: invert
                  ? ColorPalette.generalPrimaryColor
                  : ColorPalette.generalBackgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
