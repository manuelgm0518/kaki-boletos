import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// Constants & utilities
const kSpacing = 12.0;
const kSpacing1 = kSpacing * 0.25;
const kSpacing2 = kSpacing * 0.5;
const kSpacing3 = kSpacing * 1.0;
const kSpacing4 = kSpacing * 1.5;
const kSpacing5 = kSpacing * 3.0;

const kBorderRadius = 20.0;
const kRoundedBorder = BorderRadius.all(Radius.circular(kBorderRadius));
const kPillBorder = BorderRadius.all(Radius.circular(kBorderRadius));
const kBouncyScroll = BouncingScrollPhysics();
const kNeverScroll = NeverScrollableScrollPhysics();

// Widgets
const kDivider = Divider(height: 0);
const kSpacer = Spacer();
const kSpacerX = SizedBox(width: kSpacing);
const kSpacerX1 = SizedBox(width: kSpacing1);
const kSpacerX2 = SizedBox(width: kSpacing2);
const kSpacerX3 = SizedBox(width: kSpacing3);
const kSpacerX4 = SizedBox(width: kSpacing4);
const kSpacerX5 = SizedBox(width: kSpacing5);

const kSpacerY = SizedBox(height: kSpacing);
const kSpacerY1 = SizedBox(height: kSpacing1);
const kSpacerY2 = SizedBox(height: kSpacing2);
const kSpacerY3 = SizedBox(height: kSpacing3);
const kSpacerY4 = SizedBox(height: kSpacing4);
const kSpacerY5 = SizedBox(height: kSpacing5);

//Padding utils
const kPadding = EdgeInsets.all(kSpacing);
const kPadding1 = EdgeInsets.all(kSpacing1);
const kPadding2 = EdgeInsets.all(kSpacing2);
const kPadding3 = EdgeInsets.all(kSpacing3);
const kPadding4 = EdgeInsets.all(kSpacing4);
const kPadding5 = EdgeInsets.all(kSpacing5);

const kPaddingL = EdgeInsets.only(left: kSpacing);
const kPaddingL1 = EdgeInsets.only(left: kSpacing1);
const kPaddingL2 = EdgeInsets.only(left: kSpacing2);
const kPaddingL3 = EdgeInsets.only(left: kSpacing3);
const kPaddingL4 = EdgeInsets.only(left: kSpacing4);
const kPaddingL5 = EdgeInsets.only(left: kSpacing5);

const kPaddingT = EdgeInsets.only(top: kSpacing);
const kPaddingT1 = EdgeInsets.only(top: kSpacing1);
const kPaddingT2 = EdgeInsets.only(top: kSpacing2);
const kPaddingT3 = EdgeInsets.only(top: kSpacing3);
const kPaddingT4 = EdgeInsets.only(top: kSpacing4);
const kPaddingT5 = EdgeInsets.only(top: kSpacing5);

const kPaddingR = EdgeInsets.only(right: kSpacing);
const kPaddingR1 = EdgeInsets.only(right: kSpacing1);
const kPaddingR2 = EdgeInsets.only(right: kSpacing2);
const kPaddingR3 = EdgeInsets.only(right: kSpacing3);
const kPaddingR4 = EdgeInsets.only(right: kSpacing4);
const kPaddingR5 = EdgeInsets.only(right: kSpacing5);

const kPaddingB = EdgeInsets.only(bottom: kSpacing);
const kPaddingB1 = EdgeInsets.only(bottom: kSpacing1);
const kPaddingB2 = EdgeInsets.only(bottom: kSpacing2);
const kPaddingB3 = EdgeInsets.only(bottom: kSpacing3);
const kPaddingB4 = EdgeInsets.only(bottom: kSpacing4);
const kPaddingB5 = EdgeInsets.only(bottom: kSpacing5);

const kPaddingX = EdgeInsets.symmetric(horizontal: kSpacing);
const kPaddingX1 = EdgeInsets.symmetric(horizontal: kSpacing1);
const kPaddingX2 = EdgeInsets.symmetric(horizontal: kSpacing2);
const kPaddingX3 = EdgeInsets.symmetric(horizontal: kSpacing3);
const kPaddingX4 = EdgeInsets.symmetric(horizontal: kSpacing4);
const kPaddingX5 = EdgeInsets.symmetric(horizontal: kSpacing5);

const kPaddingY = EdgeInsets.symmetric(vertical: kSpacing);
const kPaddingY1 = EdgeInsets.symmetric(vertical: kSpacing1);
const kPaddingY2 = EdgeInsets.symmetric(vertical: kSpacing2);
const kPaddingY3 = EdgeInsets.symmetric(vertical: kSpacing3);
const kPaddingY4 = EdgeInsets.symmetric(vertical: kSpacing4);
const kPaddingY5 = EdgeInsets.symmetric(vertical: kSpacing5);

