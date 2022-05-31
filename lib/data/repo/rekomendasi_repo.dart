import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:travel/data/datasource/remote/dio/dio_client.dart';
import 'package:travel/data/datasource/remote/exception/api_error_handler.dart';
import 'package:travel/data/model/response/base/api_response.dart';
import 'package:travel/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RekomendasiRepo {
  final Dio dioClient;
  final SharedPreferences sharedPreferences;
  RekomendasiRepo({
    @required this.dioClient,
    @required this.sharedPreferences,
  });

  Future<ApiResponse> getContentList(String search) async {
    try {
      final response = await dioClient.get(
        AppConstants.REKOMENDASI_URI,
        queryParameters: {
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
