import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class LibrarianSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final EdgeInsetsGeometry? margin;

  const LibrarianSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onClear,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasText = controller.text.isNotEmpty;

    return Container(
      margin: margin,
      height: AppSpacing.searchBarHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.searchBarRadius),
        border: Border.all(color: const Color(0xFFEBE8FF)),
        boxShadow: AppShadows.soft,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF1E1E2D)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTypography.bodySmall.copyWith(color: Colors.grey.shade400),
          prefixIcon: const Icon(LucideIcons.search, size: 18, color: Color(0xFF7A7A9D)),
          suffixIcon: hasText
              ? GestureDetector(
                  onTap: () {
                    controller.clear();
                    if (onChanged != null) onChanged!('');
                    if (onClear != null) onClear!();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF7A7A9D)),
                )
              : null,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