/// Widget extensions utilities
extension WidgetUtils on Widget {
  Widget tooltip(String text) => Tooltip(message: text, child: this);
  Widget rounded([BorderRadius? radius]) => ClipRRect(borderRadius: radius ?? kRoundedBorder, child: this);
  Widget expanded([int flex = 1]) => Expanded(flex: flex, child: this);
  Widget flexible([int flex = 1]) => Flexible(flex: flex, child: this);

  Widget backgroundColor(Color color) => Container(color: color, child: this);
  Widget centered() => Center(child: this);
  Widget aligned(Alignment alignment) => Align(alignment: alignment, child: this);
  Widget aspectRatio(double aspectRatio) => AspectRatio(aspectRatio: aspectRatio, child: this);
  Widget width(double width) => SizedBox(width: width, child: this);
  Widget height(double height) => SizedBox(height: height, child: this);
  Widget scrollable({Axis direction = Axis.vertical, ScrollPhysics physics = kBouncyScroll, EdgeInsets? padding}) =>
      SingleChildScrollView(physics: physics, scrollDirection: direction, padding: padding, child: this);
  Widget safeArea() => SafeArea(child: this);

  Widget mouse(void Function()? onTap, {void Function(bool)? hover, double bounce = 4.0}) {
    return ConditionalWrapper(
      condition: onTap != null,
      child: this,
      conditionalBuilder: (child) => MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => hover != null ? hover(true) : null,
        onExit: (event) => hover != null ? hover(false) : null,
        child: bounce != 0.0 ? Bounce(onPressed: onTap, child: this, translation: bounce) : GestureDetector(onTap: onTap, child: this),
      ),
    );
  }

  Widget get p => Padding(padding: kPadding, child: this);
  Widget get p1 => Padding(padding: kPadding1, child: this);
  Widget get p2 => Padding(padding: kPadding2, child: this);
  Widget get p3 => Padding(padding: kPadding3, child: this);
  Widget get p4 => Padding(padding: kPadding4, child: this);
  Widget get p5 => Padding(padding: kPadding5, child: this);

  Widget get pl => Padding(padding: kPaddingL, child: this);
  Widget get pl1 => Padding(padding: kPaddingL1, child: this);
  Widget get pl2 => Padding(padding: kPaddingL2, child: this);
  Widget get pl3 => Padding(padding: kPaddingL3, child: this);
  Widget get pl4 => Padding(padding: kPaddingL4, child: this);
  Widget get pl5 => Padding(padding: kPaddingL5, child: this);

  Widget get pt => Padding(padding: kPaddingT, child: this);
  Widget get pt1 => Padding(padding: kPaddingT1, child: this);
  Widget get pt2 => Padding(padding: kPaddingT2, child: this);
  Widget get pt3 => Padding(padding: kPaddingT3, child: this);
  Widget get pt4 => Padding(padding: kPaddingT4, child: this);
  Widget get pt5 => Padding(padding: kPaddingT5, child: this);

  Widget get pr => Padding(padding: kPaddingR, child: this);
  Widget get pr1 => Padding(padding: kPaddingR1, child: this);
  Widget get pr2 => Padding(padding: kPaddingR2, child: this);
  Widget get pr3 => Padding(padding: kPaddingR3, child: this);
  Widget get pr4 => Padding(padding: kPaddingR4, child: this);
  Widget get pr5 => Padding(padding: kPaddingR5, child: this);

  Widget get pb => Padding(padding: kPaddingB, child: this);
  Widget get pb1 => Padding(padding: kPaddingB1, child: this);
  Widget get pb2 => Padding(padding: kPaddingB2, child: this);
  Widget get pb3 => Padding(padding: kPaddingB3, child: this);
  Widget get pb4 => Padding(padding: kPaddingB4, child: this);
  Widget get pb5 => Padding(padding: kPaddingB5, child: this);

  Widget get px => Padding(padding: kPaddingX, child: this);
  Widget get px1 => Padding(padding: kPaddingX1, child: this);
  Widget get px2 => Padding(padding: kPaddingX2, child: this);
  Widget get px3 => Padding(padding: kPaddingX3, child: this);
  Widget get px4 => Padding(padding: kPaddingX4, child: this);
  Widget get px5 => Padding(padding: kPaddingX5, child: this);

  Widget get py => Padding(padding: kPaddingY, child: this);
  Widget get py1 => Padding(padding: kPaddingY1, child: this);
  Widget get py2 => Padding(padding: kPaddingY2, child: this);
  Widget get py3 => Padding(padding: kPaddingY3, child: this);
  Widget get py4 => Padding(padding: kPaddingY4, child: this);
  Widget get py5 => Padding(padding: kPaddingY5, child: this);

  Widget pxy(int scaleX, int scaleY) {
    return Padding(
      child: this,
      padding: EdgeInsets.symmetric(
        horizontal: _sizes[scaleX < 0 || scaleX > 5 ? 0 : scaleX],
        vertical: _sizes[scaleY < 0 || scaleY > 5 ? 0 : scaleY],
      ),
    );
  }

  Widget pLTRB(int scaleL, int scaleT, int scaleR, int scaleB) {
    return Padding(
      child: this,
      padding: EdgeInsets.fromLTRB(
        _sizes[scaleL < 0 || scaleL > 5 ? 0 : scaleL],
        _sizes[scaleT < 0 || scaleT > 5 ? 0 : scaleT],
        _sizes[scaleR < 0 || scaleR > 5 ? 0 : scaleR],
        _sizes[scaleB < 0 || scaleB > 5 ? 0 : scaleB],
      ),
    );
  }

  Widget left(List<Widget> items, [MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start, CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center]) {
    if (items.isEmpty) return this;
    return Row(mainAxisAlignment: mainAxisAlignment, crossAxisAlignment: crossAxisAlignment, mainAxisSize: MainAxisSize.min, children: [...items, this]);
  }

  Widget right(List<Widget> items, [MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start, CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center]) {
    if (items.isEmpty) return this;
    return Row(mainAxisAlignment: mainAxisAlignment, crossAxisAlignment: crossAxisAlignment, mainAxisSize: MainAxisSize.min, children: [this, ...items]);
  }

  Widget top(List<Widget> items, [MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start, CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start]) {
    if (items.isEmpty) return this;
    return Column(mainAxisAlignment: mainAxisAlignment, crossAxisAlignment: crossAxisAlignment, mainAxisSize: MainAxisSize.min, children: [...items, this]);
  }

  Widget bottom(List<Widget> items, [MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start, CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start]) {
    if (items.isEmpty) return this;
    return Column(mainAxisAlignment: mainAxisAlignment, crossAxisAlignment: crossAxisAlignment, mainAxisSize: MainAxisSize.min, children: [this, ...items]);
  }
}

