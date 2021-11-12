class Seller {
  final String? id;
  final String name;

  const Seller._({
    required this.id,
    required this.name,
  });

  const Seller({
    required this.name,
  }) : id = null;

  Seller copyWith({
    String? name,
  }) {
    return Seller._(
      id: id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Seller.fromMap(Map<String, dynamic> map) {
    return Seller._(
      id: map['id'],
      name: map['name'] ?? '',
    );
  }

  @override
  String toString() => 'Seller(id: $id, name: $name)';
}
