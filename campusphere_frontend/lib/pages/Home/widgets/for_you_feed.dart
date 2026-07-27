import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campusphere_frontend/auxiliary/app_theme.dart';
import 'package:campusphere_frontend/services/home_feed_service.dart';
import 'package:campusphere_frontend/pages/EventDetails/event_details_page.dart';

/// "For You" section including the header and the horizontally scrolling feed.
class ForYouFeed extends StatefulWidget {
  const ForYouFeed({super.key});

  @override
  State<ForYouFeed> createState() => _ForYouFeedState();
}

class _ForYouFeedState extends State<ForYouFeed> {
  final ScrollController _scrollController = ScrollController();
  final List<dynamic> _events = [];
  bool _isLoading = false;
  bool _isLastPage = false;
  int _pageNumber = 0;
  final int _pageSize = 5;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchEvents();
    }
  }

  Future<void> _fetchEvents() async {
    if (_isLoading || _isLastPage) return;

    setState(() {
      _isLoading = true;
    });

    final response = await HomeFeedService.fetchAllUpcomingEvents(_pageNumber, _pageSize);
    
    if (response != null && response['success'] == true) {
      final data = response['data'];
      final content = data['content'] as List<dynamic>;
      
      setState(() {
        _events.addAll(content);
        _isLastPage = data['last'] == true;
        _pageNumber++;
      });
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ForYouHeader(),
        const SizedBox(height: 12),
        if (_events.isEmpty && _isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_events.isEmpty && !_isLoading)
          Center(
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
          )
        else
          SizedBox(
            height: 280,
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _events.length + (_isLastPage ? 0 : 1),
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                if (index == _events.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final event = _events[index];
                final heroTag = 'feed-${event['id'] ?? event['coverImageUrl'] ?? index}';
                return SizedBox(
                  width: 240,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EventDetailsPage(
                            event: event as Map<String, dynamic>,
                            heroTag: heroTag,
                          ),
                        ),
                      );
                    },
                    child: FeedCard(
                    heroTag: heroTag,
                    imageUrl: event['coverImageUrl'] ?? '',
                    category: event['category'] ?? 'Event',
                    title: event['title'] ?? 'No Title',
                    description: event['description'] ?? 'No Description',
                    metaIcon: Icons.location_on_outlined,
                    metaText: event['location'] ?? 'TBA',
                  ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

/// Header row with title.
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

/// Feed card used in the "For You" list.
class FeedCard extends StatelessWidget {
  final String heroTag;
  final String imageUrl;
  final String category;
  final String title;
  final String description;
  final IconData metaIcon;
  final String metaText;

  const FeedCard({
    super.key,
    required this.heroTag,
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
                  Hero(
                    tag: heroTag,
                    child: Image.network(
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
          Expanded(
            child: Padding(
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
                  Expanded(
                    child: Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        color: AppColors.onSurfaceVariant,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(metaIcon, size: 14, color: AppColors.outline),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          metaText,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.outline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

