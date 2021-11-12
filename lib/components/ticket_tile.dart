import 'package:collapsible/collapsible.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kaki_boletos/components/custom_button.dart';
import 'package:kaki_boletos/components/ticket_share.dart';
import 'package:kaki_boletos/config/app_themes.dart';
import 'package:kaki_boletos/models/ticket.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: kRoundedBorder),
      padding: kPadding4,
      child: Column(children: [
        Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(widget.ticket.clientName, style: Get.textTheme.headline6, overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis, softWrap: expanded),
            Text(DateFormat('dd / MM / yy').format(widget.ticket.showDate), style: const TextStyle(color: kPrimaryColor)).left([
              const Icon(UniconsLine.calendar_alt, color: kPrimaryColor, size: 18).pr2,
            ]).py1,
          ]).expanded(),
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
            Row(children: [
              CustomButton.outline(
                child: const Icon(UniconsLine.trash_alt),
                color: kErrorColor,
                onPressed: () {},
              ),
              kSpacerX,
              CustomButton.outline(
                prefix: const Icon(UniconsLine.qrcode_scan),
                child: const Text('Mostar código'),
                color: kSecondaryColor,
                onPressed: () => TicketShare.show(widget.ticket),
              ).expanded(),
            ]),
          ]),
        ),
      ]),
    ).mouse(() {
      setState(() => expanded = !expanded);
    });
  }
}
