import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campusphere_frontend/auxiliary/app_theme.dart';

/// Large highlight / hero card on the home page.
///
/// Accepts event data to display dynamic content.
/// Falls back to hardcoded defaults when no parameters are provided.
class HighlightCard extends StatelessWidget {
  /// The event title displayed over the hero image.
  final String title;

  /// The event description shown below the title.
  final String description;

  /// URL for the background hero image.
  final String imageUrl;

  /// Category chip label (e.g. 'YOUR MAJOR').
  final String category;

  /// Time chip label (e.g. '⏱ Today, 3:00 PM').
  final String eventTime;

  const HighlightCard({
    super.key,
    this.title = 'CS 401: AI Ethics Symposium',
    this.description =
        'Join industry leaders discussing the implications of large language models in modern software development.',
    this.imageUrl =
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBdZKmsptbSIUBDfAdCa8wMYNu6U0r40N4SZvebBHAvZP1E44QXYqVHFkryB0CkuxgrP_dvT-wDuCZUdsWCo03xcFJKzD4gNIalSIewClCSIFtOY4geEkvVgbyY4LBDLSURVL54cBkK60vgnqJfp5oBZKet-hes1b4vI97R1XYxrclg5gWUQBjTwD6Qt1itAiMNqxZyJDtVVNDMTVF2eiNhhrFEPqUeH8mxiVy6lqD6uqKymt0qS7DhJdrokv6RBzQ8VXawckZcFnY',
    this.category = 'YOUR MAJOR',
    this.eventTime = '⏱ Today, 3:00 PM',
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 280,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: AppColors.primaryContainer),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.primary.withValues(alpha: 0.6),
                    AppColors.primary.withValues(alpha: 0.95),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
            // Content
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Chips
                  Row(
                    children: [
                      _Chip(
                        label: category,
                        bgColor: AppColors.secondaryContainer,
                        textColor: AppColors.onSecondaryContainer,
                      ),
                      const SizedBox(width: 8),
                      _Chip(
                        label: eventTime,
                        bgColor: Colors.white.withValues(alpha: 0.2),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: GoogleFonts.lexend(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: AppColors.primaryFixedDim,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const SizedBox.shrink(),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View Details',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small pill chip used in the highlight card.
class _Chip extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;

  const _Chip({
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: textColor,
        ),
      ),
    );
  }
}
