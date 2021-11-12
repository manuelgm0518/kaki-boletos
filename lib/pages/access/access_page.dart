import 'package:avoid_keyboard/avoid_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaki_boletos/components/custom_button.dart';
import 'package:kaki_boletos/components/custom_text_field.dart';
import 'package:kaki_boletos/components/custom_title.dart';
import 'package:kaki_boletos/config/app_themes.dart';
import 'package:kaki_boletos/utils/format_utils.dart';
import 'package:kaki_boletos/utils/ui_utils.dart';
import 'package:unicons/unicons.dart';
import 'access_controller.dart';
export 'access_controller.dart';

class AccessPage extends GetView<AccessController> {
  const AccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimaryColor.variants.light,
      body: Form(
        key: controller.formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/app/logo.png', height: 200),
          kSpacerY,
          const CustomTitle(text1: 'Iniciar', text2: 'Sesión'),
          kSpacerY,
          AvoidKeyboard(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white, borderRadius: kRoundedBorder),
              padding: kPadding1,
              child: CustomTextField(
                label: 'Usuario',
                prefix: const Icon(UniconsLine.user_circle),
                controller: controller.nameField,
                whiteBackground: true,
                validator: Validator.requiredField,
              ),
            ),
          ),
          kSpacerY,
          CustomButton.elevated(
            key: controller.buttonKey,
            child: const Text('Ingresar'),
            prefix: const Icon(UniconsLine.sign_in_alt),
            color: kSecondaryColor,
            onPressed: () => controller.logIn(),
          ),
          kSpacer,
        ]).p5.safeArea(),
      ),
    );
  }
}
