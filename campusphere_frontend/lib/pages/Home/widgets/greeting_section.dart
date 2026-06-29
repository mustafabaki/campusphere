import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campusphere_frontend/auxiliary/app_theme.dart';

/// Greeting section displayed at the top of the home page.
class GreetingSection extends StatelessWidget {
  /// The student's first name to display in the greeting.
  final String studentName;

  const GreetingSection({super.key, required this.studentName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, $studentName!',
          style: GoogleFonts.lexend(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            height: 1.2,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Here is what\'s happening around campus today.',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            height: 1.6,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
