import 'package:flutter/material.dart';

class PendingBorrowCard extends StatelessWidget {
  final String borrowerName;
  final String itemName;
  final String date;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const PendingBorrowCard({
    super.key,
    required this.borrowerName,
    required this.itemName,
    required this.date,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              borrowerName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Barang: $itemName'),
            Text('Tanggal: $date'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onReject,
                  child: const Text('Tolak'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onApprove,
                  child: const Text('Setujui'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
