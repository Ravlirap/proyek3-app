import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/profile_service.dart';
import '../../../providers/user_provider.dart';
import 'language_screen.dart';
import 'privacy_policy_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final ProfileService _profileService = ProfileService();
  final ImagePicker _picker = ImagePicker();
  bool _photoLoading = false;

  // ────────────────────────────────────────────────
  // Helper: ambil token dari SharedPreferences
  // ────────────────────────────────────────────────
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // ────────────────────────────────────────────────
  // C / U  – Pilih & upload foto profil
  // ────────────────────────────────────────────────
  Future<void> _pickAndUploadPhoto() async {
    final source = await _showSourceDialog();
    if (source == null) return;

    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 800,
    );
    if (picked == null) return;

    final token = await _getToken();
    if (token == null) {
      _showSnack('Sesi login tidak ditemukan, silakan login ulang.', isError: true);
      return;
    }

    setState(() => _photoLoading = true);
    try {
      final result = await _profileService.uploadPhoto(
        token: token,
        image: File(picked.path),
      );

      if (!mounted) return;
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final newUrl = result['photo_url'] as String?;
      userProvider.setProfilePhotoUrl(newUrl);

      // Simpan ke SharedPreferences supaya tetap ada setelah logout
      final prefs = await SharedPreferences.getInstance();
      if (newUrl != null) {
        await prefs.setString('user_photo_url', newUrl);
      } else {
        await prefs.remove('user_photo_url');
      }

      _showSnack('Foto profil berhasil diperbarui ✓');
    } catch (e) {
      _showSnack('Gagal upload foto: $e', isError: true);
    } finally {
      if (mounted) setState(() => _photoLoading = false);
    }
  }

  // ────────────────────────────────────────────────
  // D  – Hapus foto profil
  // ────────────────────────────────────────────────
  Future<void> _deletePhoto() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Foto?'),
        content: const Text('Foto profil kamu akan dihapus dan diganti dengan ikon default.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    final token = await _getToken();
    if (token == null) return;

    setState(() => _photoLoading = true);
    try {
      await _profileService.deletePhoto(token);
      if (!mounted) return;
      Provider.of<UserProvider>(context, listen: false).setProfilePhotoUrl(null);

      // Hapus dari SharedPreferences juga
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_photo_url');
      _showSnack('Foto profil berhasil dihapus');
    } catch (e) {
      _showSnack('Gagal menghapus foto: $e', isError: true);
    } finally {
      if (mounted) setState(() => _photoLoading = false);
    }
  }

  // ────────────────────────────────────────────────
  // Dialog pilih sumber foto (kamera / galeri)
  // ────────────────────────────────────────────────
  Future<ImageSource?> _showSourceDialog() => showModalBottomSheet<ImageSource>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text('Pilih Sumber Foto',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Color(0xFF2E7D32)),
                  title: const Text('Kamera'),
                  onTap: () => Navigator.pop(ctx, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Color(0xFF2E7D32)),
                  title: const Text('Galeri'),
                  onTap: () => Navigator.pop(ctx, ImageSource.gallery),
                ),
              ],
            ),
          ),
        ),
      );

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red[700] : const Color(0xFF2E7D32),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  // ────────────────────────────────────────────────
  // Build
  // ────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final photoUrl = userProvider.profilePhotoUrl;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),

            // ─── Avatar + tombol edit / hapus ───
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      // Avatar foto
                      _photoLoading
                          ? Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFE8F5E9),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF2E7D32),
                                  strokeWidth: 2.5,
                                ),
                              ),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundColor: const Color(0xFFE8F5E9),
                              backgroundImage: photoUrl != null
                                  ? NetworkImage(photoUrl)
                                  : null,
                              child: photoUrl == null
                                  ? const Icon(Icons.person, size: 60, color: Color(0xFF2E7D32))
                                  : null,
                            ),

                      // Tombol kamera (C/U)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _photoLoading ? null : _pickAndUploadPhoto,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Tombol hapus foto (D) — hanya muncul kalau ada foto
                  if (photoUrl != null) ...[
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _photoLoading ? null : _deletePhoto,
                      icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                      label: const Text('Hapus Foto',
                          style: TextStyle(color: Colors.red, fontSize: 12)),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    ),
                  ],

                  const SizedBox(height: 16),
                  Text(
                    userProvider.name.isEmpty ? 'User GoHealth' : userProvider.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
                  ),
                  Text(
                    userProvider.email.isEmpty ? 'user@gohealth.ai' : userProvider.email,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B5E20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Member Premium',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ─── Kartu Info Fisik ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5E20),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPhysicalInfo('Tinggi', '${userProvider.heightCm.toInt()} cm', Icons.height),
                    _buildPhysicalInfo('Berat', '${userProvider.weightKg.toInt()} kg', Icons.monitor_weight_outlined),
                    _buildPhysicalInfo('BMI', userProvider.bmi.toStringAsFixed(1), Icons.favorite_border),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ─── Menu ───
            _buildMenuItem(context, Icons.language, 'Bahasa', 'Ganti bahasa aplikasi',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageScreen()))),
            _buildMenuItem(context, Icons.privacy_tip_outlined, 'Kebijakan Privasi', 'Lihat kebijakan privasi',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()))),
            _buildMenuItem(context, Icons.info_outline, 'Tentang Aplikasi', 'Versi 1.0.0',
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'GoHealth',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(Icons.health_and_safety, color: Colors.green),
                )),
            _buildMenuItem(context, Icons.logout, 'Keluar', 'Keluar dari akun',
                isLogout: true,
                onTap: () => _showLogoutDialog(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildPhysicalInfo(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String subtitle,
      {required VoidCallback onTap, bool isLogout = false}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isLogout ? Colors.red[50] : Colors.green[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: isLogout ? Colors.red : const Color(0xFF2E7D32)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar Akun'),
        content: const Text('Apakah kamu yakin ingin keluar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}