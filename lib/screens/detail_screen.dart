import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';

class DetailScreen extends StatelessWidget {
  final Product product;
  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Column(
        children: [
          // ================= CONTENT =================
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= IMAGE =================
                  Hero(
                    tag: product.id,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      child: Image.network(
                        product.imageUrl,
                        width: double.infinity,
                        height: 300, // dikurangi dari 460 → lebih proporsional
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            height: 300,
                            color: AppColors.background,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => Container(
                          height: 300,
                          color: AppColors.background,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: AppColors.secondary,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ================= INFO =================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CATEGORY
                        Text(
                          product.category.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 12,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // NAME
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // PRICE
                        Text(
                          f.format(product.price),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // DESCRIPTION TITLE
                        const Text(
                          'DESCRIPTION',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // DESCRIPTION
                        Text(
                          product.description,
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 15,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ================= BOTTOM BAR =================
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // PRICE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Price',
                          style: TextStyle(color: AppColors.secondary),
                        ),
                        Text(
                          f.format(product.price),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // BUTTON
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(160, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();

                      context.read<CartProvider>().addItem(
                        product.id,
                        product.name,
                        product.price,
                        product.imageUrl,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.primary,
                          content: Text(
                            '${product.name} ditambahkan ke keranjang',
                            style: const TextStyle(color: Colors.white),
                          ),
                          duration: const Duration(milliseconds: 1200),
                        ),
                      );
                    },
                    child: const Text(
                      'ADD TO CART',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
