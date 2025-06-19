import 'package:equatable/equatable.dart';

class FABProduct extends Equatable {
  final int id;
  final String name;
  final String type;
  final String imageUrl;
  final int price;

  const FABProduct({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
    required this.price,
  });

  factory FABProduct.fromJson(Map<String, dynamic> json) {
    return FABProduct(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      imageUrl: json['image_url'] as String,
      price: (json['price'] as int) * 1000,
    );
  }

  @override
  List<Object> get props => [id, name, type, imageUrl, price];
}

class BasicFABInfo {
  final String fABName;
  final int quantity;

  const BasicFABInfo({required this.fABName, required this.quantity});

  factory BasicFABInfo.fromJson(Map<String, dynamic> json) {
    return BasicFABInfo(
      fABName: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': fABName, 'quantity': quantity};
  }
}
