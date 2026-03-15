import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          validator: widget.validator,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: AppTheme.textHint,
                    size: 20,
                  )
                : null,
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: () =>
                        setState(() => _obscureText = !_obscureText),
                    child: Icon(
                      _obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: AppTheme.textHint,
                      size: 20,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
