import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kaki_boletos/models/seller.dart';
import 'package:kaki_boletos/utils/printer.dart';

class SessionService extends GetxService {
  static SessionService get to => Get.find();
  Seller? seller;
  bool get loggedIn => seller != null;

  Future<SessionService> init() async {
    final uuid = GetStorage().read<String>('sellerUUID');
    final res = await FirebaseFirestore.instance.collection('sellers').doc(uuid).get();
    if (res.exists) seller = Seller.fromMap({'id': res.id, ...res.data()!});
    return this;
  }

  Future<bool> logIn(String name) async {
    try {
      final res = await FirebaseFirestore.instance.collection('sellers').where('name', isEqualTo: name).limit(1).get();
      if (res.docs.isNotEmpty) {
        final data = res.docs.first;
        seller = Seller.fromMap({'id': data.id, ...data.data()});
      } else {
        final user = await FirebaseFirestore.instance.collection('sellers').add(Seller(name: name).toMap()..remove('id'));
        final data = await user.get();
        seller = Seller.fromMap({'id': data.id, ...data.data()!});
      }
      await GetStorage().write('sellerUUID', seller!.id);
      return true;
    } catch (error) {
      Printer.error(error);
      return false;
    }
  }

  Future<void> logOut() async {
    await GetStorage().remove('sellerUUID');
    seller = null;
  }
}
