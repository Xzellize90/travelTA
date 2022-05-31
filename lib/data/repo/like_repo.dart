import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel/data/datasource/remote/dio/dio_client.dart';
import 'package:travel/data/datasource/remote/exception/api_error_handler.dart';
import 'package:travel/data/model/response/base/api_response.dart';
import 'package:travel/utill/app_constants.dart';

class LikeRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  LikeRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getLike(int contentId) async {
    try {
      Response response =
          await dioClient.get(AppConstants.LIKE_URI, queryParameters: {
        "user_id": sharedPreferences.getString(AppConstants.ID_USER),
        "content_id": contentId
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e.toString());
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> saveLike(int contentId) async {
    try {
      final Map<String, dynamic> data = {
        "user_id": sharedPreferences.getString(AppConstants.ID_USER),
        "content_id": contentId
      };
      print(data);

      Response response = await dioClient.post(
        AppConstants.LIKE_URI,
        data: data,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e.toString());
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
