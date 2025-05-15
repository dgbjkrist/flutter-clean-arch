import '../../domain/entities/transfer.dart';

class TransferModel {
  final String senderId;
  final String recipientId;
  final double amount;
  final DateTime timestamp;

  const TransferModel({
    required this.senderId,
    required this.recipientId,
    required this.amount,
    required this.timestamp,
  });

  // From domain
  factory TransferModel.fromDomain(Transfer transfer) => TransferModel(
        senderId: transfer.senderId,
        recipientId: transfer.recipientId,
        amount: transfer.amount,
        timestamp: transfer.timestamp,
      );

  // To domain
  Transfer toDomain() => Transfer(
        senderId: senderId,
        recipientId: recipientId,
        amount: amount,
        timestamp: timestamp,
      );

  // From JSON
  factory TransferModel.fromJson(Map<String, dynamic> json) => TransferModel(
        senderId: json['senderId'] as String,
        recipientId: json['recipientId'] as String,
        amount: (json['amount'] as num).toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  // To JSON
  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'recipientId': recipientId,
        'amount': amount,
        'timestamp': timestamp.toIso8601String(),
      };

  // Equality and toString methods
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransferModel &&
          other.senderId == senderId &&
          other.recipientId == recipientId &&
          other.amount == amount &&
          other.timestamp == timestamp;

  @override
  int get hashCode => Object.hash(senderId, recipientId, amount, timestamp);

  @override
  String toString() =>
      'TransferModel(senderId: $senderId, recipientId: $recipientId, amount: $amount, timestamp: $timestamp)';
}
