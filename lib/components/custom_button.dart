// ignore_for_file: constant_identifier_names
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaki_boletos/config/app_themes.dart';
import 'package:kaki_boletos/utils/ui_utils.dart';
import 'package:unicons/unicons.dart';

enum CustomButtonType { ELEVATED, FLAT, OUTLINED }
enum CustomButtonStatus { IDLE, LOADING, SUCCESS, ERROR, WARNING, INFO }

const _kCustomButtonAnimationDuration = Duration(milliseconds: 200);
const _kCustomButtonIconSize = 22.0;

class CustomButton extends StatefulWidget {
  final Widget child;
  final Widget? prefix;
  final Widget? suffix;
  final String? tooltip;
  final Color color;
  final bool isCircle;
  final CustomButtonType type;
  final void Function()? onPressed;

  const CustomButton({Key? key, required this.child, required this.type, this.color = kPrimaryColor, this.prefix, this.suffix, this.tooltip, this.onPressed})
      : isCircle = false,
        super(key: key);
  const CustomButton.circle({Key? key, required this.child, required this.type, this.color = kPrimaryColor, this.tooltip, this.onPressed})
      : isCircle = true,
        prefix = null,
        suffix = null,
        super(key: key);

  const CustomButton.elevated({Key? key, required this.child, this.color = kPrimaryColor, this.prefix, this.suffix, this.tooltip, this.onPressed})
      : type = CustomButtonType.ELEVATED,
        isCircle = false,
        super(key: key);
  const CustomButton.elevatedCircle({Key? key, required this.child, this.color = kPrimaryColor, this.tooltip, this.onPressed})
      : type = CustomButtonType.ELEVATED,
        isCircle = true,
        prefix = null,
        suffix = null,
        super(key: key);

  const CustomButton.flat({Key? key, required this.child, this.color = kPrimaryColor, this.prefix, this.suffix, this.tooltip, this.onPressed})
      : type = CustomButtonType.FLAT,
        isCircle = false,
        super(key: key);
  const CustomButton.flatCircle({Key? key, required this.child, this.color = kPrimaryColor, this.tooltip, this.onPressed})
      : type = CustomButtonType.FLAT,
        isCircle = true,
        prefix = null,
        suffix = null,
        super(key: key);

  const CustomButton.outline({Key? key, required this.child, this.color = kPrimaryColor, this.prefix, this.suffix, this.tooltip, this.onPressed})
      : type = CustomButtonType.OUTLINED,
        isCircle = false,
        super(key: key);
  const CustomButton.outlineCircle({Key? key, required this.child, this.color = kPrimaryColor, this.tooltip, this.onPressed})
      : type = CustomButtonType.OUTLINED,
        isCircle = true,
        prefix = null,
        suffix = null,
        super(key: key);

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  CustomButtonStatus _status = CustomButtonStatus.IDLE;
  bool get _enabled => widget.onPressed != null;
  bool get _isCircle => widget.isCircle;
  Color get _color => _status.color ?? widget.color;

  Color get _textColor {
    if (!_enabled) return kDarkColor;
    switch (widget.type) {
      case CustomButtonType.ELEVATED:
        return _color.onColor;
      case CustomButtonType.FLAT:
        return _color;
      case CustomButtonType.OUTLINED:
        return _color;
    }
  }

  Color get _backgroundColor {
    if (!_enabled) return kDarkColor.variants.light;
    switch (widget.type) {
      case CustomButtonType.ELEVATED:
        return _color;
      case CustomButtonType.FLAT:
        return _color.variants.light;
      case CustomButtonType.OUTLINED:
        return Colors.white;
    }
  }

  Color? get _outlineColor => widget.type == CustomButtonType.OUTLINED ? (_enabled ? _color.variants.light : kDarkColor.variants.light) : null;
  bool get showStatus => _status.widget != null;

  void setStatus(CustomButtonStatus status) {
    setState(() => _status = status);
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalWrapper(
      condition: widget.tooltip != null,
      conditionalBuilder: (child) => child.tooltip(widget.tooltip!),
      child: AnimatedContainer(
        duration: _kCustomButtonAnimationDuration,
        alignment: _isCircle ? Alignment.center : null,
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: _outlineColor ?? Colors.transparent),
          color: _backgroundColor,
          shape: _isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: _isCircle ? null : kRoundedBorder,
          //boxShadow: [if (_enabled && widget.type == CustomButtonType.ELEVATED) BoxShadow(color: _color.withOpacity(0.8), offset: Offset(0.0, 2.0), blurRadius: 8.0)],
        ),
        child: DefaultTextStyle.merge(
          style: Get.textTheme.button?.copyWith(color: _textColor),
          child: Theme(
            data: Get.theme.copyWith(
              colorScheme: ColorScheme.light(primary: _textColor),
              iconTheme: IconThemeData(color: _textColor, size: _kCustomButtonIconSize),
            ),
            child: AnimatedSizeAndFade(
              fadeDuration: _kCustomButtonAnimationDuration,
              sizeDuration: _kCustomButtonAnimationDuration,
              child: _status.widget != null
                  ? Center(
                      key: ValueKey(_status.index),
                      child: _status.widget?.pxy(4, _isCircle ? 4 : 3),
                    )
                  : Row(
                      key: const ValueKey('content'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.prefix != null) ...[widget.prefix!, kSpacerX],
                        widget.child,
                        if (widget.suffix != null) ...[kSpacerX, widget.suffix!],
                      ],
                    ).pxy(4, _isCircle ? 4 : 3),
            ),
          ),
        ),
      ).mouse(widget.onPressed),
    );
  }
}

extension CustomButtonStatusExtension on CustomButtonStatus {
  Color? get color {
    switch (this) {
      case CustomButtonStatus.SUCCESS:
        return kSuccessColor;
      case CustomButtonStatus.ERROR:
        return kErrorColor;
      case CustomButtonStatus.WARNING:
        return kWarningColor;
      case CustomButtonStatus.INFO:
        return kInfoColor;
      default:
        return null;
    }
  }

  Widget? get widget {
    switch (this) {
      case CustomButtonStatus.LOADING:
        return const SizedBox(
          width: _kCustomButtonIconSize,
          height: _kCustomButtonIconSize,
          child: CircularProgressIndicator(strokeWidth: 3),
        );
      case CustomButtonStatus.SUCCESS:
        return const Icon(UniconsLine.check);
      case CustomButtonStatus.ERROR:
        return const Icon(UniconsLine.times);
      case CustomButtonStatus.WARNING:
        return const Icon(UniconsLine.exclamation_triangle);
      case CustomButtonStatus.INFO:
        return const Icon(UniconsLine.info_circle);
      default:
        return null;
    }
  }
}
