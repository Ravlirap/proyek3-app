import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _doRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Harap setujui syarat & ketentuan'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    final authProvider = context.read<AuthProvider>();
    final userProvider = context.read<UserProvider>();

    final ok = await authProvider.register(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _passCtrl.text,
    );
    if (ok && mounted) {
      userProvider.setName(_nameCtrl.text.trim());
      userProvider.setEmail(_emailCtrl.text.trim());
      Navigator.pushReplacementNamed(context, AppConstants.onboardingRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppTheme.lightGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back_rounded,
                        color: AppTheme.darkGreen),
                  ),
                ),
                const SizedBox(height: 28),
                FadeInDown(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Buat Akun Baru',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Mulai perjalanan hidup sehat Anda',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  child: CustomTextField(
                    label: 'Nama Lengkap',
                    hint: 'Masukkan nama Anda',
                    prefixIcon: Icons.person_rounded,
                    controller: _nameCtrl,
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Nama tidak boleh kosong'
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  delay: const Duration(milliseconds: 150),
                  child: CustomTextField(
                    label: 'Email',
                    hint: 'nama@email.com',
                    prefixIcon: Icons.email_rounded,
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                      if (!v.contains('@')) return 'Format email tidak valid';
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: CustomTextField(
                    label: 'Password',
                    hint: 'Minimal 8 karakter',
                    prefixIcon: Icons.lock_rounded,
                    isPassword: true,
                    controller: _passCtrl,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password wajib diisi';
                      if (v.length < 8) return 'Password minimal 8 karakter';
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  delay: const Duration(milliseconds: 250),
                  child: CustomTextField(
                    label: 'Konfirmasi Password',
                    hint: 'Ulangi password Anda',
                    prefixIcon: Icons.lock_outline_rounded,
                    isPassword: true,
                    controller: _confirmPassCtrl,
                    textInputAction: TextInputAction.done,
                    validator: (v) {
                      if (v != _passCtrl.text) return 'Password tidak cocok';
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: GestureDetector(
                    onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: _acceptTerms
                                ? AppTheme.primaryGreen
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _acceptTerms
                                  ? AppTheme.primaryGreen
                                  : AppTheme.textHint,
                              width: 1.5,
                            ),
                          ),
                          child: _acceptTerms
                              ? const Icon(Icons.check, color: Colors.white, size: 14)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'Saya setuju dengan ',
                              style: TextStyle(
                                  color: AppTheme.textSecondary, fontSize: 13),
                              children: [
                                TextSpan(
                                  text: 'Syarat & Ketentuan',
                                  style: TextStyle(
                                    color: AppTheme.primaryGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(text: ' GoHealth'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                FadeInUp(
                  delay: const Duration(milliseconds: 350),
                  child: CustomButton(
                    text: 'Daftar Sekarang',
                    onPressed: _doRegister,
                    isLoading: auth.isLoading,
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: Row(
                    children: [
                      const Expanded(child: Divider(color: AppTheme.divider)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Text('atau', style: TextStyle(color: AppTheme.textHint)),
                      ),
                      const Expanded(child: Divider(color: AppTheme.divider)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  delay: const Duration(milliseconds: 450),
                  child: CustomButton(
                    text: 'Daftar dengan Google',
                    variant: ButtonVariant.google,
                    onPressed: () {},
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 28),
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Sudah punya akun? ',
                          style: TextStyle(
                              color: AppTheme.textSecondary, fontSize: 14)),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                            context, AppConstants.loginRoute),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: AppTheme.primaryGreen,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
