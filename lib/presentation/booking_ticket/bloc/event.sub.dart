class Seat {
  final int seatId;

  const Seat({required this.seatId});

  Map<String, dynamic> toJson() {
    return {'seat_id': seatId};
  }
}

class FAB {
  final int fABId;
  final int quantity;

  const FAB({required this.fABId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {'fab_id': fABId, 'quantity': quantity};
  }
}
