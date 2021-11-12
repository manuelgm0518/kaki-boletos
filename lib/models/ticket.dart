import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaki_boletos/services/repository_service.dart';
import 'package:kaki_boletos/services/session_service.dart';

class Ticket {
  final String? id;
  final DateTime soldTime;
  final String seller;
  final int seatingsCount;
  final String clientName;
  final String clientPhone;
  final DateTime showDate;
  final DateTime? checkedAt;
  final String? checkedBy;

  bool get checked => checkedAt != null && checkedBy != null;
  String get sellerName => RepositoryService.to.sellers.singleWhere((element) => element.id == seller, orElse: () => SessionService.to.seller!).name;

  const Ticket._({
    required this.id,
    required this.soldTime,
    required this.seller,
    required this.seatingsCount,
    required this.clientName,
    required this.clientPhone,
    required this.showDate,
    this.checkedAt,
    this.checkedBy,
  });

  Ticket({
    required this.seller,
    required this.seatingsCount,
    required this.clientName,
    required this.clientPhone,
    required this.showDate,
  })  : id = null,
        soldTime = DateTime.now(),
        checkedAt = null,
        checkedBy = null;

  Ticket copyWith({
    String? id,
    DateTime? soldTime,
    String? seller,
    int? seatingsCount,
    String? clientName,
    String? clientPhone,
    DateTime? checkedAt,
    String? checkedBy,
    DateTime? showDate,
  }) {
    return Ticket._(
      id: id ?? this.id,
      soldTime: soldTime ?? this.soldTime,
      seller: seller ?? this.seller,
      seatingsCount: seatingsCount ?? this.seatingsCount,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      checkedAt: checkedAt ?? this.checkedAt,
      checkedBy: checkedBy ?? this.checkedBy,
      showDate: showDate ?? this.showDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'soldTime': soldTime,
      'seller': seller,
      'seatingsCount': seatingsCount,
      'clientName': clientName,
      'clientPhone': clientPhone,
      'checkedAt': checkedAt,
      'checkedBy': checkedBy,
      'showDate': showDate,
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket._(
      id: map['id'],
      soldTime: (map['soldTime'] as Timestamp).toDate(),
      seller: map['seller'] ?? '',
      seatingsCount: map['seatingsCount'] ?? 0,
      clientName: map['clientName'] ?? '',
      clientPhone: map['clientPhone'] ?? '',
      checkedAt: (map['checkedAt'] as Timestamp?)?.toDate(),
      checkedBy: map['checkedBy'],
      showDate: (map['showDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Ticket(id: $id, soldTime: $soldTime, seller: $seller, seatingsCount: $seatingsCount, clientName: $clientName, clientPhone: $clientPhone, checkedAt: $checkedAt, checkedBy: $checkedBy, showDate: $showDate)';
  }
}
