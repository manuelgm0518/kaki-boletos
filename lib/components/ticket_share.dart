import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaki_boletos/components/custom_button.dart';
import 'package:kaki_boletos/components/custom_title.dart';
import 'package:kaki_boletos/models/ticket.dart';
import 'package:kaki_boletos/utils/ui_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:unicons/unicons.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class TicketShare extends StatefulWidget {
  const TicketShare._(this.ticket, {Key? key}) : super(key: key);
  final Ticket ticket;

  static Future<void> show(Ticket ticket) async {
    Get.dialog(
      TicketShare._(ticket).centered(),
    );
  }

  @override
  _TicketShareState createState() => _TicketShareState();
}

class _TicketShareState extends State<TicketShare> {
  final GlobalKey qrKey = GlobalKey();

  Future<void> shareQR() async {
    final boundary = qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    final image = await boundary?.toImage();
    final byteData = await image?.toByteData(format: ImageByteFormat.png);
    final imageBytes = byteData?.buffer.asUint8List();
    if (imageBytes != null) {
      final directory = (await getApplicationDocumentsDirectory());
      final imagePath = await File('${directory.path}/qr_code.png').create();
      await imagePath.writeAsBytes(imageBytes);
      await Share.shareFiles(
        [imagePath.path],
        subject: 'Boleto función KAKI',
        text: 'Nombre: ${widget.ticket.clientName}\nLugares: ${widget.ticket.seatingsCount}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: kRoundedBorder),
      padding: kPadding4,
      margin: kPadding4,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
        CustomTitle(text1: 'Cliente', text2: widget.ticket.clientName),
        kSpacerY,
        RepaintBoundary(
          key: qrKey,
          child: QrImage(
            data: widget.ticket.id!,
            size: Get.width * 0.45,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ).centered(),
        kDivider.py,
        CustomButton.elevated(
          child: const Text('Compartir código'),
          prefix: const Icon(UniconsLine.share_alt),
          onPressed: () {
            shareQR();
          },
        ),
      ]),
    );
  }
}
