import 'package:flutter/cupertino.dart';
import 'package:travel/data/model/response/base/api_response.dart';
import 'package:travel/data/model/response/response_model.dart';
import 'package:travel/data/repo/like_repo.dart';

class LikeProvider extends ChangeNotifier {
  final LikeRepo likeRepo;

  LikeProvider({@required this.likeRepo});

  bool _success;

  bool get success => _success;

  Future<void> getLike(int contentId) async {
    _success = false;
    ApiResponse apiResponse = await likeRepo.getLike(contentId);
    if (apiResponse.response.statusCode == 200 &&
        apiResponse.response.data['success']) {
      _success = true;
    }
    notifyListeners();
  }

  Future<ResponseModel> updateLike(int contentId) async {
    ApiResponse apiResponse = await likeRepo.saveLike(contentId);
    ResponseModel responseModel;

    if (apiResponse.response.statusCode == 200 &&
        apiResponse.response.data['success']) {
      responseModel = ResponseModel(apiResponse.response.data['success'],
          apiResponse.response.data['message']);
    } else {
      responseModel = ResponseModel(apiResponse.response.data['success'],
          apiResponse.response.data['message']);
    }
    return responseModel;
  }
}
