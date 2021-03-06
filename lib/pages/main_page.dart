import 'package:auto_animated/auto_animated.dart';
import 'package:collapsible/collapsible.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kaki_boletos/components/custom_button.dart';
import 'package:kaki_boletos/components/ticket_tile.dart';
import 'package:kaki_boletos/config/app_themes.dart';
import 'package:kaki_boletos/models/ticket.dart';
import 'package:kaki_boletos/pages/main_controller.dart';
import 'package:kaki_boletos/pages/scan_ticket_view.dart';
import 'package:kaki_boletos/pages/sell_ticket_view.dart';
import 'package:kaki_boletos/services/session_service.dart';
import 'package:kaki_boletos/utils/ui_utils.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:unicons/unicons.dart';
export 'main_controller.dart';

const _kListItemDelay = Duration(milliseconds: 100);
final _kBackgroundColor = kSecondaryColor.variants.light;
final _backdropHeight = Get.height * 0.7;

class MainPage extends GetView<MainController> {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackgroundColor,
      body: CustomScrollView(physics: kBouncyScroll, slivers: [
        SliverAppBar(
          toolbarHeight: 60,
          collapsedHeight: 60,
          expandedHeight: _backdropHeight,
          leadingWidth: Get.width / 4,
          backgroundColor: _kBackgroundColor,
          foregroundColor: kSecondaryColor,
          primary: true,
          pinned: true,
          stretch: true,
          titleTextStyle: Get.textTheme.headline5?.copyWith(fontFamily: 'Limelight', color: kSecondaryColor),
          title: Text(SessionService.to.seller!.name.capitalizeFirst!),
          leading: Image.asset(
            'assets/app/logo.png',
            height: 60,
            isAntiAlias: true,
            filterQuality: FilterQuality.medium,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(UniconsLine.sign_out_alt),
              onPressed: () => controller.logOut(),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background:
                Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.max, children: [
              statusBarSpacer,
              const SizedBox(height: 60),
              kSpacerY,
              TabBarView(physics: kBouncyScroll, controller: controller.tabController, children: [
                const SellTicketView().px4,
                const ScanTicketView().px4,
              ]).flexible(),
            ]).height(_backdropHeight),
          ),
        ),
        SliverStack(insetOnOverlap: true, children: <Widget>[
          SliverPositioned.fill(
            child: Container(
              decoration: const BoxDecoration(color: kSecondaryColor, borderRadius: BorderRadius.vertical(top: Radius.circular(kBorderRadius))),
            ),
          ),
          MultiSliver(pushPinnedChildren: true, children: [
            SliverPinnedHeader(
              child: Container(
                decoration: const BoxDecoration(color: kSecondaryColor, borderRadius: kRoundedBorder),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Container(
                    width: 100,
                    height: 8,
                    margin: kPadding4,
                    decoration: const BoxDecoration(borderRadius: kRoundedBorder, color: Colors.white24),
                  ).centered(),
                  Obx(() => Row(children: [
                        Text(
                          'Boletos',
                          style: Get.textTheme.headline3?.copyWith(color: Colors.white, fontFamily: 'Limelight'),
                        ),
                        Text(
                          '(${controller.tickets.fold<int>(0, (previousValue, element) => previousValue + element.seatingsCount)})',
                          style: Get.textTheme.headline5?.copyWith(color: Colors.white30),
                        ).px2,
                        kSpacer,
                        IconButton(
                          icon: const Icon(UniconsLine.filter),
                          color: Colors.white30,
                          onPressed: () => controller.showFilters.toggle(),
                        ).pr1
                      ])).px4,
                  Obx(() => Collapsible(
                        collapsed: !controller.showFilters.value,
                        axis: CollapsibleAxis.vertical,
                        alignment: Alignment.topCenter,
                        maintainState: true,
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.white24, borderRadius: kRoundedBorder),
                          padding: kPadding4,
                          margin: kPadding4,
                          child: Row(children: [
                            Row(children: [
                              const Icon(UniconsLine.calendar_alt, color: Colors.white).pr2,
                              Text(controller.filterFirstDate.value ? '25 - Nov' : '01 - Dic', style: Get.textTheme.subtitle1?.copyWith(color: Colors.white)),
                            ]).mouse((() => controller.filterFirstDate.toggle())).expanded(),
                            Row(children: [
                              Icon(UniconsLine.check_circle, color: controller.onlyChecked.value ? kSuccessColor : Colors.white).pr2,
                              Text(
                                'Escaneados',
                                style: Get.textTheme.subtitle1?.copyWith(color: controller.onlyChecked.value ? kSuccessColor : Colors.white),
                              ),
                            ]).mouse((() => controller.onlyChecked.toggle())).expanded(),
                          ]),
                        ),
                      )),
                  const Divider(color: Colors.white12, thickness: 1, height: 0).px5,
                ]),
              ),
            ),
            sliverList(),
          ])
        ]),
      ]),
    );
  }
}

