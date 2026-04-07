import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/language_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Bahasa'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          _buildLanguageTile(
            context,
            'Indonesia',
            'Bahasa Indonesia',
            'id',
            languageProvider,
          ),
          _buildLanguageTile(
            context,
            'English',
            'English (US)',
            'en',
            languageProvider,
          ),
          _buildLanguageTile(
            context,
            '中文',
            'Chinese (Simplified)',
            'zh',
            languageProvider,
          ),
          _buildLanguageTile(
            context,
            '日本語',
            'Japanese',
            'ja',
            languageProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    String title,
    String subtitle,
    String code,
    LanguageProvider provider,
  ) {
    final isSelected = provider.getCurrentLanguageCode() == code;

    return ListTile(
      leading: isSelected
          ? Icon(Icons.check_circle, color: AppTheme.primaryGreen)
          : Icon(Icons.language, color: AppTheme.textHint),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'ACTIVE',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            )
          : null,
      onTap: () {
        provider.setLanguage(code);
        Navigator.pop(context);
      },
    );
  }
}

extension on LanguageProvider {
  getCurrentLanguageCode() {}
}