const _sizes = [0.0, kSpacing1, kSpacing2, kSpacing3, kSpacing4, kSpacing5];

class ConditionalWrapper extends StatelessWidget {
  const ConditionalWrapper({
    Key? key,
    required this.condition,
    required this.child,
    required this.conditionalBuilder,
  }) : super(key: key);

  final Widget child;
  final bool condition;
  final Widget Function(Widget child) conditionalBuilder;

  @override
  Widget build(BuildContext context) {
    return condition ? conditionalBuilder(child) : child;
  }
}

/// Adds a bounce animation onTap
class Bounce extends StatefulWidget {
  const Bounce({
    Key? key,
    required this.child,
    required this.translation,
    this.onPressed,
  }) : super(key: key);
  final Widget child;
  final double translation;
  final void Function()? onPressed;
  @override
  BounceState createState() => BounceState();
}

class BounceState extends State<Bounce> {
  bool pressed = false;
  void setPressed(bool value) {
    if (pressed != value) setState(() => pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onPanCancel: () => setPressed(false),
      onTapCancel: () => setPressed(false),
      onTapUp: (details) => setPressed(false),
      onTapDown: (details) => setPressed(true),
      onPanDown: (details) => setPressed(true),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.bounceInOut,
        transform: Transform.translate(offset: Offset(0, pressed ? widget.translation : 0)).transform,
        child: widget.child,
      ),
    );
  }
}

SizedBox get statusBarSpacer => SizedBox(height: MediaQuery.of(Get.context!).padding.top);
double keyboardPadding(BuildContext context, [double extra = 0.0]) => max(0, MediaQuery.of(context).viewInsets.bottom - extra);
void setScreenColors({Color? statusBar, Color? navigationBar}) {
  final statusBrightness = statusBar != null ? ThemeData.estimateBrightnessForColor(statusBar) : null;
  final navigationBrightness = navigationBar != null ? ThemeData.estimateBrightnessForColor(navigationBar) : null;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: navigationBar,
      statusBarColor: statusBar,
      statusBarIconBrightness: statusBrightness?.opposite,
      systemNavigationBarIconBrightness: navigationBrightness?.opposite,
    ),
  );
}

extension BrightnessExtension on Brightness {
  Brightness get opposite => this == Brightness.dark ? Brightness.light : Brightness.dark;
}

extension ColorExtension on Color {
  Color get onColor {
    final brightness = ThemeData.estimateBrightnessForColor(this);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }
}
