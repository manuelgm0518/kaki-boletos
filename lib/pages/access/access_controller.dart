import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kaki_boletos/components/custom_button.dart';
import 'package:kaki_boletos/config/app_pages.dart';
import 'package:kaki_boletos/services/session_service.dart';

class AccessController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameField = TextEditingController();
  final buttonKey = GlobalKey<CustomButtonState>();

  Future<void> logIn() async {
    if (formKey.currentState?.validate() ?? false) {
      buttonKey.currentState?.setStatus(CustomButtonStatus.LOADING);
      await SessionService.to.logIn(nameField.text.toLowerCase());
      Get.offAndToNamed(Routes.HOME);
    }
  }
}
