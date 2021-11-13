import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:derived_colors/derived_colors.dart';
import 'package:kaki_boletos/config/app_themes.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.controller,
    required this.label,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.validator,
    this.whiteBackground = false,
    this.textArea = false,
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  final TextEditingController? controller;
  final String label;
  final Widget? prefix;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final bool whiteBackground;
  final bool textArea;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool readOnly;
  final void Function()? onTap;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool focused = false;
  bool error = false;
  void _onFocusChange(bool value) {
    setState(() => focused = value);
  }

  Color get themePrimary => Get.theme.colorScheme.primary;
  Color get themeSecondary => Colors.grey;

  /////Get.theme.colorScheme.secondary.withOpacity(0.4);
  Color get textColor => error
      ? kErrorColor
      : focused
          ? themePrimary
          : themeSecondary;
  Color get backgroundColor => error
      ? kErrorColor.variants.light
      : focused
          ? themePrimary.variants.light
          : (widget.whiteBackground ? Colors.white : themeSecondary.variants.light);
  Widget? iconTheme(Widget? widget) => widget != null ? IconTheme(data: IconThemeData(color: textColor, size: 20), child: widget) : null;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Get.theme.copyWith(colorScheme: Get.theme.colorScheme.copyWith(primary: textColor)),
      child: FocusScope(
        onFocusChange: (value) => _onFocusChange(value),
        child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.textArea ? TextInputType.multiline : widget.keyboardType,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          validator: (value) {
            if (widget.validator != null) {
              final res = widget.validator!(value);
              setState(() => error = res != null);
              return res;
            }
          },
          inputFormatters: widget.inputFormatters,
          style: Get.textTheme.headline6?.copyWith(color: Colors.black, fontSize: 18),
          maxLines: widget.textArea ? null : 1,
          //expands: widget.textArea,
          decoration: InputDecoration(
            fillColor: backgroundColor,
            labelStyle: Get.textTheme.subtitle1?.copyWith(color: textColor),
            labelText: widget.label,
            prefixIcon: iconTheme(widget.prefix),
            suffixIcon: iconTheme(widget.suffix),
            //border: const UnderlineInputBorder(borderRadius: kRoundedBorder, borderSide: BorderSide.none),
            //focusedBorder: const OutlineInputBorder(borderRadius: kRoundedBorder, borderSide: BorderSide.none),
            //errorBorder: const OutlineInputBorder(borderRadius: kRoundedBorder, borderSide: BorderSide.none),
            //focusedErrorBorder: const OutlineInputBorder(borderRadius: kRoundedBorder, borderSide: BorderSide.none),
            //isDense: true,
          ),
        ),
      ),
    );
  }
}
