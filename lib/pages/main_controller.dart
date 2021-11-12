import 'package:camerakit/CameraKitController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kaki_boletos/components/custom_button.dart';
import 'package:kaki_boletos/components/ticket_share.dart';
import 'package:kaki_boletos/config/app_pages.dart';
import 'package:kaki_boletos/config/app_themes.dart';
import 'package:kaki_boletos/models/ticket.dart';
import 'package:kaki_boletos/services/repository_service.dart';
import 'package:kaki_boletos/services/session_service.dart';

class MainController extends GetxController with SingleGetTickerProviderMixin {
  late final TabController tabController;
  final scrollController = ScrollController();
  final cameraKitController = CameraKitController();
  final formKey = GlobalKey<FormState>();
  final buttonKey = GlobalKey<CustomButtonState>();
  final nameField = TextEditingController();
  final phoneField = TextEditingController();
  final seatingsField = TextEditingController(text: '1');
  int get seatings => int.tryParse(seatingsField.text) ?? 1;

  List<Ticket> get tickets => RepositoryService.to.tickets.where((ticket) => ticket.checked == onlyChecked.value).toList()..sort((a, b) => b.soldTime.compareTo(a.soldTime));
  var onlyChecked = false.obs;

  var showCamera = false.obs;
  var loadingCamera = false.obs;
  String? lastScanned;
  Future<void> scannedTicket(String qrCode) async {
    if (qrCode != lastScanned) {
      lastScanned = qrCode;
      loadingCamera(true);
      final ref = FirebaseFirestore.instance.collection('tickets').doc(qrCode);
      final data = await ref.get();
      if (data.exists) {
        final ticket = Ticket.fromMap({'id': data.id, ...data.data()!});
        if (ticket.checked) {
          Get.snackbar('Este ticket ya ha sido escaneado', 'A las ${DateFormat("hh:mmaa").format(ticket.checkedAt!)}', colorText: Colors.white, backgroundColor: kWarningColor);
        } else {
          await ref.update(ticket.copyWith(checkedAt: DateTime.now(), checkedBy: SessionService.to.seller!.name).toMap());
          Get.snackbar('Ticket escaneado correctamente', 'Cliente: ${ticket.clientName}', colorText: Colors.white, backgroundColor: kSuccessColor);
        }
      } else {
        Get.snackbar('Boleto no válido', 'Intenta escanearlo de nuevo', colorText: Colors.white, backgroundColor: kErrorColor);
      }
      loadingCamera(false);
    }
  }

  void setSeatings(int quantity) {
    seatingsField.value = TextEditingValue(text: quantity.toString());
  }

  void clearForm() {
    nameField.clear();
    phoneField.clear();
    setSeatings(1);
  }

  Future<void> sellTicket() async {
    if (formKey.currentState?.validate() ?? false) {
      buttonKey.currentState?.setStatus(CustomButtonStatus.LOADING);
      final mask = MagicMask.buildMask('(999) 999 9999');
      final ticket = Ticket(
        seller: SessionService.to.seller!.id!,
        seatingsCount: seatings,
        clientName: nameField.text,
        clientPhone: mask.getMaskedString(phoneField.text),
        showDate: DateTime.now(),
      );
      final data = await FirebaseFirestore.instance.collection('tickets').add(ticket.toMap()..remove('id'));
      Get.snackbar('Ticket creado correctamente', 'Cliente: ${ticket.clientName}', colorText: Colors.white, backgroundColor: kSuccessColor);
      await TicketShare.show(ticket.copyWith(id: data.id));
      clearForm();
      buttonKey.currentState?.setStatus(CustomButtonStatus.IDLE);
    }
  }

  Future<void> deleteTicket(Ticket ticket) async {
    await FirebaseFirestore.instance.doc('tickets/${ticket.id}').delete();
  }

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      showCamera(tabController.index == 1);
    });
    super.onInit();
  }

  Future<void> logOut() async {
    await SessionService.to.logOut();
    Get.offAndToNamed(Routes.ACCESS);
  }
}
