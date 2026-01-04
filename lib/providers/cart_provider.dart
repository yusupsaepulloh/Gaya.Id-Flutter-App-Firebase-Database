import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  // ================= TOTAL =================
  int get totalAmount {
    int total = 0;
    _items.forEach((_, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  // ================= ADD ITEM =================
  void addItem(
    String productId,
    String name,
    int price,
    String imageUrl,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existing) => CartItem(
          id: existing.id,
          name: existing.name,
          price: existing.price,
          imageUrl: existing.imageUrl,
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: productId,
          name: name,
          price: price,
          imageUrl: imageUrl,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  // ================= INCREASE QTY =================
  void increaseQty(String productId) {
    if (!_items.containsKey(productId)) return;

    _items.update(
      productId,
      (existing) => CartItem(
        id: existing.id,
        name: existing.name,
        price: existing.price,
        imageUrl: existing.imageUrl,
        quantity: existing.quantity + 1,
      ),
    );
    notifyListeners();
  }

  // ================= DECREASE QTY =================
  void decreaseQty(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existing) => CartItem(
          id: existing.id,
          name: existing.name,
          price: existing.price,
          imageUrl: existing.imageUrl,
          quantity: existing.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  // ================= REMOVE ITEM =================
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // ================= CLEAR CART =================
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // ================= HELPERS =================
  bool contains(String productId) {
    return _items.containsKey(productId);
  }

  int get itemCount {
    return _items.length;
  }
}
