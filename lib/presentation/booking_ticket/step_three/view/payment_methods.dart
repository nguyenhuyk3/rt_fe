part of 'view.dart';

enum PaymentMethod { zaloPay, moMo, shopeePay, atmCard, international }

extension PaymentMethodExtension on PaymentMethod {
  String get title {
    switch (this) {
      case PaymentMethod.zaloPay:
        return 'ZaloPay';
      case PaymentMethod.moMo:
        return 'MoMo';
      case PaymentMethod.shopeePay:
        return 'ShopeePay';
      case PaymentMethod.atmCard:
        return 'ATM Card';
      case PaymentMethod.international:
        return 'International payments';
    }
  }

  String get value {
    switch (this) {
      case PaymentMethod.zaloPay:
        return 'ZaloPay';
      case PaymentMethod.moMo:
        return 'MoMo';
      case PaymentMethod.shopeePay:
        return 'ShopeePay';
      case PaymentMethod.atmCard:
        return 'ATM';
      case PaymentMethod.international:
        return 'International';
    }
  }

  String get iconPath {
    switch (this) {
      case PaymentMethod.zaloPay:
        return 'assets/zalopay.png';
      case PaymentMethod.moMo:
        return 'assets/momo.png';
      case PaymentMethod.shopeePay:
        return 'assets/shopeepay.png';
      case PaymentMethod.atmCard:
        return 'assets/atm.png';
      case PaymentMethod.international:
        return 'assets/visa.png';
    }
  }

  String? get subtitle {
    switch (this) {
      case PaymentMethod.international:
        return 'Visa, Master, JCB, Amex';
      default:
        return null;
    }
  }
}

class _PaymentMethodsSection extends StatelessWidget {
  const _PaymentMethodsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phương thức thanh toán',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 12),

        _PaymentMethodsList(),
      ],
    );
  }
}

class _PaymentMethodsList extends StatelessWidget {
  const _PaymentMethodsList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeTabCubit<PaymentMethod>, PaymentMethod>(
      builder: (context, selectedPaymentMethod) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent, width: 1),
          ),
          child: Column(
            children:
                PaymentMethod.values.asMap().entries.map((entry) {
                  final index = entry.key;
                  final paymentMethod = entry.value;

                  return Column(
                    children: [
                      _PaymentOption(
                        paymentMethod: paymentMethod,
                        isSelected: selectedPaymentMethod == paymentMethod,
                        onTap: () {
                          context
                              .read<ChangeTabCubit<PaymentMethod>>()
                              .changeTab(paymentMethod);
                        },
                      ),
                      // Add divider if not the last item
                      if (index < PaymentMethod.values.length - 1) _Divider(),
                    ],
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final PaymentMethod paymentMethod;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.paymentMethod,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange.withOpacity(0.1) : Colors.transparent,
        border: isSelected ? Border.all(color: Colors.amber, width: 1) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: getPaymentMethodColor(paymentMethod.value),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: _PaymentMethodIcon(method: paymentMethod.value)),
        ),
        title: Text(
          paymentMethod.title,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        subtitle:
            paymentMethod.subtitle != null
                ? Text(
                  paymentMethod.subtitle!,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                )
                : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey[800],
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}

class _PaymentMethodIcon extends StatelessWidget {
  final String method;

  const _PaymentMethodIcon({required this.method});

  @override
  Widget build(BuildContext context) {
    Widget icon;

    switch (method) {
      case 'ZaloPay':
        icon = Text(
          'Z',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        );
        break;
      case 'MoMo':
        icon = Text(
          'M',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        );
        break;
      case 'ShopeePay':
        icon = Icon(Icons.shopping_bag, color: Colors.white, size: 20);
        break;
      case 'ATM':
        icon = Icon(Icons.credit_card, color: Colors.white, size: 20);
        break;
      case 'International':
        icon = Icon(Icons.payment, color: Colors.white, size: 20);
        break;
      default:
        icon = Icon(Icons.payment, color: Colors.white, size: 20);
    }

    return icon;
  }
}

class _PaymentButton extends StatelessWidget {
  const _PaymentButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeTabCubit<PaymentMethod>, PaymentMethod>(
      builder: (context, selectedPaymentMethod) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: ElevatedButton(
            onPressed: () {
              context.read<BookingTicketBloc>().add(
                BookingTicketCreteOrder(
                  showtimeId:
                      context.read<BookingTicketBloc>().state.showtimeId,
                  showDate: context.read<BookingTicketBloc>().state.showDate,
                  seats:
                      context
                          .read<BookingTicketBloc>()
                          .state
                          .seats
                          .map((seat) => seat.toSeat())
                          .toList(),
                  fABs:
                      context
                          .read<BookingTicketBloc>()
                          .state
                          .fABs
                          .map((fab) => fab.toFAB())
                          .toList(),
                ),
              );
              _handlePayment(context, selectedPaymentMethod);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'Thanh toán',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  void _handlePayment(BuildContext context, PaymentMethod paymentMethod) {
    // Xử lý thanh toán dựa vào payment method được chọn
    switch (paymentMethod) {
      case PaymentMethod.zaloPay:
        // Xử lý thanh toán ZaloPay
        print('Processing ZaloPay payment...');
        break;
      case PaymentMethod.moMo:
        // Xử lý thanh toán MoMo
        logger.i('Processing MoMo payment...');

        final paymentBloc = context.read<PaymentBloc>();

        paymentBloc.add(
          PaymentCreated(
            orderId: 6, // Thay bằng orderId thực tế
            amount: 100249, // Thay bằng số tiền thực tế
            accessToken:
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImM4YTM5Y2ZkLTlhZWQtNDc5NC04NmJlLTljZTcxZDBmOTcyMCIsImlzcyI6ImE0MDRmMWMxLTcwNTgtNGFmNy05NzZhLTNhYWY2Zjc0MmZlOCIsImVtYWlsIjoiaHV5a2ltY3Vvbmc1QGdtYWlsLmNvbSIsInJvbGUiOiJjdXN0b21lciIsImlzc3VlZF9hdCI6IjIwMjUtMDYtMTRUMTg6NDI6NTUuOTY2NjA2MSswNzowMCIsImlzc3VlZCI6MTc0OTkwMTM3NSwiZXhwaXJlZF9hdCI6IjIwMjUtMDYtMTZUMjA6NDI6NTUuOTY2NjA2MSswNzowMCIsImV4cCI6MTc1MDA4MTM3NX0.4Aj8X7Jkiyzvfz0e1PBRxN97EX1s9urZQL-ucQn-xlk', // Lấy từ Auth
          ),
        );

        break;
      case PaymentMethod.shopeePay:
        // Xử lý thanh toán ShopeePay
        print('Processing ShopeePay payment...');
        break;
      case PaymentMethod.atmCard:
        // Xử lý thanh toán ATM Card
        print('Processing ATM Card payment...');
        break;
      case PaymentMethod.international:
        // Xử lý thanh toán International
        print('Processing International payment...');
        break;
    }
  }
}
