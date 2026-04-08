import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // jika pakai provider, sesuaikan

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil languageProvider dari context (sesuaikan dengan provider kamu)
    // final languageProvider = Provider.of<LanguageProvider>(context);
    // Untuk sementara, kita pakai state lokal dummy
    final String currentLanguage = 'id'; // contoh: 'id', 'en', 'zh'

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Pilih Bahasa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          // Header dengan informasi bahasa aktif
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade700, Colors.teal.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.shade200,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.language, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bahasa Aplikasi',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getLanguageName(currentLanguage),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    _getLanguageCode(currentLanguage).toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Daftar bahasa
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildLanguageCard(
                  context: context,
                  title: 'Bahasa Indonesia',
                  subtitle: 'Indonesia',
                  languageCode: 'id',
                  flagIcon: '🇮🇩',
                  isActive: currentLanguage == 'id',
                  onTap: () => _changeLanguage(context, 'id'),
                ),
                const SizedBox(height: 12),
                _buildLanguageCard(
                  context: context,
                  title: 'English',
                  subtitle: 'United States',
                  languageCode: 'en',
                  flagIcon: '🇺🇸',
                  isActive: currentLanguage == 'en',
                  onTap: () => _changeLanguage(context, 'en'),
                ),
                const SizedBox(height: 12),
                _buildLanguageCard(
                  context: context,
                  title: '中文',
                  subtitle: '简体中文',
                  languageCode: 'zh',
                  flagIcon: '🇨🇳',
                  isActive: currentLanguage == 'zh',
                  onTap: () => _changeLanguage(context, 'zh'),
                ),
              ],
            ),
          ),
          // Catatan kecil
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Perubahan bahasa akan langsung berlaku',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String languageCode,
    required String flagIcon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: isActive ? 2 : 0,
      shadowColor: Colors.green.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isActive ? Colors.green.shade400 : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isActive ? Colors.green.shade50 : Colors.white,
          ),
          child: Row(
            children: [
              // Flag / Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    flagIcon,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Title & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.green.shade800 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Checkmark jika aktif
              if (isActive)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade500,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 18),
                )
              else
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'id':
        return 'Indonesia';
      case 'en':
        return 'English';
      case 'zh':
        return '中文';
      default:
        return 'Indonesia';
    }
  }

  String _getLanguageCode(String code) {
    switch (code) {
      case 'id':
        return 'id';
      case 'en':
        return 'en';
      case 'zh':
        return 'zh';
      default:
        return 'id';
    }
  }

  void _changeLanguage(BuildContext context, String langCode) {
    // Panggil provider atau setLocale di sini
    // Contoh: Provider.of<LanguageProvider>(context, listen: false).setLanguage(langCode);

    // Tampilkan snackbar feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bahasa diubah ke ${_getLanguageName(langCode)}'),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );

    // Tutup screen jika perlu (opsional)
    // Navigator.pop(context);
  }
}