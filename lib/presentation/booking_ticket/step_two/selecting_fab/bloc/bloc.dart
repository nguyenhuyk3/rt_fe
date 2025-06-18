import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_mobile/core/constants/others.dart';
import 'package:rt_mobile/data/models/product/cart.dart';

import 'package:rt_mobile/data/models/product/fab.product.dart';
import 'package:rt_mobile/data/repositories/fab_repository.dart';

part 'event.dart';
part 'state.dart';

class SelectingFABBloc extends Bloc<SelectingFABEvent, SelectingFABState> {
  final FABRepository fABRepository;

  SelectingFABBloc({required this.fABRepository})
    : super(const SelectingFABState()) {
    on<SelectingFABLoadFoodItems>(_onLoadFoodItems);
    on<SelectingFABAddToCart>(_onAddToCart);
    on<SelectingFABRemoveFromCart>(_onRemoveFromCart);
    on<SelectingFABClearCart>(_onClearCart);
    on<SelectingFABProcessOrder>(_onProcessOrder);
  }

  FutureOr<void> _onLoadFoodItems(
    SelectingFABLoadFoodItems event,
    Emitter<SelectingFABState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final allFABs = await fABRepository.getAllFABs();

      logger.d(allFABs);

      emit(state.copyWith(fABItems: allFABs, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onAddToCart(
    SelectingFABAddToCart event,
    Emitter<SelectingFABState> emit,
  ) {
    final currentCart = List<CartItem>.from(state.cart);
    final existingIndex = currentCart.indexWhere(
      (cartItem) => cartItem.fABProduct.id == event.item.id,
    );

    if (existingIndex >= 0) {
      currentCart[existingIndex] = currentCart[existingIndex].copyWith(
        quantity: currentCart[existingIndex].quantity + 1,
      );
    } else {
      currentCart.add(CartItem(fABProduct: event.item));
    }

    final totalAmount = _calculateTotal(currentCart);

    emit(state.copyWith(cart: currentCart, totalAmount: totalAmount));
  }

  FutureOr<void> _onRemoveFromCart(
    SelectingFABRemoveFromCart event,
    Emitter<SelectingFABState> emit,
  ) {
    final currentCart = List<CartItem>.from(state.cart);
    final cartItem = event.cartItem;

    if (cartItem.quantity > 1) {
      final index = currentCart.indexWhere(
        (item) => item.fABProduct.id == cartItem.fABProduct.id,
      );
      if (index >= 0) {
        currentCart[index] = cartItem.copyWith(quantity: cartItem.quantity - 1);
      }
    } else {
      currentCart.removeWhere(
        (item) => item.fABProduct.id == cartItem.fABProduct.id,
      );
    }

    final totalAmount = _calculateTotal(currentCart);

    emit(state.copyWith(cart: currentCart, totalAmount: totalAmount));
  }

  FutureOr<void> _onClearCart(
    SelectingFABClearCart event,
    Emitter<SelectingFABState> emit,
  ) {
    emit(state.copyWith(cart: [], totalAmount: 0.0, orderProcessed: false));
  }

  void _onProcessOrder(
    SelectingFABProcessOrder event,
    Emitter<SelectingFABState> emit,
  ) {
    emit(state.copyWith(orderProcessed: true));
  }

  double _calculateTotal(List<CartItem> cart) {
    return cart.fold(
      0.0,
      (sum, item) => sum + (item.fABProduct.price * item.quantity),
    );
  }
}
