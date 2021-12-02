import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collapsible/collapsible.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kaki_boletos/components/custom_button.dart';
import 'package:kaki_boletos/components/ticket_share.dart';
import 'package:kaki_boletos/config/app_themes.dart';
import 'package:kaki_boletos/models/ticket.dart';
import 'package:kaki_boletos/pages/main_page.dart';
import 'package:kaki_boletos/utils/format_utils.dart';
import 'package:kaki_boletos/utils/ui_utils.dart';
import 'package:unicons/unicons.dart';

class TicketTile extends StatefulWidget {
  const TicketTile(this.ticket, {Key? key}) : super(key: key);
  final Ticket ticket;

  @override
  _TicketTileState createState() => _TicketTileState();
}

class _TicketTileState extends State<TicketTile> {
  bool expanded = false;
  bool deleting = false;
  bool confirmDelete = false;
  DateTime get showDate => widget.ticket.showDate;

  Future<void> delete() async {
    if (!confirmDelete) {
      setState(() => confirmDelete = true);
    } else {
      setState(() => deleting = true);
      await FirebaseFirestore.instance.collection('tickets').doc(widget.ticket.id).delete();
      setState(() => deleting = false);
    }
  }

  Future<void> updateDate() async {
    final date = (showDate.day == 25 && showDate.month == 11) ? DateTime(2021, 12, 1) : DateTime(2021, 11, 25);
    await FirebaseFirestore.instance.collection('tickets').doc(widget.ticket.id).update({'showDate': date});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => updateDate(),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: kRoundedBorder),
        padding: kPadding4,
        child: Column(children: [
          Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(widget.ticket.clientName,
                  style: Get.textTheme.headline6, overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis, softWrap: expanded),
              Text(DateFormat('dd / MM / yy').format(widget.ticket.showDate), style: const TextStyle(color: kPrimaryColor)).left([
                const Icon(UniconsLine.calendar_alt, color: kPrimaryColor, size: 18).pr2,
              ]).py1,
            ]).expanded(),
            const Icon(UniconsLine.ticket, color: kSecondaryColor).bottom([
              Text(widget.ticket.seatingsCount.toString(), style: Get.textTheme.bodyText1?.copyWith(color: kSecondaryColor)),
            ], crossAxisAlignment: CrossAxisAlignment.center),
            Container(width: 1, color: kPrimaryColor.withOpacity(0.25), height: 45, margin: kPaddingX),
            Icon(
              widget.ticket.checked ? UniconsLine.check_circle : UniconsLine.circle,
              color: widget.ticket.checked ? kSuccessColor : Colors.grey,
            ),
          ]),
          Collapsible(
            collapsed: !expanded,
            axis: CollapsibleAxis.vertical,
            alignment: Alignment.topCenter,
            maintainState: true,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
              Text(widget.ticket.clientPhone, style: const TextStyle(color: kPrimaryColor)).left([
                const Icon(UniconsLine.phone, color: kPrimaryColor, size: 18).pr2,
              ]).py1,
              Text(widget.ticket.sellerName.capitalizeFirst!, style: const TextStyle(color: kPrimaryColor)).left([
                const Icon(UniconsLine.clipboard, color: kPrimaryColor, size: 18).pr2,
              ]).py1,
              Text(DateFormatter.getVerboseDateTimeRepresentation(widget.ticket.soldTime), style: const TextStyle(color: kPrimaryColor)).left([
                const Icon(UniconsLine.clock, color: kPrimaryColor, size: 18).pr2,
              ]).py1,
              kSpacerY,
              AnimatedCrossFade(
                crossFadeState: confirmDelete ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 150),
                firstChild: Row(children: [
                  CustomButton.outline(
                    child: const Icon(UniconsLine.times),
                    color: Colors.grey,
                    onPressed: () => setState(() => confirmDelete = false),
                  ),
                  kSpacerX,
                  CustomButton.elevated(
                    prefix: deleting ? null : const Icon(UniconsLine.trash_alt),
                    child: deleting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator()) : const Text('Eliminar'),
                    color: kErrorColor,
                    onPressed: () => delete(),
                  ).expanded(),
                ]),
                secondChild: Row(children: [
                  CustomButton.outline(
                    child: const Icon(UniconsLine.trash_alt),
                    color: kErrorColor,
                    onPressed: () => delete(),
                  ),
                  kSpacerX,
                  CustomButton.outline(
                    prefix: const Icon(UniconsLine.qrcode_scan),
                    child: const Text('Mostar código'),
                    color: kSecondaryColor,
                    onPressed: () => TicketShare.show(widget.ticket),
                  ).expanded(),
                ]),
              ),
            ]),
          ),
        ]),
      ).mouse(() {
        setState(() => expanded = !expanded);
      }),
    );
  }
}
