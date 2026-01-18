import 'package:flutter/material.dart';
import 'package:simpanukm_uas_pam/data/models/borrow.dart';
import 'package:simpanukm_uas_pam/data/models/item.dart';
import 'package:simpanukm_uas_pam/data/services/borrow_service.dart';
import 'package:simpanukm_uas_pam/data/services/item_service.dart';


class BorrowRequestPage extends StatefulWidget {
  final int userId;

  const BorrowRequestPage({super.key, required this.userId});

  @override
  State<BorrowRequestPage> createState() => _BorrowRequestPageState();
}

class _BorrowRequestPageState extends State<BorrowRequestPage> {
  final itemService = ItemService();
  final borrowService = BorrowService();

  List<Item> items = [];
  Item? selectedItem;

  DateTime? borrowDate;
  DateTime? returnDate;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    items = await itemService.getItems();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> submitBorrow() async {
    if (selectedItem == null || borrowDate == null || returnDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Lengkapi form")));
      return;
    }

    final borrow = BorrowItem(
      id: 0,
      userId: widget.userId,
      itemId: int.parse(selectedItem!.id),
      status: "pending",
      borrowDate: borrowDate!.toIso8601String(),
      returnDate: returnDate!.toIso8601String(),
    );

    final success = await borrowService.requestBorrow(borrow);

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Pengajuan dikirim")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Gagal mengirim")));
    }
  }

  Future<void> pickDate(bool isBorrow) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        if (isBorrow) {
          borrowDate = date;
        } else {
          returnDate = date;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pinjam Barang")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<Item>(
                    value: selectedItem,
                    items: items
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text("${item.name} (stok: ${item.quantityTotal})"),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedItem = value;
                        if (selectedItem != null && selectedItem!.quantityTotal == 0) {
                          selectedItem = null;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Barang tidak tersedia")),
                          );
                        }
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Pilih Barang",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  ListTile(
                    title: Text(
                        "Tanggal Pinjam: ${borrowDate != null ? borrowDate!.toLocal().toString().split(' ')[0] : '-'}"),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => pickDate(true),
                  ),

                  ListTile(
                    title: Text(
                        "Tanggal Kembali: ${returnDate != null ? returnDate!.toLocal().toString().split(' ')[0] : '-'}"),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => pickDate(false),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submitBorrow,
                      child: const Text("Ajukan Peminjaman"),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
