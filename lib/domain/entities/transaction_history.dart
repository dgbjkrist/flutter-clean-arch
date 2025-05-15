class TransactionHistory {
  final String type;
  final double amount;
  final String assetCode;
  final DateTime timestamp;
  final String from;
  final String to;
  final String? memo;

  const TransactionHistory({
    required this.type,
    required this.amount,
    required this.assetCode,
    required this.timestamp,
    required this.from,
    required this.to,
    this.memo,
  });

  // Add a copyWith method for convenience
  TransactionHistory copyWith({
    String? type,
    double? amount,
    String? assetCode,
    DateTime? timestamp,
    String? from,
    String? to,
    String? memo,
  }) {
    return TransactionHistory(
      type: type ?? this.type,
      amount: amount ?? this.amount,
      assetCode: assetCode ?? this.assetCode,
      timestamp: timestamp ?? this.timestamp,
      from: from ?? this.from,
      to: to ?? this.to,
      memo: memo ?? this.memo,
    );
  }

  // Add equality operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionHistory &&
          type == other.type &&
          amount == other.amount &&
          assetCode == other.assetCode &&
          timestamp == other.timestamp &&
          from == other.from &&
          to == other.to &&
          memo == other.memo;

  @override
  int get hashCode =>
      type.hashCode ^
      amount.hashCode ^
      assetCode.hashCode ^
      timestamp.hashCode ^
      from.hashCode ^
      to.hashCode ^
      memo.hashCode;

  // Add toString method for debugging
  @override
  String toString() {
    return 'TransactionHistory('
        'type: $type, '
        'amount: $amount, '
        'assetCode: $assetCode, '
        'timestamp: $timestamp, '
        'from: $from, '
        'to: $to, '
        'memo: $memo)';
  }
}
