import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'product_admin_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ================= APP BAR =================
      appBar: AppBar(
        title: const Text(
          "PROFILE",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primary,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ================= PROFILE CARD =================
            Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
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
              child: Column(
                children: [
                  // ================= AVATAR =================
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 55,
                        backgroundColor: AppColors.primary,
                        child: Icon(
                          Icons.admin_panel_settings,
                          size: 55,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "ADMIN",
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

                  const SizedBox(height: 16),

                  // ================= NAME =================
                  const Text(
                    "Yusup Saepulloh",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ================= ROLE =================
                  const Text(
                    "Product Management Administrator",
                    style: TextStyle(color: AppColors.secondary, fontSize: 14),
                  ),

                  const SizedBox(height: 6),

                  // ================= EMAIL =================
                  const Text(
                    "yusupofficial22@gmail.com",
                    style: TextStyle(color: AppColors.secondary, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ================= ADMIN MENU =================
            _ProfileMenu(
              icon: Icons.inventory_2_outlined,
              title: "Kelola Produk",
              subtitle: "Tambah, edit & hapus produk",
              color: AppColors.primary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductAdminScreen()),
                );
              },
            ),

            _ProfileMenu(
              icon: Icons.settings_outlined,
              title: "Pengaturan",
              subtitle: "Konfigurasi aplikasi",
              color: AppColors.primary,
              onTap: () {},
            ),

            const SizedBox(height: 12),

            // ================= LOGOUT =================
            _ProfileMenu(
              icon: Icons.logout,
              title: "Logout",
              subtitle: "Keluar dari akun admin",
              color: AppColors.accent,
              onTap: () {
                // TODO: logout logic
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ================= MENU TILE =================
class _ProfileMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ProfileMenu({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: color),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
