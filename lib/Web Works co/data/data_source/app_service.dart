// lib/data/remote/api_service.dart

import 'package:dio/dio.dart';
import 'package:webworksco/Web%20Works%20co/data/remote/app_url.dart';
import 'package:webworksco/Web%20Works%20co/presentation/widget/custom_print.dart';

import '../../domain/entities/creator.dart';

class ApiService {
  final Dio _dio;
  ApiService._(this._dio);

  static final ApiService instance = ApiService._(
    Dio(
      BaseOptions(
        baseUrl: AppRemotesRoutes.baseUrl,
        headers: {'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    ),
  );

  /// GET all creators
  Future<List<Creator>> getCreators() async {
    try {
      final response = await _dio.get(AppRemotesRoutes.creators);
      final List<dynamic> data = response.data;
      successPrint("Creators details Loaded ${data.length}");
      successPrint("Creators details Loaded ${response.data}");
      return data.map((json) => Creator.fromMap(json)).toList();
    } on DioException catch (e) {
      print("Error fetching creators: $e");
      throw Exception('Failed to load creators');
    }
  }

  /// ADDED: GET a single creator by ID
  Future<Creator> getCreatorById(String creatorId) async {
    try {
      final response = await _dio.get(AppRemotesRoutes.creatorId(creatorId));
      return Creator.fromMap(response.data);
    } on DioException catch (e) {
      print("Error fetching creator by ID: $e");
      throw Exception('Failed to load creator details');
    }
  }

  /// DELETE a creator
  Future<void> deleteCreator(String creatorId) async {
    try {
      await _dio.delete(AppRemotesRoutes.creatorId(creatorId));
    } on DioException catch (e) {
      print("Error deleting creator: $e");
      throw Exception('Failed to delete creator.');
    }
  }

  /// POST a new creator
  Future<Creator> createCreator(Map<String, dynamic> creatorData) async {
    try {
      final response = await _dio.post(
        AppRemotesRoutes.creators,
        data: creatorData,
      );
      return Creator.fromMap(response.data);
    } on DioException catch (e) {
      print("Error creating creator: $e");
      throw Exception('Failed to create creator.');
    }
  }

  /// PUT (update) a creator
  Future<Creator> updateCreator(
    String creatorId,
    Map<String, dynamic> creatorData,
  ) async {
    try {
      final response = await _dio.put(
        AppRemotesRoutes.creatorId(creatorId),
        data: creatorData,
      );
      return Creator.fromMap(response.data);
    } on DioException catch (e) {
      print("Error updating creator: $e");
      throw Exception('Failed to update creator.');
    }
  }
}
