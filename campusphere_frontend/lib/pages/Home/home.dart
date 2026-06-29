import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campusphere_frontend/auxiliary/app_theme.dart';
import 'package:campusphere_frontend/services/home_feed_service.dart';
import 'package:campusphere_frontend/pages/Home/widgets/greeting_section.dart';
import 'package:campusphere_frontend/pages/Home/widgets/urgent_announcement.dart';
import 'package:campusphere_frontend/pages/Home/widgets/highlight_card.dart';
import 'package:campusphere_frontend/pages/Home/widgets/for_you_feed.dart';
import 'package:campusphere_frontend/pages/Home/widgets/quick_tools.dart';
import 'package:campusphere_frontend/pages/Home/widgets/community_board.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: const _HomeBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.all(5.0),
        child: const CircleAvatar(
          backgroundImage: NetworkImage(
            'https://www.simplelyst.com/_image-uploads/profile_photo-agents-agent-2-87173.jpg',
          ),
        ),
      ),
      title: Text(
        'CampuSphere',
        style: GoogleFonts.lexend(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.universityBlue,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  String _studentName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    final name = await HomeFeedService.fetchStudentName();

    if (mounted) {
      setState(() {
        _studentName = name ?? 'Student';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.universityBlue,
        ),
      );
    }

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
          GreetingSection(studentName: _studentName),
          const SizedBox(height: 20),

          // ── Urgent Announcement ──────────────────────────
          const UrgentAnnouncement(),
          const SizedBox(height: 24),

          // ── Highlight Card ──────────────────────────────
          const HighlightCard(),
          const SizedBox(height: 28),

          // ── For You Feed ────────────────────────────────
          const ForYouFeed(),
          const SizedBox(height: 24),

          // ── Quick Tools ─────────────────────────────────
          const QuickTools(),
          const SizedBox(height: 24),

          // ── Community Board ─────────────────────────────
          const CommunityBoard(),
        ],
      ),
    );
  }
}
