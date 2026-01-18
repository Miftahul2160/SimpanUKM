class BorrowHistory {
  final int id;
  final int borrowId;
  final String status;
  final String timestamp;

  BorrowHistory({
    required this.id,
    required this.borrowId,
    required this.status,
    required this.timestamp,
  });

  factory BorrowHistory.fromJson(Map<String, dynamic> json) {
    return BorrowHistory(
      id: json['id'],
      borrowId: json['borrow_id'],
      status: json['status'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "borrow_id": borrowId,
        "status": status,
        "timestamp": timestamp,
      };
}
