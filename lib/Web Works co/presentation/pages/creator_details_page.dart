import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/creator.dart';
import '../manager/dashboard_controller.dart';

class CreatorDetailPage extends StatefulWidget {
  final String creatorId;

  const CreatorDetailPage({super.key, required this.creatorId});

  @override
  State<CreatorDetailPage> createState() => _CreatorDetailPageState();
}

class _CreatorDetailPageState extends State<CreatorDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardController>(
        context,
        listen: false,
      ).fetchCreatorById(widget.creatorId);
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showDeleteDialog(BuildContext context, Creator creator) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Delete Creator',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to delete ${creator.name}? This action cannot be undone.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                // Pop the dialog first
                Navigator.of(dialogContext).pop();

                final success = await Provider.of<DashboardController>(
                  context,
                  listen: false,
                ).deleteCreator(creator.id);

                if (success && mounted) {
                  // After successful deletion, pop the detail page to return to the list
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('${creator.name} deleted successfully'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Failed to delete creator'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final creatorViewModel = Provider.of<DashboardController>(context);
    final creator = creatorViewModel.selectedCreator;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.share, color: Colors.white),
            ),
            onPressed: () {},
          ),
          if (creator != null) // Only show if creator data is available
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
              ),
              onPressed: () {
                _showDeleteDialog(context, creator);
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: creatorViewModel.isLoading || creator == null
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D4AA)),
              ),
            )
          : AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: child,
                  ),
                );
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header with Hero (slower animation)
                    Center(
                      child: Column(
                        children: [
                          Hero(
                            tag: 'profile_image_${creator.id}',
                            flightShuttleBuilder:
                                (
                                  flightContext,
                                  animation,
                                  flightDirection,
                                  fromHeroContext,
                                  toHeroContext,
                                ) {
                                  return AnimatedBuilder(
                                    animation: animation,
                                    builder: (context, child) {
                                      return Material(
                                        color: Colors.transparent,
                                        child: Opacity(
                                          opacity: animation.value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 140,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFF00D4AA),
                                          width: 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF00D4AA,
                                            ).withOpacity(0.3),
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          creator.profileImageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF00D4AA),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF00D4AA,
                                    ).withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  creator.profileImageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                            color: const Color(0xFF00D4AA),
                                          ),
                                        );
                                      },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Name with word-by-word animation
                          AnimatedText(
                            text: creator.name,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'Inter',
                            ),
                            duration: const Duration(milliseconds: 800),
                          ),
                          const SizedBox(height: 8),

                          // Designation with word-by-word animation
                          AnimatedText(
                            text: creator.designation,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                            duration: const Duration(milliseconds: 600),
                            delay: const Duration(milliseconds: 400),
                          ),
                          const SizedBox(height: 16),

                          // Stats Row
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey[800]!),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildDetailStat(
                                  'Followers',
                                  creator.formattedFollowers,
                                ),
                                _buildDetailStat(
                                  'Projects',
                                  '${creator.projects}',
                                ),
                                _buildDetailStat(
                                  'Rating',
                                  creator.rating.toStringAsFixed(1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // About Section with word-by-word animation
                    _buildSection(
                      title: 'About',
                      child: AnimatedText(
                        text: creator.about,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.white70,
                          fontFamily: 'Inter',
                        ),
                        duration: const Duration(milliseconds: 1500),
                        delay: const Duration(milliseconds: 600),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Skills Section
                    _buildSection(
                      title: 'Skills',
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: creator.topSkills.map((skill) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00D4AA).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF00D4AA).withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              skill,
                              style: const TextStyle(
                                color: Color(0xFF00D4AA),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Portfolio Section
                    _buildSection(
                      title: 'Portfolio',
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: creator.portfolioImageUrls.length,
                        itemBuilder: (context, index) {
                          return AnimatedContainer(
                            duration: Duration(
                              milliseconds: 600 + (index * 200),
                            ),
                            curve: Curves.easeOut,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                creator.portfolioImageUrls[index],
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: Colors.grey[900],
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                            color: const Color(0xFF00D4AA),
                                          ),
                                        ),
                                      );
                                    },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

  Widget _buildDetailStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF00D4AA),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Word-by-word text animation
class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;
  final Duration delay;

  const AnimatedText({
    super.key,
    required this.text,
    required this.style,
    required this.duration,
    this.delay = Duration.zero,
  });

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _textAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _textAnimation = IntTween(
      begin: 0,
      end: widget.text.length,
    ).animate(_controller);

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _textAnimation,
      builder: (context, child) {
        final displayedText = widget.text.substring(0, _textAnimation.value);
        return Text(displayedText, style: widget.style);
      },
    );
  }
}
