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

  bool get isNew => id.isEmpty;

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

  // ✅ *** THE MAIN FIX IS IN THIS FACTORY CONSTRUCTOR ***
  factory Creator.fromMap(Map<String, dynamic> map) {
    // Helper function to robustly parse dates that could be an integer OR a String
    DateTime _parseDate(dynamic dateValue) {
      if (dateValue == null) return DateTime.now();
      // For new creators from the app (sent as int)
      if (dateValue is int) {
        return DateTime.fromMillisecondsSinceEpoch(dateValue);
      }
      // For existing creators from db.json (stored as String)
      if (dateValue is String) {
        return DateTime.tryParse(dateValue) ?? DateTime.now();
      }
      // Fallback
      return DateTime.now();
    }

    return Creator(
      id:
          map['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: map['name'] ?? 'No Name',
      designation: map['designation'] ?? 'No Designation',
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
      status: map['status'] ?? 'Active',

      // Use the robust date parsing function
      joinDate: _parseDate(map['joinDate']),
      lastActive: _parseDate(map['lastActive']),

      // ✅ Added all other missing fields to prevent errors
      socialMedia:
          (map['socialMedia'] as List<dynamic>?)
              ?.map((sm) => SocialMedia.fromMap(sm as Map<String, dynamic>))
              .toList() ??
          [],
      tags: List<String>.from(map['tags'] ?? []),
      likes: map['likes'] ?? 0,
      comments: map['comments'] ?? 0,
      engagementRate: (map['engagementRate'] ?? 0.0).toDouble(),
    );
  }

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

  // --- No changes needed below this line ---

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
