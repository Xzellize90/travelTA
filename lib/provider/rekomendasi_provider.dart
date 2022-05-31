import 'package:flutter/material.dart';
import 'package:travel/data/model/response/base/api_response.dart';
import 'package:travel/data/model/response/content_model.dart';
import 'package:travel/data/repo/rekomendasi_repo.dart';

class RekomendasiProvider extends ChangeNotifier {
  final RekomendasiRepo rekomendasiRepo;

  RekomendasiProvider({@required this.rekomendasiRepo});

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
      ApiResponse apiResponse = await rekomendasiRepo.getContentList(search);
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
