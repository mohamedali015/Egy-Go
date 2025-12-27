import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:egy_go/core/network/api_helper.dart';
import 'package:egy_go/features/trip/data/models/chat_message_model.dart';
import 'package:egy_go/features/trip/data/repos/chat_repo.dart';

class ChatRepoImpl implements ChatRepo {
  final ApiHelper apiHelper;

  ChatRepoImpl({required this.apiHelper});

  @override
  Future<Either<String, ChatAccessResponseModel>> checkChatAccess(
      String tripId) async {
    try {
      final response = await apiHelper.getRequest(
        endPoint: 'chat/$tripId/access',
        isProtected: true,
      );

      if (response.success) {
        return Right(ChatAccessResponseModel.fromJson(response.data));
      } else {
        return Left(response.message ?? 'Failed to check chat access');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return Left('Chat not available for this trip');
      }
      return Left(e.response?.data?['message'] ?? 'Network error occurred');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, ChatMessagesResponseModel>> getChatMessages(
      String tripId) async {
    try {
      final response = await apiHelper.getRequest(
        endPoint: 'chat/$tripId/messages',
        isProtected: true,
      );

      if (response.success) {
        return Right(ChatMessagesResponseModel.fromJson(response.data));
      } else {
        return Left(response.message ?? 'Failed to load messages');
      }
    } on DioException catch (e) {
      return Left(e.response?.data?['message'] ?? 'Network error occurred');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }
}
