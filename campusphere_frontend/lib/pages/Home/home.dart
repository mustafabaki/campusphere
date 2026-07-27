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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String profileURL = "";
  String _studentName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    HomeFeedService.fetchStudentName().then((name) {
      setState(() {
        _studentName = name ?? 'Student';
        _isLoading = false;
      });
      HomeFeedService.fetchProfilePictureURL().then((url) {
        setState(() {
           profileURL = url ?? "";
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: profileURL.isNotEmpty
              ? CircleAvatar(backgroundImage: NetworkImage(profileURL))
              : CircleAvatar(
                  radius: 30, // Controls the size (60px diameter)
                  backgroundColor:
                      Colors.blue.shade800, // Background fill color
                  child: Text(
                    _studentName.trim().isNotEmpty
                        ? _studentName.trim()[0].toUpperCase()
                        : '', // The user's initial
                    style: const TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 20, // Scale text to fit radius
                      fontWeight: FontWeight.bold,
                    ),
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
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.universityBlue),
            )
          : SingleChildScrollView(
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
                  HighlightCard(),
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
            ),
    );
  }
}
