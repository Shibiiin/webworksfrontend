import 'package:flutter/material.dart';

class Creator {
  final String id;
  final String name;
  final String designation;
  final String about;
  final String profileImageUrl;
  final List<String> portfolioImageUrls;
  final int followers;
  final int projects;
  final double rating;
  final String email;
  final String phone;
  final String location;
  final List<String> skills;
  final List<SocialMedia> socialMedia;
  final String status; // Active, Away, Inactive
  final DateTime joinDate;
  final DateTime lastActive;
  final List<String> tags;
  final int likes;
  final int comments;
  final double engagementRate;

  Creator({
    required this.id,
    required this.name,
    required this.designation,
    required this.about,
    required this.profileImageUrl,
    required this.portfolioImageUrls,
    this.followers = 0,
    this.projects = 0,
    this.rating = 0.0,
    this.email = '',
    this.phone = '',
    this.location = '',
    this.skills = const [],
    this.socialMedia = const [],
    this.status = 'Active',
    required this.joinDate,
    required this.lastActive,
    this.tags = const [],
    this.likes = 0,
    this.comments = 0,
    this.engagementRate = 0.0,
  });

  // Empty creator for forms
  factory Creator.empty() {
    final now = DateTime.now();
    return Creator(
      id: '',
      name: '',
      designation: '',
      about: '',
      profileImageUrl: '',
      portfolioImageUrls: [],
      joinDate: now,
      lastActive: now,
    );
  }

  // Check if creator is empty/new
  bool get isNew => id.isEmpty;

  // Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'designation': designation,
      'about': about,
      'profileImageUrl': profileImageUrl,
      'portfolioImageUrls': portfolioImageUrls,
      'followers': followers,
      'projects': projects,
      'rating': rating,
      'email': email,
      'phone': phone,
      'location': location,
      'skills': skills,
      'socialMedia': socialMedia.map((sm) => sm.toMap()).toList(),
      'status': status,
      'joinDate': joinDate.millisecondsSinceEpoch,
      'lastActive': lastActive.millisecondsSinceEpoch,
      'tags': tags,
      'likes': likes,
      'comments': comments,
      'engagementRate': engagementRate,
    };
  }

  // Create from map
  factory Creator.fromMap(Map<String, dynamic> map) {
    return Creator(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      designation: map['designation'] ?? '',
      about: map['about'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      portfolioImageUrls: List<String>.from(map['portfolioImageUrls'] ?? []),
      followers: map['followers'] ?? 0,
      projects: map['projects'] ?? 0,
      rating: (map['rating'] ?? 0.0).toDouble(),
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      location: map['location'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      socialMedia: List<SocialMedia>.from(
        (map['socialMedia'] ?? []).map((x) => SocialMedia.fromMap(x)),
      ),
      status: map['status'] ?? 'Active',
      joinDate: DateTime.fromMillisecondsSinceEpoch(map['joinDate'] ?? 0),
      lastActive: DateTime.fromMillisecondsSinceEpoch(map['lastActive'] ?? 0),
      tags: List<String>.from(map['tags'] ?? []),
      likes: map['likes'] ?? 0,
      comments: map['comments'] ?? 0,
      engagementRate: (map['engagementRate'] ?? 0.0).toDouble(),
    );
  }

  // Copy with method for immutability
  Creator copyWith({
    String? id,
    String? name,
    String? designation,
    String? about,
    String? profileImageUrl,
    List<String>? portfolioImageUrls,
    int? followers,
    int? projects,
    double? rating,
    String? email,
    String? phone,
    String? location,
    List<String>? skills,
    List<SocialMedia>? socialMedia,
    String? status,
    DateTime? joinDate,
    DateTime? lastActive,
    List<String>? tags,
    int? likes,
    int? comments,
    double? engagementRate,
  }) {
    return Creator(
      id: id ?? this.id,
      name: name ?? this.name,
      designation: designation ?? this.designation,
      about: about ?? this.about,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      portfolioImageUrls: portfolioImageUrls ?? this.portfolioImageUrls,
      followers: followers ?? this.followers,
      projects: projects ?? this.projects,
      rating: rating ?? this.rating,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      skills: skills ?? this.skills,
      socialMedia: socialMedia ?? this.socialMedia,
      status: status ?? this.status,
      joinDate: joinDate ?? this.joinDate,
      lastActive: lastActive ?? this.lastActive,
      tags: tags ?? this.tags,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      engagementRate: engagementRate ?? this.engagementRate,
    );
  }

  // Helper methods...
  String get formattedFollowers {
    if (followers >= 1000000) {
      return '${(followers / 1000000).toStringAsFixed(1)}M';
    } else if (followers >= 1000) {
      return '${(followers / 1000).toStringAsFixed(1)}K';
    }
    return followers.toString();
  }

  bool get isActive => status == 'Active';
  bool get isAway => status == 'Away';
  bool get isInactive => status == 'Inactive';

  Color get statusColor {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Away':
        return Colors.orange;
      case 'Inactive':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  List<String> get topSkills => skills.take(3).toList();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Creator && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class SocialMedia {
  final String platform;
  final String username;
  final String url;
  final int followers;

  const SocialMedia({
    required this.platform,
    required this.username,
    required this.url,
    this.followers = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'platform': platform,
      'username': username,
      'url': url,
      'followers': followers,
    };
  }

  factory SocialMedia.fromMap(Map<String, dynamic> map) {
    return SocialMedia(
      platform: map['platform'] ?? '',
      username: map['username'] ?? '',
      url: map['url'] ?? '',
      followers: map['followers'] ?? 0,
    );
  }

  IconData get icon {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return Icons.camera_alt;
      case 'twitter':
        return Icons.add;
      case 'youtube':
        return Icons.play_arrow;
      case 'linkedin':
        return Icons.business;
      case 'behance':
        return Icons.palette;
      case 'dribbble':
        return Icons.sports_basketball;
      default:
        return Icons.link;
    }
  }

  Color get platformColor {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'youtube':
        return const Color(0xFFFF0000);
      case 'linkedin':
        return const Color(0xFF0A66C2);
      case 'behance':
        return const Color(0xFF1769FF);
      case 'dribbble':
        return const Color(0xFFEA4C89);
      default:
        return Colors.grey;
    }
  }
}

// Sample data generator
class CreatorSampleData {
  static List<Creator> generateSampleCreators() {
    return [
      Creator(
        id: '1',
        name: 'Sarah Chen',
        designation: 'UI/UX Designer',
        about:
            'Passionate UI/UX designer with 5+ years of experience creating beautiful and functional digital products. Specialized in mobile app design and design systems.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face',
        portfolioImageUrls: [
          'https://images.unsplash.com/photo-1558655146-9f40138edfeb?w=400&h=300&fit=crop',
          'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=400&h=300&fit=crop',
          'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=400&h=300&fit=crop',
        ],
        followers: 12400,
        projects: 24,
        rating: 4.8,
        email: 'sarah.chen@example.com',
        phone: '+1-555-0123',
        location: 'San Francisco, CA',
        skills: [
          'UI Design',
          'UX Research',
          'Figma',
          'Prototyping',
          'Design Systems',
        ],
        socialMedia: [
          SocialMedia(
            platform: 'Instagram',
            username: '@sarahchen',
            url: 'https://instagram.com/sarahchen',
            followers: 8500,
          ),
          SocialMedia(
            platform: 'Twitter',
            username: '@sarahchen_design',
            url: 'https://twitter.com/sarahchen_design',
            followers: 3200,
          ),
          SocialMedia(
            platform: 'Dribbble',
            username: 'sarahchen',
            url: 'https://dribbble.com/sarahchen',
            followers: 5400,
          ),
        ],
        status: 'Active',
        joinDate: DateTime(2022, 1, 15),
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
        tags: ['Top Rated', 'Pro Designer', 'Fast Delivery'],
        likes: 2450,
        comments: 356,
        engagementRate: 4.5,
      ),
      Creator(
        id: '2',
        name: 'Alex Rodriguez',
        designation: 'Illustrator & Artist',
        about:
            'Digital artist and illustrator specializing in character design and fantasy art. Bringing imagination to life through vibrant colors and detailed illustrations.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face',
        portfolioImageUrls: [
          'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=400&h=300&fit=crop',
          'https://images.unsplash.com/photo-1579546929662-711aa81148cf?w=400&h=300&fit=crop',
        ],
        followers: 8700,
        projects: 18,
        rating: 4.9,
        email: 'alex.rodriguez@example.com',
        location: 'New York, NY',
        skills: [
          'Digital Illustration',
          'Character Design',
          'Procreate',
          'Photoshop',
          'Concept Art',
        ],
        socialMedia: [
          SocialMedia(
            platform: 'Instagram',
            username: '@alexart',
            url: 'https://instagram.com/alexart',
            followers: 12000,
          ),
          SocialMedia(
            platform: 'Behance',
            username: 'alexrodriguez',
            url: 'https://behance.net/alexrodriguez',
            followers: 4500,
          ),
        ],
        status: 'Active',
        joinDate: DateTime(2022, 3, 10),
        lastActive: DateTime.now().subtract(const Duration(days: 1)),
        tags: ['Character Design', 'Fantasy Art'],
        likes: 1870,
        comments: 289,
        engagementRate: 4.7,
      ),
    ];
  }
}
