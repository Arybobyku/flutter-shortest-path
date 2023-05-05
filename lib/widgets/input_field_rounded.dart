import 'package:flutter/material.dart';
import 'package:flutter_mapbox_blog/helper/color_palette.dart';

class InputFieldRounded extends StatelessWidget {
  final String hint;
  final String? initialValue;
  final ValueChanged<String>? onChange;
  final Function(String?)? onFieldSubmitted;
  final Widget? suffixIcon;
  final bool secureText;
  final TextInputType keyboardType;
  final String? errortext;
  final FormFieldValidator? validatorCheck;
  const InputFieldRounded(
      {Key? key,
        required this.hint,
        this.onChange,
        this.onFieldSubmitted,
        this.validatorCheck,
        this.initialValue,
        this.suffixIcon,
        this.keyboardType = TextInputType.text,
        this.errortext,
        required this.secureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: TextFormField(
        initialValue: initialValue,
        validator: validatorCheck,
        onChanged: onChange,
        onFieldSubmitted: onFieldSubmitted,
        obscureText: secureText,
        cursorColor: ColorPalette.generalPrimaryColor,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          errorText: errortext,
          filled: false,
          hoverColor: ColorPalette.generalPrimaryColor,
          hintStyle: const TextStyle(
            color: ColorPalette.generalPrimaryColor
          ),
          floatingLabelStyle: const TextStyle(
            color: ColorPalette.generalPrimaryColor
          ),
          suffixIcon: suffixIcon,
          focusColor: ColorPalette.generalPrimaryColor,
          border: InputBorder.none
        ),
      ),
    );
  }
}