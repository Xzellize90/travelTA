import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:travel/data/datasource/remote/dio/dio_client.dart';
import 'package:travel/data/datasource/remote/exception/api_error_handler.dart';
import 'package:travel/data/model/response/base/api_response.dart';
import 'package:travel/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> registration(
      String email, String password, int role) async {
    try {
      Response response = await dioClient.post(
        AppConstants.REGISTER_URI,
        data: {'email': email, 'password': password, 'role': role},
      ).timeout(const Duration(seconds: 10));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(
          ApiErrorHandler.getMessage('Terjadi kesalahan'));
    }
  }

  Future<void> saveUserData(int idUser, String email) async {
    try {
      sharedPreferences.setString(AppConstants.ID_USER, idUser.toString());
      sharedPreferences.setString(AppConstants.EMAIL, email);
      print(
          'get user data >> ${sharedPreferences.getString(AppConstants.ID_USER)}, $email');
    } catch (e) {}
  }

  Future<ApiResponse> login(String email, String password) async {
    try {
      Response response = await dioClient.post(
        AppConstants.LOGIN_URI,
        data: {"email": email, "password": password, "role": 1},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e.toString());
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.ID_USER);
  }

  Future<bool> clearSharedData() async {
    await sharedPreferences.remove(AppConstants.ID_USER);
    await sharedPreferences.remove(AppConstants.EMAIL);
    return true;
  }
}
