import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:simpanukm_uas_pam/data/models/item.dart';
import 'package:simpanukm_uas_pam/data/services/item_service.dart';

class ItemFormPage extends StatefulWidget {
  final Item? item;
  const ItemFormPage({this.item});

  @override
  State<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  final ItemService _itemService = ItemService();
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController nameController;
  late TextEditingController locationController;
  late TextEditingController stockController;
  
  File? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item?.name ?? '');
    locationController = TextEditingController(text: widget.item?.location ?? '');
    stockController = TextEditingController(text: widget.item?.stock.toString() ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final xfile = await picker.pickImage(source: ImageSource.gallery);
      if (xfile != null) {
        setState(() => _image = File(xfile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final name = nameController.text;
      final location = locationController.text;
      final stock = int.parse(stockController.text);

      bool success;

      if (widget.item == null) {
        // Create new item
        success = await _itemService.createItemWithImage(
          name,
          location,
          stock,
          _image,
        );
      } else {
        // Update existing item
        success = await _itemService.updateItemWithImage(
          widget.item!.id,
          name,
          location,
          stock,
          _image,
        );
      }

      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.item == null ? "Item berhasil ditambah" : "Item berhasil diperbarui",
            ),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menyimpan item")),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? "Tambah Barang" : "Edit Barang"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Image picker
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _image != null
                              ? Image.file(_image!, fit: BoxFit.cover)
                              : widget.item?.photoUrl.isNotEmpty == true
                                  ? Image.network(
                                      widget.item!.photoUrl,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.add_photo_alternate, size: 100),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name field
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Nama Barang",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nama barang tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Location field
                      TextFormField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          labelText: "Lokasi",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Lokasi tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Stock field
                      TextFormField(
                        controller: stockController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Stok",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Stok tidak boleh kosong";
                          }
                          if (int.tryParse(value) == null) {
                            return "Stok harus berupa angka";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Submit button
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: Text(
                          widget.item == null ? "Tambah Barang" : "Simpan Perubahan",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