Widget sliverList() {
  final controller = Get.find<MainController>();
  return SliverPadding(
    padding: kPadding4,
    sliver: Obx(
      () => LiveSliverList(
        controller: controller.scrollController,
        showItemDuration: _kListItemDelay,
        showItemInterval: Duration.zero,
        itemCount: controller.tickets.length,
        itemBuilder: (context, index, animation) {
          final ticket = controller.tickets[index];
          return FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(animation),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.1),
                end: Offset.zero,
              ).animate(animation),
              child: TicketTile(ticket).pb,
            ),
          );
        },
      ),
    ),
  );
}

class ScannedTicket extends StatelessWidget {
  final Ticket? ticket;
  final ScannedTicketStatus status;
  const ScannedTicket._(this.ticket, this.status, {Key? key}) : super(key: key);
  static Future<dynamic> show(Ticket? ticket, ScannedTicketStatus status) async {
    return await Get.dialog(ScannedTicket._(ticket, status).centered().p4);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: status.color,
        borderRadius: kRoundedBorder,
      ),
      padding: kPadding4,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
        Text(
          status.message,
          style: Get.textTheme.headline4?.copyWith(color: Colors.white, fontFamily: 'LimeLight'),
          textAlign: TextAlign.center,
        ),
        kSpacerY,
        if (status == ScannedTicketStatus.success) ...[
          Text('Asientos:', textAlign: TextAlign.center, style: Get.textTheme.headline5?.copyWith(color: Colors.white)),
          Text(
            ticket!.seatingsCount.toString().padLeft(2, '0'),
            style: Get.textTheme.headline2?.copyWith(color: Colors.white),
          ).left([
            const Icon(UniconsLine.ticket, color: Colors.white, size: 40).pr2,
          ], mainAxisAlignment: MainAxisAlignment.center),
          Text('Funci??n:', textAlign: TextAlign.center, style: Get.textTheme.headline6?.copyWith(color: Colors.white)).pr.right([
            Text(DateFormat('dd-MM-yyyy').format(ticket!.showDate),
                textAlign: TextAlign.center, style: Get.textTheme.headline6?.copyWith(color: Colors.white, fontWeight: FontWeight.normal))
          ], mainAxisAlignment: MainAxisAlignment.center),
          kSpacerY2,
          Text('Cliente:', textAlign: TextAlign.center, style: Get.textTheme.headline6?.copyWith(color: Colors.white)).pr.right([
            Text(ticket!.clientName,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Get.textTheme.headline6?.copyWith(color: Colors.white, fontWeight: FontWeight.normal))
          ], mainAxisAlignment: MainAxisAlignment.center),
        ] else if (status == ScannedTicketStatus.alreadyChecked) ...[
          Text('Funci??n:', textAlign: TextAlign.center, style: Get.textTheme.headline6?.copyWith(color: Colors.white)).pr.right([
            Text(DateFormat('dd-MM-yyyy').format(ticket!.showDate),
                textAlign: TextAlign.center, style: Get.textTheme.headline6?.copyWith(color: Colors.white, fontWeight: FontWeight.normal))
          ], mainAxisAlignment: MainAxisAlignment.center),
          kSpacerY2,
          Text('Cliente:', textAlign: TextAlign.center, style: Get.textTheme.headline6?.copyWith(color: Colors.white)).pr.right([
            Text(ticket!.clientName, textAlign: TextAlign.center, style: Get.textTheme.headline6?.copyWith(color: Colors.white, fontWeight: FontWeight.normal))
                .flexible()
          ], mainAxisAlignment: MainAxisAlignment.center),
          kSpacerY3,
          Text('Escaneado:', textAlign: TextAlign.center, style: Get.textTheme.headline6?.copyWith(color: Colors.white)),
          Text("El d??a ${DateFormat('dd-MM-yyyy (hh:mm a)').format(ticket!.checkedAt!)}",
              textAlign: TextAlign.center, style: Get.textTheme.headline6?.copyWith(color: Colors.white, fontWeight: FontWeight.normal)),
          Text(
            "Por ${ticket!.sellerName.capitalize}",
            style: Get.textTheme.headline6?.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ] else ...[
          Text('Intenta escanearlo otra vez, de otro modo, este no es un c??digo v??lido',
              style: Get.textTheme.headline6?.copyWith(color: Colors.white, fontWeight: FontWeight.normal), textAlign: TextAlign.center),
        ],
        kSpacerY,
        const Divider(
          color: Colors.white,
          thickness: 1,
          height: 0,
        ).py4,
        CustomButton.elevated(
          child: Text('Aceptar', style: TextStyle(color: status.color)),
          color: Colors.white,
          onPressed: () => Get.back(),
        ),
      ]),
    );
  }
}

enum ScannedTicketStatus { alreadyChecked, invalid, success }

extension ScannedTicketStatusExtension on ScannedTicketStatus {
  Color get color {
    switch (this) {
      case ScannedTicketStatus.success:
        return kSuccessColor;
      case ScannedTicketStatus.invalid:
        return kErrorColor;
      case ScannedTicketStatus.alreadyChecked:
        return kWarningColor;
    }
  }

  String get message {
    switch (this) {
      case ScannedTicketStatus.success:
        return 'Boleto escaneado correctamente';
      case ScannedTicketStatus.invalid:
        return 'Boleto no reconocido';
      case ScannedTicketStatus.alreadyChecked:
        return 'Este boleto ya ha sido escaneado';
    }
  }
}
