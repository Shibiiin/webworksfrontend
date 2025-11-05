import '../entities/creator.dart';

class MockCreatorService {
  final List<Creator> _mockCreators = [
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
      socialMedia: [],
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
      socialMedia: [],
      status: 'Active',
      joinDate: DateTime(2022, 3, 10),
      lastActive: DateTime.now().subtract(const Duration(days: 1)),
      tags: ['Character Design', 'Fantasy Art'],
      likes: 1870,
      comments: 289,
      engagementRate: 4.7,
    ),
    Creator(
      id: '3',
      name: 'Maya Patel',
      designation: 'Motion Designer',
      about:
          'Creative motion designer with expertise in 2D and 3D animation. Creating engaging visual stories that captivate audiences and enhance brand experiences.',
      profileImageUrl:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop&crop=face',
      portfolioImageUrls: [
        'https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=400&h=300&fit=crop',
        'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=400&h=300&fit=crop',
      ],
      followers: 15200,
      projects: 31,
      rating: 4.7,
      email: 'maya.patel@example.com',
      location: 'Los Angeles, CA',
      skills: [
        'After Effects',
        'Cinema 4D',
        'Motion Graphics',
        '3D Animation',
        'Visual Effects',
      ],
      socialMedia: [],
      status: 'Away',
      joinDate: DateTime(2022, 2, 20),
      lastActive: DateTime.now().subtract(const Duration(days: 7)),
      tags: ['Animation', '3D Artist'],
      likes: 3120,
      comments: 423,
      engagementRate: 4.6,
    ),
  ];

  // Get all creators
  Future<List<Creator>> getCreators() async {
    await Future.delayed(
      const Duration(milliseconds: 800),
    ); // Simulate network delay
    return List.from(_mockCreators);
  }

  // Get creator by ID
  Future<Creator?> getCreatorById(String id) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    try {
      return _mockCreators.firstWhere((creator) => creator.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add new creator
  Future<Creator> addCreator(Creator creator) async {
    await Future.delayed(
      const Duration(milliseconds: 800),
    ); // Simulate network delay

    final newCreator = creator.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      joinDate: DateTime.now(),
      lastActive: DateTime.now(),
    );

    _mockCreators.insert(0, newCreator);
    return newCreator;
  }

  // Update existing creator
  Future<bool> updateCreator(Creator updatedCreator) async {
    await Future.delayed(
      const Duration(milliseconds: 800),
    ); // Simulate network delay

    final index = _mockCreators.indexWhere(
      (creator) => creator.id == updatedCreator.id,
    );
    if (index != -1) {
      _mockCreators[index] = updatedCreator;
      return true;
    }
    return false;
  }

  // Delete creator
  Future<bool> deleteCreator(String id) async {
    await Future.delayed(
      const Duration(milliseconds: 600),
    ); // Simulate network delay

    final initialLength = _mockCreators.length;
    _mockCreators.removeWhere((creator) => creator.id == id);
    return _mockCreators.length < initialLength;
  }

  // Search creators
  Future<List<Creator>> searchCreators(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (query.isEmpty) return _mockCreators;

    final lowercaseQuery = query.toLowerCase();
    return _mockCreators.where((creator) {
      return creator.name.toLowerCase().contains(lowercaseQuery) ||
          creator.designation.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
