import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kaki_boletos/config/app_pages.dart';
import 'package:kaki_boletos/config/app_themes.dart';
import 'package:kaki_boletos/utils/ui_utils.dart';
import 'services/repository_service.dart';
import 'services/session_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initServices();
  setScreenColors(statusBar: kPrimaryColor.variants.light, navigationBar: kSecondaryColor);
  runApp(const KakiBoletos());
}

Future<void> initServices() async {
  await GetStorage.init();
  await Firebase.initializeApp();
  await Get.putAsync(() => SessionService().init());
  await Get.putAsync(() => RepositoryService().init());
}

class KakiBoletos extends StatelessWidget {
  const KakiBoletos({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.main,
        getPages: AppPages.routes,
        initialRoute: SessionService.to.loggedIn ? Routes.HOME : Routes.ACCESS,
      ),
    );
  }
}
