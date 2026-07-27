import 'package:campusphere_frontend/services/home_feed_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:campusphere_frontend/auxiliary/app_theme.dart';
import 'package:campusphere_frontend/pages/EventDetails/event_details_page.dart';

class HighlightCard extends StatefulWidget {

  // TODO: change the type of these props to dynamic, i will use them in the home page
   String? title;
   String? description;
   String? imageUrl;
   String? category;
   String? eventTime;



  @override
  State<HighlightCard> createState() => _HighlightCardState();
}

class _HighlightCardState extends State<HighlightCard> {
  Map<String, dynamic>? fullEvent;

  @override
  void initState() {
    super.initState();
    // fetch a random event and set the state 

    HomeFeedService.fetchRandomUpcomingEvent().then((event) {
      if (event != null) {
        setState(() {
          fullEvent = event['data'];
          widget.title = event['data']['title'];
          widget.description = event['data']['description'];
          widget.imageUrl = event['data']['coverImageUrl'];
          widget.category = event['data']['category'];
          final dt = DateTime.parse(event['data']['startTime']).toLocal();
          widget.eventTime = '⏱ ${DateFormat('EEE, MMM d · h:mm a').format(dt)}';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String heroTag = 'highlight-${fullEvent?['id'] ?? widget.imageUrl}';
    return  widget.imageUrl == null ? Center(child: CircularProgressIndicator()) : ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 280,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Hero(
              tag: heroTag,
              child: Image.network(
                widget.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: AppColors.primaryContainer),
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
                        label: widget.category ?? '',
                        bgColor: AppColors.secondaryContainer,
                        textColor: AppColors.onSecondaryContainer,
                      ),
                      const SizedBox(width: 8),
                      _Chip(
                        label: widget.eventTime ?? '',
                        bgColor: Colors.white.withValues(alpha: 0.2),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.title ?? '',
                    style: GoogleFonts.lexend(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description ?? '',
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
                    onPressed: () {
                      if (fullEvent != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EventDetailsPage(
                              event: fullEvent!,
                              heroTag: heroTag,
                            ),
                          ),
                        );
                      }
                    },
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
