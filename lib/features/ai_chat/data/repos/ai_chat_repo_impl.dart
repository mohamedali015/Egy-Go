import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:egy_go/core/network/api_helper.dart';
import 'package:egy_go/core/network/api_response.dart';
import 'package:egy_go/core/network/end_points.dart';
import 'package:egy_go/features/ai_chat/data/models/ai_message_model.dart';
import 'package:egy_go/features/ai_chat/data/repos/ai_chat_repo.dart';
import 'package:egy_go/features/places/data/models/places_response_model.dart';

class AiChatRepoImpl implements AiChatRepo {
  final ApiHelper apiHelper;

  AiChatRepoImpl({required this.apiHelper});

  @override
  Future<Either<String, AiChatResponseModel>> sendMessage(
      String message) async {
    try {
      print('[AiChatRepo] Sending message: $message');

      final response = await apiHelper.postRequest(
        endPoint: 'chat',
        data: {'message': message},
        isProtected: false, // Public endpoint
      );

      print('[AiChatRepo] Response success: ${response.success}');
      print('[AiChatRepo] Response data: ${response.data}');

      if (response.success) {
        return Right(AiChatResponseModel.fromJson(response.data));
      } else {
        return Left(response.message ?? 'Failed to send message');
      }
    } on DioException catch (e) {
      print('[AiChatRepo] DioException: ${e.response?.data}');
      return Left(e.response?.data?['message'] ?? 'Network error occurred');
    } catch (e) {
      print('[AiChatRepo] Exception: $e');
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, PlaceReference>> getPlaceDetails(String placeId) async {
    try {
      print('[AiChatRepo] Fetching place details for ID: $placeId');

      final response = await apiHelper.getRequest(
        endPoint: 'places/$placeId',
        isProtected: false,
      );

      print('[AiChatRepo] Place details response: ${response.data}');

      if (response.success) {
        final placeData = response.data['data'] ?? response.data;
        return Right(PlaceReference.fromJson(placeData));
      } else {
        return Left(response.message ?? 'Failed to fetch place details');
      }
    } on DioException catch (e) {
      print('[AiChatRepo] DioException: ${e.response?.data}');
      return Left(e.response?.data?['message'] ?? 'Network error occurred');
    } catch (e) {
      print('[AiChatRepo] Exception: $e');
      return Left('Unexpected error: ${e.toString()}');
    }
  }
}
