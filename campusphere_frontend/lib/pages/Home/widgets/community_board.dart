import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campusphere_frontend/auxiliary/app_theme.dart';

/// Data class representing a single community board post.
class CommunityPostItem {
  final String title;
  final String description;

  const CommunityPostItem({
    required this.title,
    required this.description,
  });
}

/// Default hardcoded community posts used when no data is provided.
const List<CommunityPostItem> _defaultPosts = [
  CommunityPostItem(
    title: 'Lost Keys near Library',
    description: 'Lanyard with a red tag. Turned into front desk.',
  ),
  CommunityPostItem(
    title: 'Selling Bio 101 Textbook',
    description: 'Good condition, \$40 OBO. Contact Mike M.',
  ),
];

/// Community bulletin board section on the home page.
///
/// Accepts an optional [posts] list of [CommunityPostItem]. Falls back
/// to hardcoded defaults when the list is empty or not provided.
class CommunityBoard extends StatelessWidget {
  /// The list of community posts to display.
  final List<CommunityPostItem> posts;

  const CommunityBoard({super.key, this.posts = _defaultPosts});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'COMMUNITY BOARD',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Icon(
                Icons.push_pin_outlined,
                size: 20,
                color: AppColors.outlineVariant,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (posts.isEmpty)
            Text(
              'No community posts yet.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
            )
          else
            ...posts.asMap().entries.map((entry) {
              final index = entry.key;
              final post = entry.value;
              final isLast = index == posts.length - 1;
              return _CommunityBoardItem(
                title: post.title,
                description: post.description,
                showDivider: !isLast,
              );
            }),
        ],
      ),
    );
  }
}

/// Single community board list item.
class _CommunityBoardItem extends StatelessWidget {
  final String title;
  final String description;
  final bool showDivider;

  const _CommunityBoardItem({
    required this.title,
    required this.description,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        if (showDivider) ...[
          const SizedBox(height: 14),
          Divider(color: AppColors.surfaceContainerHigh, height: 1),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}
