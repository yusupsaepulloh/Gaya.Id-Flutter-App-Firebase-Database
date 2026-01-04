import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Product> _allProducts = [];
  List<Product> _items = [];
  List<String> _categories = ['All', 'T-Shirt', 'Hoodie', 'Shoes', 'Jeans', 'Jacket'];

  bool _isLoading = false;
  String _activeCategory = 'All';

  List<Product> get items => _items;
  bool get isLoading => _isLoading;
  String get activeCategory => _activeCategory;
  List<String> get categories => _categories;

  Future<void> fetchProducts([String category = 'All']) async {
    _isLoading = true;
    _activeCategory = category;
    notifyListeners();

    try {
      final snapshot = await _db.collection('products')
          .orderBy('createdAt', descending: true)
          .get();

      _allProducts = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();

      // pastikan kategori selalu include default
      final allCats = _allProducts.map((p) => p.category).toSet().toList();
      _categories = ['All', ...allCats.where((c) => c != 'All')];

      if (category == 'All') {
        _items = [..._allProducts];
      } else {
        _items = _allProducts.where((p) => p.category == category).toList();
      }
    } catch (e) {
      debugPrint("Error Fetch: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void search(String keyword) {
    if (keyword.isEmpty) {
      _items = _activeCategory == 'All'
          ? [..._allProducts]
          : _allProducts.where((p) => p.category == _activeCategory).toList();
    } else {
      _items = _allProducts.where((p) {
        final matchCategory = _activeCategory == 'All' || p.category == _activeCategory;
        return matchCategory && p.name.toLowerCase().contains(keyword.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<void> addProduct(String name, String desc, int price, String img, String category) async {
    await _db.collection('products').add({
      'name': name,
      'description': desc,
      'price': price,
      'imageUrl': img,
      'category': category,
      'createdAt': FieldValue.serverTimestamp(),
    });
    fetchProducts(_activeCategory);
  }

  Future<void> updateProduct(String id, String name, String desc, int price, String img, String category) async {
    await _db.collection('products').doc(id).update({
      'name': name,
      'description': desc,
      'price': price,
      'imageUrl': img,
      'category': category,
    });
    fetchProducts(_activeCategory);
  }

  Future<void> deleteProduct(String id) async {
    await _db.collection('products').doc(id).delete();
    fetchProducts(_activeCategory);
  }
}
