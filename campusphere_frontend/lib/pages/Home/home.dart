import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campusphere_frontend/auxiliary/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: const _HomeBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBumIhOjoEeYMRQyIInaZKjg7F58LCMGBCAb0-akovlUqfGb4Xkv2QIZ8vyNHLYIUgaK_7xmV7JtH6LXZu392xGWeA7XzmqpDKGrEtwPfDOnAKdQQSXuFPtBJ3yHlQarbL1uWL6P3tOoVPJBMppVnIsAjFbyLDksP-PPJfI0Rl-Q7Et6TUGQuSRSpayEV_pWDl1EdTgonIhMXYRelBikaZjSwH-i9ZqRjQJyeYBSouxCUwSRxvFduygZhdRTDPHcUePYOCooP7B9Ic',
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'CampuSphere',
            style: GoogleFonts.lexend(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.universityBlue,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: AppColors.universityBlue),
          splashRadius: 20,
        ),
      ],
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: 100, // room for bottom nav
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Greeting ─────────────────────────────────────
          _buildGreeting(context),
          const SizedBox(height: 20),

          // ── Urgent Announcement ──────────────────────────
          _buildUrgentAnnouncement(context),
          const SizedBox(height: 24),

          // ── Highlight Card ──────────────────────────────
          _buildHighlightCard(context),
          const SizedBox(height: 28),

          // ── For You Feed ────────────────────────────────
          _buildForYouHeader(context),
          const SizedBox(height: 12),
          _buildFeedGrid(context),
          const SizedBox(height: 24),

          // ── Quick Tools ─────────────────────────────────
          _buildQuickTools(context),
          const SizedBox(height: 24),

          // ── Community Board ─────────────────────────────
          _buildCommunityBoard(context),
        ],
      ),
    );
  }

  // ─── GREETING ───────────────────────────────────────────
  Widget _buildGreeting(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, Alex!',
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

  // ─── URGENT ANNOUNCEMENT ────────────────────────────────
  Widget _buildUrgentAnnouncement(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB4AB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.warning, color: AppColors.error, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency Maintenance',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Water will be shut off in the North Residence Hall from 2 PM to 4 PM today.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: AppColors.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── HIGHLIGHT CARD ─────────────────────────────────────
  Widget _buildHighlightCard(BuildContext context) {
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
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBdZKmsptbSIUBDfAdCa8wMYNu6U0r40N4SZvebBHAvZP1E44QXYqVHFkryB0CkuxgrP_dvT-wDuCZUdsWCo03xcFJKzD4gNIalSIewClCSIFtOY4geEkvVgbyY4LBDLSURVL54cBkK60vgnqJfp5oBZKet-hes1b4vI97R1XYxrclg5gWUQBjTwD6Qt1itAiMNqxZyJDtVVNDMTVF2eiNhhrFEPqUeH8mxiVy6lqD6uqKymt0qS7DhJdrokv6RBzQ8VXawckZcFnY',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.primaryContainer,
              ),
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
                        label: 'YOUR MAJOR',
                        bgColor: AppColors.secondaryContainer,
                        textColor: AppColors.onSecondaryContainer,
                      ),
                      const SizedBox(width: 8),
                      _Chip(
                        label: '⏱ Today, 3:00 PM',
                        bgColor: Colors.white.withValues(alpha: 0.2),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'CS 401: AI Ethics Symposium',
                    style: GoogleFonts.lexend(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Join industry leaders discussing the implications of large language models in modern software development.',
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
                        const Icon(Icons.arrow_forward, size: 18, color: AppColors.primary),
                      ],
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

  // ─── FOR YOU HEADER ────────────────────────────────────
  Widget _buildForYouHeader(BuildContext context) {
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
        TextButton(
          onPressed: () {},
          child: Text(
            'Filter Interests',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryContainer,
            ),
          ),
        ),
      ],
    );
  }

  // ─── FEED GRID ──────────────────────────────────────────
  Widget _buildFeedGrid(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _FeedCard(
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCi2kFc5c8hlWrXzfkbsC_0eHCcK8sm3JaQyiaWq5MpPsKGCi6wMOVce4_jqY62AHr1lpWqIQXkvO3WdH1x05_UnCaIPzE4CpJ0B7pSF00-OxoDMzK8dKer3SBOxyzS7UPKwwGzF5KX4fjgJ2sJPp1MWo6KI4O3jJS7r0mQIVBsMpz2bBoF1XYLY-jvzQ2U0cNV4aAtQcZdDKdVSi0fRxzbbc789h3g6ZU9IY3KHEhu99nmKTDuMSrJoW_V4QlcqChr2Q2wbxbGRJM',
            category: 'Tech',
            title: 'Campus Hackathon Prep Kickoff',
            description: 'Get your teams ready and pitch your initial ideas. Pizza provided!',
            metaIcon: Icons.location_on_outlined,
            metaText: 'Innovation Lab',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _FeedCard(
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCE0mCIO3Sj_fKytvx9QwT0bvu_Iev-HrjbIfAdo3w0dV17-eOIuTe3UHrPvRhICX-dxPHF3gwM6cmZ_aifmuuK9dwVe5-NNfsM1vyoYY1j2yZ233na1s0eDXnq0fOCtljA3hnoPmKQtVhvFLfryfj1Dvo3UBYjCsI1Zu6OjiVnJLJw7Blk-tjTp9ZtvLcuVDN5RbaMhP8u-U6wcYzt1J5EgX2yA0UlYHXcDlzJb1oagFSD6mQqIvF52fn0z57a5GOhy6Mw8wO6QdE',
            category: 'Sports',
            title: 'Intramural Volleyball Signups',
            description: 'Registration closes this Friday. Find a team or register as a free agent.',
            metaIcon: Icons.calendar_today_outlined,
            metaText: 'Tomorrow',
          ),
        ),
      ],
    );
  }

  // ─── QUICK TOOLS ────────────────────────────────────────
  Widget _buildQuickTools(BuildContext context) {
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
              const SizedBox(width: 10),
              Expanded(
                child: _QuickToolButton(
                  icon: Icons.directions_bus_outlined,
                  label: 'Transit App',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _QuickToolButton(
                  icon: Icons.menu_book_outlined,
                  label: 'Book Study Rm',
                ),
              ),
              const SizedBox(width: 10),
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

  // ─── COMMUNITY BOARD ───────────────────────────────────
  Widget _buildCommunityBoard(BuildContext context) {
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
              const Icon(Icons.push_pin_outlined, size: 20, color: AppColors.outlineVariant),
            ],
          ),
          const SizedBox(height: 16),
          // Item 1
          _CommunityBoardItem(
            title: 'Lost Keys near Library',
            description: 'Lanyard with a red tag. Turned into front desk.',
            showDivider: true,
          ),
          // Item 2
          _CommunityBoardItem(
            title: 'Selling Bio 101 Textbook',
            description: 'Good condition, \$40 OBO. Contact Mike M.',
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// REUSABLE COMPONENTS
// ═══════════════════════════════════════════════════════════

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

/// Feed card used in the "For You" grid.
class _FeedCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String description;
  final IconData metaIcon;
  final String metaText;

  const _FeedCard({
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
                      child: const Icon(Icons.image_outlined, color: AppColors.outlineVariant),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9),
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
