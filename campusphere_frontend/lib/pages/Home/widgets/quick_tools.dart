import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campusphere_frontend/auxiliary/app_theme.dart';

/// Quick-access tools grid section on the home page.
class QuickTools extends StatelessWidget {
  const QuickTools({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QUICK TOOLS',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _QuickToolButton(
                  icon: Icons.local_cafe_outlined,
                  label: 'Dining Menus',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _QuickToolButton(
                  icon: Icons.help_outline,
                  label: 'IT Helpdesk',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Quick tool button (2×2 grid item).
class _QuickToolButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickToolButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              Icon(icon, size: 24, color: AppColors.primaryContainer),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
