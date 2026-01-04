import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../screens/detail_screen.dart';
import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;
  const ProductGridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailScreen(product: product)),
          );
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          clipBehavior: Clip.antiAlias,
          color: AppColors.surface,
          child: Column(
            children: [
              // ================= IMAGE =================
              Expanded(
                flex: 7,
                child: Stack(
                  children: [
                    Hero(
                      tag: product.id,
                      child: SizedBox.expand(
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (c, w, p) {
                            if (p == null) return w;
                            return Container(
                              color: AppColors.background,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.background,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // SALE BADGE
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'SALE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ================= INFO =================
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name.isEmpty ? '-' : product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.primary,
                        ),
                      ),

                      const Spacer(),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              f.format(product.price),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.primary,
                              ),
                            ),
                          ),

                          // 🔥 ACTIVE ADD TO CART
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              context.read<CartProvider>().addItem(
                                product.id,
                                product.name,
                                product.price,
                                product.imageUrl,
                              );

                              ScaffoldMessenger.of(
                                context,
                              ).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.primary,
                                  content: Text(
                                    '${product.name} ditambahkan ke keranjang',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  duration: const Duration(milliseconds: 800),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                size: 20,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
