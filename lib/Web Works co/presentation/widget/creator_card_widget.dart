import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/creator.dart';

class CreatorCard extends StatelessWidget {
  final Creator creator;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const CreatorCard({
    super.key,
    required this.creator,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (creator.profileImageUrl.isEmpty) {
      // If the URL is empty, use the local asset
      imageWidget = Image.asset('assets/img/person.png', fit: BoxFit.cover);
    } else {
      // Otherwise, use the network image with an error fallback
      imageWidget = Image.network(
        creator.profileImageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) => progress == null
            ? child
            : Container(
                color: Colors.grey[900],
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00D4AA)),
                ),
              ),
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/img/person.png', fit: BoxFit.cover),
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 300),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Transform.scale(scale: 0.95 + (value * 0.05), child: child);
        },
        child: InkWell(
          onTap: () {
            context.push('/creator/${creator.id}');
          },
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: const Color(0xFF1A1A1A),
                shadowColor: Colors.teal.withOpacity(0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'profile_image_${creator.id}',
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: imageWidget,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            creator.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'Inter',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            creator.designation,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildStatItem(
                                Icons.people_outline,
                                creator.formattedFollowers,
                              ),
                              const SizedBox(width: 12),
                              _buildStatItem(
                                Icons.work_outline,
                                '${creator.projects}',
                              ),
                              const Spacer(),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: creator.statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: PopupMenuButton<String>(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  onSelected: (value) {
                    if (value == 'edit' && onEdit != null)
                      onEdit!();
                    else if (value == 'delete' && onDelete != null)
                      onDelete!();
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
