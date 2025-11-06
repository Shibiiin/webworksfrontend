// lib/presentation/manager/dashboard_controller.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:webworksco/Web%20Works%20co/presentation/widget/custom_print.dart';

import '../../data/data_source/app_service.dart';
import '../../domain/entities/creator.dart';

class DashboardController extends ChangeNotifier {
  final ApiService _apiService;
  DashboardController(this._apiService);

  // REMOVED: No more mock service instance here.
  // final MockCreatorService _creatorService = MockCreatorService();

  List<Creator> _creators = [];
  Creator? _selectedCreator;
  bool _isLoading = false;
  String? _error;

  List<Creator> get creators => _creators;
  Creator? get selectedCreator => _selectedCreator;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> fetchCreators() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _creators = await _apiService.getCreators();
    } catch (e) {
      _error = 'Failed to fetch creators: $e';
      _creators = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // FIXED: Now uses the real ApiService
  Future<void> fetchCreatorById(String id) async {
    _isLoading = true;
    _error = null;
    _selectedCreator = null; // Clear previous selection
    notifyListeners();
    try {
      _selectedCreator = await _apiService.getCreatorById(id);
    } catch (e) {
      _error = 'Failed to fetch creator: $e';
      _selectedCreator = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCreator(Creator creator) async {
    try {
      // DEBUG: Print the exact data being sent to the server
      print("--- SENDING DATA TO CREATE ---");
      print(creator.toMap());

      final newCreator = await _apiService.createCreator(creator.toMap());
      _creators.insert(0, newCreator);
      notifyListeners();
      return true;
    } catch (e) {
      // ✅ CRITICAL DEBUG STEP: Print the full error
      errorPrint("--- FAILED TO CREATE CREATOR ---");
      errorPrint("Error: $e");
      if (e is DioException) {
        errorPrint("Dio Response: ${e.response}");
      }

      _error = 'Failed to add creator.'; // Simpler error message
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCreator(Creator updatedCreator) async {
    try {
      // DEBUG: Print the exact data being sent to the server
      alertPrint("--- SENDING DATA TO UPDATE ---");
      alertPrint('Data ${updatedCreator.toMap()}');

      final returnedCreator = await _apiService.updateCreator(
        updatedCreator.id,
        updatedCreator.toMap(),
      );
      final index = _creators.indexWhere((c) => c.id == returnedCreator.id);
      if (index != -1) {
        _creators[index] = returnedCreator;
        if (_selectedCreator?.id == returnedCreator.id) {
          _selectedCreator = returnedCreator;
        }
        notifyListeners();
      }
      return true;
    } catch (e) {
      errorPrint("--- FAILED TO UPDATE CREATOR ---");
      errorPrint("Error: $e");
      if (e is DioException) {
        errorPrint("Dio Response: ${e.response}");
      }

      _error = 'Failed to update creator.';
      notifyListeners();
      return false;
    }
  }

  void removeCreatorFromLocalList(String id) {
    _creators.removeWhere((creator) => creator.id == id);
    if (_selectedCreator?.id == id) {
      _selectedCreator = null;
    }
  }

  Future<bool> deleteCreator(String id) async {
    final creatorIndex = _creators.indexWhere((c) => c.id == id);
    if (creatorIndex == -1) return false; // Creator not found
    final creatorToRemove = _creators[creatorIndex];

    removeCreatorFromLocalList(id);
    notifyListeners(); // Update UI immediately

    try {
      // Using the real ApiService
      await _apiService.deleteCreator(id);
      return true; // API call was successful
    } catch (e) {
      _error = 'Failed to delete creator: $e';
      // If API call fails, add the creator back to the list at its original position
      _creators.insert(creatorIndex, creatorToRemove);
      notifyListeners(); // Revert UI changes
      return false;
    }
    // The isLoading logic can be removed for a faster optimistic update
  }
  // Local state operations below (no changes needed)

  List<Creator> searchCreators(String query) {
    if (query.isEmpty) return _creators;
    final lowercaseQuery = query.toLowerCase();
    return _creators.where((creator) {
      return creator.name.toLowerCase().contains(lowercaseQuery) ||
          creator.designation.toLowerCase().contains(lowercaseQuery) ||
          creator.skills.any(
            (skill) => skill.toLowerCase().contains(lowercaseQuery),
          );
    }).toList();
  }

  List<Creator> filterByStatus(String status) {
    if (status == 'All') return _creators;
    return _creators.where((creator) => creator.status == status).toList();
  }

  void sortCreators(String criteria) {
    switch (criteria) {
      case 'name':
        _creators.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'followers':
        _creators.sort((a, b) => b.followers.compareTo(a.followers));
        break;
      case 'projects':
        _creators.sort((a, b) => b.projects.compareTo(a.projects));
        break;
      case 'rating':
        _creators.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'joinDate':
        _creators.sort((a, b) => b.joinDate.compareTo(a.joinDate));
        break;
    }
    notifyListeners();
  }

  Creator? getCreatorById(String id) {
    try {
      return _creators.firstWhere((creator) => creator.id == id);
    } catch (e) {
      return null;
    }
  }
}
