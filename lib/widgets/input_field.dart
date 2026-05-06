import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class AppInputField extends StatefulWidget {
  final String label;
  final String placeholder;
  final String? value;
  final ValueChanged<String>? onChange;
  final TextInputType? keyboardType;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final VoidCallback? onRightIconTap;
  final bool obscureText;
  final String? errorText;
  final bool enabled;
  final TextEditingController? controller;

  const AppInputField({
    super.key,
    required this.label,
    required this.placeholder,
    this.value,
    this.onChange,
    this.keyboardType,
    this.leftIcon,
    this.rightIcon,
    this.onRightIconTap,
    this.obscureText = false,
    this.errorText,
    this.enabled = true,
    this.controller,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  bool _focused = false;
  late FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode()..addListener(() => setState(() => _focused = _focus.hasFocus));
  }

  @override
  void dispose() { _focus.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final borderColor = hasError ? AppColors.red : _focused ? AppColors.navy : AppColors.border;
    final borderWidth = (hasError || _focused) ? 2.0 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.sora(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _focused ? AppColors.navy : AppColors.t1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: widget.enabled ? Colors.white : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: _focused && !hasError
                ? [BoxShadow(color: AppColors.navy.withValues(alpha: 0.08), blurRadius: 0, spreadRadius: 3)]
                : null,
          ),
          child: Row(
            children: [
              if (widget.leftIcon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Icon(widget.leftIcon!, size: 16,
                    color: hasError ? AppColors.red : _focused ? AppColors.navy : AppColors.t3),
                ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  enabled: widget.enabled,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  onChanged: widget.onChange,
                  style: GoogleFonts.sora(fontSize: 14, color: AppColors.t1),
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: GoogleFonts.sora(fontSize: 14, color: AppColors.t3),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: widget.leftIcon != null ? 12 : 16, right: 16),
                  ),
                ),
              ),
              if (widget.rightIcon != null)
                GestureDetector(
                  onTap: widget.onRightIconTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(widget.rightIcon!, size: 16, color: AppColors.t3),
                  ),
                ),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(widget.errorText!, style: GoogleFonts.sora(fontSize: 11, color: AppColors.red)),
          ),
      ],
    );
  }
}
