import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../theme/app_colors.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameC;
  late TextEditingController _descC;
  late TextEditingController _priceC;
  late TextEditingController _imgC;
  String _category = 'T-Shirt';

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameC = TextEditingController(text: p?.name ?? '');
    _descC = TextEditingController(text: p?.description ?? '');
    _priceC = TextEditingController(text: p != null ? p.price.toString() : '');
    _imgC = TextEditingController(text: p?.imageUrl ?? '');
    _category = p?.category ?? 'T-Shirt';
  }

  @override
  void dispose() {
    _nameC.dispose();
    _descC.dispose();
    _priceC.dispose();
    _imgC.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final prov = context.read<ProductProvider>();
    final name = _nameC.text.trim();
    final desc = _descC.text.trim();
    final price = int.parse(_priceC.text.trim());
    final img = _imgC.text.trim();

    if (widget.product == null) {
      await prov.addProduct(name, desc, price, img, _category);
    } else {
      await prov.updateProduct(
        widget.product!.id,
        name,
        desc,
        price,
        img,
        _category,
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ProductProvider>();

    // ================= KATEGORI DINAMIS =================
    final defaultCategories = [
      'T-Shirt',
      'Hoodie',
      'Jeans',
      'Shoes',
      'Jacket',
      'Accessories',
      'Bag',
    ];

    final allCategories = [
      ...defaultCategories,
      ...prov.categories.where(
        (c) => c != 'All' && !defaultCategories.contains(c),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text(
          widget.product == null ? 'Tambah Produk' : 'Edit Produk',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primary,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _field(
                  controller: _nameC,
                  label: 'Nama Produk',
                  validator: 'Nama wajib diisi',
                ),

                _field(
                  controller: _descC,
                  label: 'Deskripsi',
                  maxLines: 3,
                  validator: 'Deskripsi wajib diisi',
                ),

                _field(
                  controller: _priceC,
                  label: 'Harga',
                  keyboard: TextInputType.number,
                  validator: 'Harga wajib diisi',
                ),

                _field(
                  controller: _imgC,
                  label: 'URL Gambar',
                  validator: 'URL wajib diisi',
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: allCategories.contains(_category)
                      ? _category
                      : allCategories.first,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items: allCategories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v!),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Kategori wajib dipilih' : null,
                ),

                const SizedBox(height: 28),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _submit,
                  child: const Text(
                    'Simpan Produk',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= INPUT BUILDER =================
  Widget _field({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
    required String validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: const InputDecoration(
          labelText: '',
          border: OutlineInputBorder(),
        ).copyWith(labelText: label),
        validator: (v) => v!.isEmpty ? validator : null,
      ),
    );
  }
}
