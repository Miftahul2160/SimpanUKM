class BorrowItem {
  final int id;
  final int userId;
  final int itemId;
  final String status; // pending, approved, returned
  final String borrowDate;
  final String returnDate;

  BorrowItem({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.status,
    required this.borrowDate,
    required this.returnDate,
  });

  factory BorrowItem.fromJson(Map<String, dynamic> json) {
    return BorrowItem(
      id: json['id'],
      userId: json['user_id'],
      itemId: json['item_id'],
      status: json['status'],
      borrowDate: json['borrow_date'],
      returnDate: json['return_date'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "item_id": itemId,
        "status": status,
        "borrow_date": borrowDate,
        "return_date": returnDate,
      };
}
