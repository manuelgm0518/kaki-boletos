import 'package:camerakit/CameraKitView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaki_boletos/components/custom_button.dart';
import 'package:kaki_boletos/components/custom_title.dart';
import 'package:kaki_boletos/config/app_themes.dart';
import 'package:kaki_boletos/pages/main_controller.dart';
import 'package:kaki_boletos/utils/ui_utils.dart';
import 'package:unicons/unicons.dart';

class ScanTicketView extends GetView<MainController> {
  const ScanTicketView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      const CustomTitle(text1: 'Escanear', text2: 'Boleto'),
      kSpacerY,
      Obx(
        () => Container(
          color: Colors.black,
          alignment: Alignment.center,
          width: 300,
          height: 205,
          child: controller.loadingCamera.value
              ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white))
              : controller.showCamera.value
                  ? CameraKitView(
                      cameraKitController: controller.cameraKitController,
                      hasBarcodeReader: true,
                      barcodeFormat: BarcodeFormats.FORMAT_QR_CODE,
                      scaleType: ScaleTypeMode.fill,
                      previewFlashMode: CameraFlashMode.auto,
                      androidCameraMode: AndroidCameraMode.API_X,
                      cameraSelector: CameraSelector.back,
                      onBarcodeRead: (code) {
                        controller.scannedTicket(code);
                      },
                    )
                  : const Icon(UniconsLine.camera, color: Colors.white),
        ),
      ).rounded(),
      kSpacerY,
      CustomButton.elevated(
        //key: controller.buttonKey,
        child: const Text('Cancelar'),
        prefix: const Icon(UniconsLine.times_circle),
        color: kErrorColor,
        onPressed: () {
          controller.tabController.animateTo(0);
        },
      ),
    ]);
  }
}
