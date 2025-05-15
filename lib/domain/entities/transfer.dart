class Transfer {
  final String senderId;
  final String recipientId;
  final double amount;
  final DateTime timestamp;

  const Transfer({
    required this.senderId,
    required this.recipientId,
    required this.amount,
    required this.timestamp,
  });

  // Manual copyWith method
  Transfer copyWith({
    String? senderId,
    String? recipientId,
    double? amount,
    DateTime? timestamp,
  }) {
    return Transfer(
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Manual equality
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transfer &&
          other.senderId == senderId &&
          other.recipientId == recipientId &&
          other.amount == amount &&
          other.timestamp == timestamp;

  @override
  int get hashCode => Object.hash(senderId, recipientId, amount, timestamp);

  @override
  String toString() =>
      'Transfer(senderId: $senderId, recipientId: $recipientId, amount: $amount, timestamp: $timestamp)';
}
