// ignore_for_file: constant_identifier_names
import 'package:get/get.dart';
import 'package:kaki_boletos/pages/access/access_page.dart';
import 'package:kaki_boletos/pages/main_page.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.ACCESS,
      page: () => const AccessPage(),
      binding: BindingsBuilder<dynamic>(() {
        Get.put<AccessController>(AccessController());
      }),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const MainPage(),
      binding: BindingsBuilder<dynamic>(() {
        Get.put<MainController>(MainController());
      }),
    ),
  ];
}

abstract class Routes {
  static const ACCESS = '/access';
  static const HOME = '/';
}
