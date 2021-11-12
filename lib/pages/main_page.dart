import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaki_boletos/components/ticket_tile.dart';
import 'package:kaki_boletos/config/app_themes.dart';
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
            background: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.max, children: [
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
                          '(${controller.tickets.length})',
                          style: Get.textTheme.headline5?.copyWith(color: Colors.white30),
                        ).px2,
                        kSpacer,
                        IconButton(
                            icon: const Icon(UniconsLine.check_circle),
                            color: controller.onlyChecked.value ? kSuccessColor : Colors.white30,
                            onPressed: () => controller.onlyChecked.toggle())
                      ])).px4,
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










// return DefaultTabController(
//   length: 3,
//   child: Scaffold(
//     resizeToAvoidBottomInset: false,
//     backgroundColor: kPrimaryColor,
//     body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.max, children: [
//       Container(
//         color: Colors.white,
//         child: Column(children: [
//           Row(children: [
//             Text(
//               SessionService.to.seller!.name,
//               style: Get.textTheme.headline5,
//             ),
//             kSpacer,
//             IconButton(
//               icon: const Icon(UniconsLine.sign_out_alt),
//               onPressed: () => controller.logOut(),
//             )
//           ]).pxy(4, 3).safeArea(),
//           const TabBarView(children: [
//             SellPage(),
//             AssistancePage(),
//             SoldPage(),
//           ]).expanded(),
//         ]),
//       ).rounded().expanded(),
//       TabBar(
//         padding: kPadding4,
//         labelColor: Colors.white,
//         unselectedLabelColor: Colors.white,
//         tabs: const [
//           Tab(icon: Icon(UniconsLine.ticket)),
//           Tab(icon: Icon(UniconsLine.user_check)),
//           Tab(icon: Icon(UniconsLine.bill)),
//         ],
//         indicator: RectangularIndicator(
//           color: Colors.white.withOpacity(0.25),
//           topLeftRadius: kBorderRadius,
//           topRightRadius: kBorderRadius,
//           bottomLeftRadius: kBorderRadius,
//           bottomRightRadius: kBorderRadius,
//           paintingStyle: PaintingStyle.fill,
//         ),
//       ),
//     ]),
//   ),
// );
//   }
// }
