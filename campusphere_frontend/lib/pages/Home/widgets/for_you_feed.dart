import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campusphere_frontend/auxiliary/app_theme.dart';

/// Data class representing a single feed item.
class FeedItem {
  final String imageUrl;
  final String category;
  final String title;
  final String description;
  final IconData metaIcon;
  final String metaText;

  const FeedItem({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.description,
    required this.metaIcon,
    required this.metaText,
  });
}

/// Default hardcoded feed items used when no data is provided.
const List<FeedItem> _defaultFeedItems = [
  FeedItem(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCi2kFc5c8hlWrXzfkbsC_0eHCcK8sm3JaQyiaWq5MpPsKGCi6wMOVce4_jqY62AHr1lpWqIQXkvO3WdH1x05_UnCaIPzE4CpJ0B7pSF00-OxoDMzK8dKer3SBOxyzS7UPKwwGzF5KX4fjgJ2sJPp1MWo6KI4O3jJS7r0mQIVBsMpz2bBoF1XYLY-jvzQ2U0cNV4aAtQcZdDKdVSi0fRxzbbc789h3g6ZU9IY3KHEhu99nmKTDuMSrJoW_V4QlcqChr2Q2wbxbGRJM',
    category: 'Tech',
    title: 'Campus Hackathon Prep Kickoff',
    description:
        'Get your teams ready and pitch your initial ideas. Pizza provided!',
    metaIcon: Icons.location_on_outlined,
    metaText: 'Innovation Lab',
  ),
  FeedItem(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCE0mCIO3Sj_fKytvx9QwT0bvu_Iev-HrjbIfAdo3w0dV17-eOIuTe3UHrPvRhICX-dxPHF3gwM6cmZ_aifmuuK9dwVe5-NNfsM1vyoYY1j2yZ233na1s0eDXnq0fOCtljA3hnoPmKQtVhvFLfryfj1Dvo3UBYjCsI1Zu6OjiVnJLJw7Blk-tjTp9ZtvLcuVDN5RbaMhP8u-U6wcYzt1J5EgX2yA0UlYHXcDlzJb1oagFSD6mQqIvF52fn0z57a5GOhy6Mw8wO6QdE',
    category: 'Sports',
    title: 'Intramural Volleyball Signups',
    description:
        'Registration closes this Friday. Find a team or register as a free agent.',
    metaIcon: Icons.calendar_today_outlined,
    metaText: 'Tomorrow',
  ),
];

/// "For You" section including the header and the feed grid.
///
/// Accepts an optional [items] list of [FeedItem]. Falls back to
/// hardcoded defaults when the list is empty or not provided.
class ForYouFeed extends StatelessWidget {
  /// The list of feed items to display.
  final List<FeedItem> items;

  const ForYouFeed({super.key, this.items = _defaultFeedItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ForYouHeader(),
        const SizedBox(height: 12),
        FeedGrid(items: items),
      ],
    );
  }
}

/// Header row with title and filter button.
class ForYouHeader extends StatelessWidget {
  const ForYouHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'For You',
          style: GoogleFonts.lexend(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}

/// Two-column grid of feed cards.
class FeedGrid extends StatelessWidget {
  final List<FeedItem> items;

  const FeedGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'No events to show right now.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    // Build pairs of cards in rows
    final List<Widget> rows = [];
    for (int i = 0; i < items.length; i += 2) {
      final first = items[i];
      final second = (i + 1 < items.length) ? items[i + 1] : null;

      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FeedCard(
                imageUrl: first.imageUrl,
                category: first.category,
                title: first.title,
                description: first.description,
                metaIcon: first.metaIcon,
                metaText: first.metaText,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: second != null
                  ? FeedCard(
                      imageUrl: second.imageUrl,
                      category: second.category,
                      title: second.title,
                      description: second.description,
                      metaIcon: second.metaIcon,
                      metaText: second.metaText,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );

      if (i + 2 < items.length) {
        rows.add(const SizedBox(height: 12));
      }
    }

    return Column(children: rows);
  }
}

/// Feed card used in the "For You" grid.
class FeedCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String description;
  final IconData metaIcon;
  final String metaText;

  const FeedCard({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.description,
    required this.metaIcon,
    required this.metaText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with category chip
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.surfaceContainer,
                      child: const Icon(
                        Icons.image_outlined,
                        color: AppColors.outlineVariant,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest.withValues(
                          alpha: 0.9,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        category,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Text content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    color: AppColors.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(metaIcon, size: 14, color: AppColors.outline),
                    const SizedBox(width: 4),
                    Text(
                      metaText,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
