import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rt_mobile/data/models/product/cart.dart';
import 'package:rt_mobile/data/models/product/fab.product.dart';
import 'package:rt_mobile/data/repositories/payment.dart';
import 'package:rt_mobile/presentation/booking_ticket/bloc/bloc.dart';
import 'package:rt_mobile/presentation/booking_ticket/step_three/bloc/bloc.dart';
import 'package:rt_mobile/presentation/booking_ticket/step_three/step_three.dart';
import 'package:rt_mobile/presentation/booking_ticket/step_three/view/view.dart';
import 'package:rt_mobile/presentation/booking_ticket/step_two/selecting_fab/bloc/bloc.dart';
import 'package:rt_mobile/presentation/cubit/change_tab/change_tab.dart';
import 'package:rt_mobile/presentation/widgets/snack_bar.dart';

class SelectingFABScreen extends StatelessWidget {
  const SelectingFABScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _CinemaSelectingFABView();
  }
}

class _CinemaSelectingFABView extends StatelessWidget {
  const _CinemaSelectingFABView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Đặt đồ ăn',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          actions: [
            BlocBuilder<SelectingFABBloc, SelectingFABState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    IconButton(
                      onPressed: () => _showCart(context),
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                    ),
                    if (state.cart.isNotEmpty)
                      // This will show quantity of ordering
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            state.cart
                                .fold(0, (sum, item) => sum + item.quantity)
                                .toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Material(
              color: Colors.black,
              elevation: 0,
              child: const TabBar(
                indicatorColor: Colors.yellowAccent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(text: 'Tất cả'),
                  Tab(text: 'Đồ ăn'),
                  Tab(text: 'Đồ uống'),
                ],
              ),
            ),
          ),
        ),
        body: BlocListener<SelectingFABBloc, SelectingFABState>(
          listener: (context, state) {
            if (state.orderProcessed) {
              _showOrderSuccessDialog(context);
            }
          },
          child: const TabBarView(
            children: [
              _FoodGridView(type: 'All'),
              _FoodGridView(type: 'food'),
              _FoodGridView(type: 'beverage'),
            ],
          ),
        ),
      ),
    );
  }

  void _showCart(BuildContext context) {
    final selectingBloc = context.read<SelectingFABBloc>();
    final bookingBloc = context.read<BookingTicketBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: selectingBloc),
            BlocProvider.value(value: bookingBloc),
          ],
          child: const _CartBottomSheet(),
        );
      },
    );
  }

  void _showOrderSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Đặt hàng thành công!'),
            content: Text(
              '${context.read<BookingTicketBloc>().state.totalAmount}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigator.pop(context);
                  // context.read<SelectingFABBloc>().add(SelectingFABClearCart());
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}

class _FoodGridView extends StatelessWidget {
  final String type;

  const _FoodGridView({required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectingFABBloc, SelectingFABState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = _getItemsByType(state.fABItems, type);

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _FABItemCard(item: item);
          },
        );
      },
    );
  }

  List<FABProduct> _getItemsByType(List<FABProduct> foodItems, String type) {
    if (type == 'All') {
      return foodItems;
    }

    return foodItems.where((item) => item.type == type).toList();
  }
}

class _FABItemCard extends StatelessWidget {
  final FABProduct item;

  const _FABItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  cacheHeight: 300,
                  cacheWidth: 300,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} VNĐ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<SelectingFABBloc>().add(
                              SelectingFABAddToCart(item),
                            );
                            context.read<BookingTicketBloc>().add(
                              BookingTicketAddFABToOrder(fAB: item),
                            );

                            customSnackBarWithWidth(
                              context: context,
                              width: 0.000001,
                              isSuccess: true,
                              message: '${item.name} đã được thêm vào giỏ hàng',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amberAccent,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartBottomSheet extends StatelessWidget {
  const _CartBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Giỏ hàng của bạn',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<SelectingFABBloc, SelectingFABState>(
              builder: (context, state) {
                if (state.cart.isEmpty) {
                  return Container(
                    color: Colors.black87,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Giỏ hàng trống',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Container(
                  color: Colors.black87,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.cart.length,
                    itemBuilder: (context, index) {
                      final cartItem = state.cart[index];

                      return _CartItemCard(cartItem: cartItem);
                    },
                  ),
                );
              },
            ),
          ),

          BlocBuilder<SelectingFABBloc, SelectingFABState>(
            builder: (context, state) {
              if (state.cart.isEmpty) return const SizedBox.shrink();

              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tạm tính:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${state.totalAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} VNĐ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // continue button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider.value(
                                        value:
                                            context.read<BookingTicketBloc>(),
                                      ),
                                      BlocProvider(
                                        create:
                                            (_) =>
                                                ChangeTabCubit<PaymentMethod>(
                                                  initialState:
                                                      PaymentMethod.moMo,
                                                ),
                                      ),
                                      BlocProvider(
                                        create:
                                            (context) => PaymentBloc(
                                              paymentRepository:
                                                  RepositoryProvider.of<
                                                    PaymentRepository
                                                  >(context),
                                            ),
                                      ),
                                    ],
                                    child: StepThreeScreen(),
                                  ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amberAccent,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Tiếp tục',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  const _CartItemCard({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                cartItem.fABProduct.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.fABProduct.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(height: 18),

                  Text(
                    '${cartItem.fABProduct.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} VNĐ',
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                // subtract fab within _CartBottomSheet
                IconButton(
                  onPressed: () {
                    context.read<SelectingFABBloc>().add(
                      SelectingFABRemoveFromCart(cartItem),
                    );
                    context.read<BookingTicketBloc>().add(
                      BookingTicketRemoveFABFromOrder(fAB: cartItem),
                    );
                  },

                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  cartItem.quantity.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // add new fab within _CartBottomSheet
                IconButton(
                  onPressed: () {
                    context.read<SelectingFABBloc>().add(
                      SelectingFABAddToCart(cartItem.fABProduct),
                    );
                    context.read<BookingTicketBloc>().add(
                      BookingTicketAddFABToOrder(fAB: (cartItem.fABProduct)),
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
