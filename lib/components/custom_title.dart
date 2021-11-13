import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaki_boletos/config/app_themes.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({Key? key, required this.text1, required this.text2, this.color1 = kSecondaryColor, this.color2 = Colors.black}) : super(key: key);

  final String text1;
  final String text2;
  final Color color1;
  final Color color2;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(
        text1,
        style: Get.textTheme.headline5?.copyWith(
          color: color1,
        ),
      ),
      Text(
        text2,
        maxLines: 2,
        style: Get.textTheme.headline3?.copyWith(
          color: color2,
          fontFamily: 'Limelight',
          overflow: TextOverflow.ellipsis,
        ),
      )
    ]);
  }
}
