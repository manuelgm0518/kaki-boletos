import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kaki_boletos/models/seller.dart';
import 'package:kaki_boletos/models/ticket.dart';
import 'package:kaki_boletos/utils/printer.dart';

class RepositoryService extends GetxService {
  static RepositoryService get to => Get.find<RepositoryService>();

  var tickets = <Ticket>[].obs;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _ticketsListener;

  var sellers = <Seller>[].obs;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sellersListener;

  Future<RepositoryService> init() async {
    try {
      close();
      _ticketsListener = FirebaseFirestore.instance.collection('tickets').snapshots().listen((event) {
        for (var element in event.docChanges) {
          final ticket = Ticket.fromMap({'id': element.doc.id, ...element.doc.data()!});
          final index = tickets.indexWhere((element) => element.id == ticket.id);
          if (index != -1) {
            element.type == DocumentChangeType.removed ? tickets.removeAt(index) : tickets[index] = ticket;
          } else {
            tickets.add(ticket);
          }
        }
      });
      _sellersListener = FirebaseFirestore.instance.collection('sellers').snapshots().listen((event) {
        for (var element in event.docChanges) {
          final seller = Seller.fromMap({'id': element.doc.id, ...element.doc.data()!});
          final index = sellers.indexWhere((element) => element.id == seller.id);
          if (index != -1) {
            element.type == DocumentChangeType.removed ? sellers.removeAt(index) : sellers[index] = seller;
          } else {
            sellers.add(seller);
          }
        }
      });
      Printer.info('Repository loaded');
    } catch (error) {
      Printer.error(error);
    }
    return this;
  }

  Future<void> close() async {
    _ticketsListener?.cancel();
    _sellersListener?.cancel();
    tickets.clear();
  }
}
