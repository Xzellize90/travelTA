import 'package:flutter/material.dart';
import 'package:travel/data/model/response/language_model.dart';
import 'package:travel/utill/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext context}) {
    return AppConstants.languages;
  }
}
