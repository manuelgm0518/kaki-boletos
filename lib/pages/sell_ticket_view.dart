import 'dart:math';

import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaki_boletos/components/custom_button.dart';
import 'package:kaki_boletos/components/custom_text_field.dart';
import 'package:kaki_boletos/components/custom_title.dart';
import 'package:kaki_boletos/config/app_themes.dart';
import 'package:kaki_boletos/pages/main_controller.dart';
import 'package:kaki_boletos/utils/format_utils.dart';
import 'package:kaki_boletos/utils/ui_utils.dart';
import 'package:unicons/unicons.dart';

class SellTicketView extends GetView<MainController> {
  const SellTicketView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      const CustomTitle(text1: 'Registrar', text2: 'Cliente'),
      kSpacerY,
      Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: kRoundedBorder),
        padding: kPadding2,
        child: Form(
          key: controller.formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
            CustomTextField(
              label: 'Nombre del cliente',
              prefix: const Icon(UniconsLine.user),
              controller: controller.nameField,
              validator: Validator.requiredField,
            ),
            Divider(thickness: 0.5, height: 0, color: Colors.grey.shade300).px,
            CustomTextField(
              label: 'Teléfono del cliente',
              prefix: const Icon(UniconsLine.phone),
              controller: controller.phoneField,
              validator: Validator.requiredField,
              keyboardType: TextInputType.phone,
              inputFormatters: [TextInputMask(mask: '(999) 999 9999')],
            ),
            Divider(thickness: 0.5, height: 0, color: Colors.grey.shade300).px,
            Row(children: [
              CustomTextField(
                label: 'Fecha',
                prefix: const Icon(UniconsLine.calendar_alt),
                controller: controller.calendarField,
                readOnly: true,
                onTap: () => controller.switchDates(),
              ).expanded(),
              Container(width: 0.5, color: Colors.grey.shade300, height: 30),
              CustomTextField(
                label: 'Entradas',
                prefix: const Icon(UniconsLine.minus_circle, size: 25).mouse(() => controller.setSeatings(max(1, controller.seatings - 1))),
                suffix: const Icon(UniconsLine.plus_circle, size: 25).mouse(() => controller.setSeatings(controller.seatings + 1)),
                keyboardType: TextInputType.number,
                controller: controller.seatingsField,
                validator: Validator.requiredField,
              ).expanded(),
            ]),
          ]),
        ),
      ),
      kSpacerY,
      CustomButton.elevated(
        key: controller.buttonKey,
        child: const Text('Vender boleto'),
        prefix: const Icon(UniconsLine.invoice),
        color: kSecondaryColor,
        onPressed: () => controller.sellTicket(),
      ),
      kSpacerY,
      CustomButton.elevated(
        child: const Text('Escanear boleto'),
        prefix: const Icon(UniconsLine.qrcode_scan),
        color: kPrimaryColor,
        onPressed: () => controller.tabController.animateTo(1),
      ),
    ]);
  }
}
