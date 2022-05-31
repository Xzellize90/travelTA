import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel/data/datasource/remote/dio/dio_client.dart';
import 'package:travel/data/datasource/remote/exception/api_error_handler.dart';
import 'package:travel/data/model/response/base/api_response.dart';
import 'package:travel/utill/app_constants.dart';

class ContentRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  ContentRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getContentList(
      String limit, String offset, String search) async {
    try {
      final response = await dioClient.get(
        AppConstants.CONTENT_URI,
        queryParameters: {
          'limit': limit,
          'offset': offset,
          'search': search,
          'user_id': sharedPreferences.getString(AppConstants.ID_USER),
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
