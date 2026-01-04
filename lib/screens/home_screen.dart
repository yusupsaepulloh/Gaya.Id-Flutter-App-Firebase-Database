import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gayaid/theme/app_colors.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_grid_item.dart';
import '../screens/cart_screen.dart';
import '../screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [HomeBody(), CartScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      // ================= BOTTOM NAV + BADGE =================
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, _) {
          final cartCount = cart.items.length;

          return NavigationBar(
            height: 64,
            backgroundColor: AppColors.surface,
            indicatorColor: AppColors.primary.withOpacity(0.08),
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) {
              setState(() => _selectedIndex = i);
            },
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: AppColors.secondary),
                selectedIcon: Icon(Icons.home, color: AppColors.primary),
                label: 'Home',
              ),
              NavigationDestination(
                label: 'Cart',
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.secondary,
                    ),
                    if (cartCount > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: _CartBadge(cartCount),
                      ),
                  ],
                ),
                selectedIcon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.shopping_bag, color: AppColors.primary),
                    if (cartCount > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: _CartBadge(cartCount),
                      ),
                  ],
                ),
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline, color: AppColors.secondary),
                selectedIcon: Icon(Icons.person, color: AppColors.primary),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}

// ================= BADGE =================
class _CartBadge extends StatelessWidget {
  final int count;
  const _CartBadge(this.count);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      constraints: const BoxConstraints(minWidth: 18),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        count.toString(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// =====================================================================

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchC = TextEditingController();
  Timer? _debounce;

  late AnimationController _animC;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    context.read<ProductProvider>().fetchProducts('All');

    _animC = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeAnim = CurvedAnimation(parent: _animC, curve: Curves.easeOut);
    _animC.forward();
  }

  @override
  void dispose() {
    _searchC.dispose();
    _debounce?.cancel();
    _animC.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<ProductProvider>().search(value);
      _animC.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'GAYA.ID',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            color: AppColors.primary,
          ),
        ),
      ),

      // ================= BODY =================
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          // ================= SEARCH =================
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            sliver: SliverToBoxAdapter(
              child: TextField(
                controller: _searchC,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search product...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchC.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            _searchC.clear();
                            prov.fetchProducts(prov.activeCategory);
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          // ================= CATEGORY =================
          SliverToBoxAdapter(
            child: SizedBox(
              height: 46,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: prov.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final cat = prov.categories[i];
                  final isActive = prov.activeCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isActive,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    checkmarkColor: Colors.white70,
                    labelStyle: TextStyle(
                      color: isActive ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) {
                      _searchC.clear();
                      prov.fetchProducts(cat);
                      _animC.forward(from: 0);
                    },
                  );
                },
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(top: 12)),

          // ================= GRID =================
          prov.isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.crossAxisExtent;
                      final crossAxisCount = width >= 900
                          ? 4
                          : width >= 600
                          ? 3
                          : 2;

                      return SliverFadeTransition(
                        opacity: _fadeAnim,
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate((ctx, i) {
                            final product = prov.items[i];
                            return ProductGridItem(product: product);
                          }, childCount: prov.items.length),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 0.62,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
