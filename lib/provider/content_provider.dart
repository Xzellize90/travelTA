import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:travel/data/model/response/base/api_response.dart';
import 'package:travel/data/model/response/content_model.dart';

import 'package:travel/data/repo/content_repo.dart';

class ContentProvider extends ChangeNotifier {
  final ContentRepo contentRepo;
  ContentProvider({@required this.contentRepo});

  List<ContentModel> _contentList;
  bool _isLoading;

  List<ContentModel> get contentList => _contentList;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = false;
  }

  Future<void> getContentList(bool reload, String search) async {
    if (_contentList == null || reload || search != null) {
      _isLoading = true;
      ApiResponse apiResponse =
          await contentRepo.getContentList('', '', search);
      if (apiResponse.response.data['success'] == true) {
        _contentList = [];
        apiResponse.response.data['data'].forEach((category) {
          _contentList.add(ContentModel.fromJson(category));
        });
      } else {
        _contentList = [];
      }
      _isLoading = false;
      notifyListeners();
    }
  }
}
