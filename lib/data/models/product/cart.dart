import 'package:equatable/equatable.dart';

import 'package:rt_mobile/data/models/product/fab.product.dart';
import 'package:rt_mobile/presentation/booking_ticket/bloc/event.sub.dart';

class CartItem extends Equatable {
  final FABProduct fABProduct;
  final int quantity;

  const CartItem({required this.fABProduct, this.quantity = 1});

  CartItem copyWith({int? quantity}) {
    return CartItem(
      fABProduct: fABProduct,
      quantity: quantity ?? this.quantity,
    );
  }

  FAB toFAB() {
    return FAB(fABId: fABProduct.id, quantity: quantity);
  }

  @override
  List<Object> get props => [fABProduct, quantity];
}
