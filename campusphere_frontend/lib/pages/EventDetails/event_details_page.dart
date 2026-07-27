import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends StatelessWidget {
  final Map<String, dynamic> event;
  final String? heroTag;

  const EventDetailsPage({Key? key, required this.event, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF003366);
    const Color backgroundColor = Color(0xFFF8F9FF);
    const Color surfaceColor = Color(0xFFFFFFFF);
    const Color surfaceContainerHigh = Color(0xFFDCE9FF);
    const Color onSurfaceColor = Color(0xFF0B1C30);
    const Color onSurfaceVariant = Color(0xFF43474F);

    final title = event['title'] ?? 'No Title';
    final category = event['category'] ?? 'Event';
    final imageUrl = event['coverImageUrl'] ?? 'https://via.placeholder.com/800x400';
    final description = event['description'] ?? 'No Description provided.';
    final location = event['location'] ?? 'TBA';
    final currentAttendees = event['currentAttendees'] ?? 0;
    final capacity = event['capacity'] ?? '?';
    
    String dateStr = 'TBA';
    String timeStr = 'TBA';
    if (event['startTime'] != null) {
      try {
        final startDt = DateTime.parse(event['startTime']).toLocal();
        dateStr = DateFormat('EEEE, MMM d').format(startDt);
        timeStr = DateFormat('HH:mm').format(startDt);
        if (event['endTime'] != null) {
           final endDt = DateTime.parse(event['endTime']).toLocal();
           timeStr += ' - ${DateFormat('HH:mm').format(endDt)}';
        }
      } catch (_) {}
    }

    String organizer = 'Unknown';
    if (event['studentClubOrganizer'] != null) {
       organizer = event['studentClubOrganizer']['name'] ?? 'Unknown';
    } else if (event['departmentOrganizer'] != null) {
       organizer = event['departmentOrganizer'].toString().replaceAll('_', ' ');
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 1,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Event Details',
          style: GoogleFonts.lexend(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: primaryColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Image
            Hero(
              tag: heroTag ?? event['id'] ?? imageUrl,
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: surfaceContainerHigh,
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        backgroundColor,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Content Container
            Transform.translate(
              offset: const Offset(0, -32),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFFC3C6D1).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: primaryColor.withOpacity(0.1)),
                            ),
                            child: Text(
                              category,
                              style: GoogleFonts.inter(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            title,
                            style: GoogleFonts.lexend(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: onSurfaceColor,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.group, color: onSurfaceVariant, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: 'Organized by ',
                                    style: GoogleFonts.inter(
                                      color: onSurfaceVariant,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: organizer,
                                        style: GoogleFonts.inter(
                                          color: primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              SizedBox(
                                width: 140, // rough width to hold stacked images
                                height: 32,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      child: _buildAvatar('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop'),
                                    ),
                                    Positioned(
                                      left: 24,
                                      child: _buildAvatar('https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&h=100&fit=crop'),
                                    ),
                                    Positioned(
                                      left: 48,
                                      child: _buildAvatar('https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop'),
                                    ),
                                    Positioned(
                                      left: 72,
                                      child: _buildAvatar('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop'),
                                    ),
                                    Positioned(
                                      left: 96,
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: surfaceContainerHigh,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: surfaceColor, width: 2),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '+124',
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '$currentAttendees / $capacity people registered',
                                style: GoogleFonts.lexend(
                                  fontSize: 12,
                                  color: onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Details Bento Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.event,
                            title: 'Date & Time',
                            line1: dateStr,
                            line2: timeStr,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.location_on,
                            title: 'Location',
                            line1: location,
                            line2: '',
                            line2Color: onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Description Section
                    Text(
                      'About Event',
                      style: GoogleFonts.lexend(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: onSurfaceColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(color: const Color(0xFFC3C6D1).withOpacity(0.3)),
                    const SizedBox(height: 16),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Action Button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.how_to_reg, color: Colors.white),
                        label: Text(
                          'Join Event',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String url) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String line1,
    required String line2,
    Color? line2Color,
  }) {
    const Color primaryColor = Color(0xFF003366);
    const Color surfaceColor = Color(0xFFFFFFFF);
    const Color onSurfaceColor = Color(0xFF0B1C30);
    const Color onSurfaceVariant = Color(0xFF43474F);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC3C6D1).withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: onSurfaceColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            line1,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            line2,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: line2Color == null ? FontWeight.w500 : FontWeight.normal,
              color: line2Color ?? primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
