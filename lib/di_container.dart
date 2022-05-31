import 'package:dio/dio.dart';
import 'package:travel/data/repo/content_repo.dart';
import 'package:travel/data/repo/favorit_repo.dart';
import 'package:travel/data/repo/kategori_repo.dart';
import 'package:travel/data/repo/language_repo.dart';
import 'package:travel/data/repo/like_repo.dart';
import 'package:travel/data/repo/lokasi_repo.dart';
import 'package:travel/data/repo/rekomendasi_repo.dart';
import 'package:travel/provider/Kategori_provider.dart';
import 'package:travel/provider/auth_provider.dart';
import 'package:travel/provider/content_provider.dart';
import 'package:travel/provider/favorit_provider.dart';
import 'package:travel/provider/language_provider.dart';
import 'package:travel/provider/like_provider.dart';
import 'package:travel/provider/localization_provider.dart';
import 'package:travel/provider/lokasi_provider.dart';
import 'package:travel/provider/rekomendasi_provider.dart';
import 'package:travel/utill/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'data/repo/auth_repo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());

  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.BASE_URL, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // repo
  sl.registerLazySingleton(() => LanguageRepo());
  sl.registerLazySingleton(
      () => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => ContentRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => RekomendasiRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => KategoriRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => LokasiRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => FavoritRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => LikeRepo(dioClient: sl(), sharedPreferences: sl()));

  // Provider
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));
  sl.registerFactory(() => LanguageProvider(languageRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => ContentProvider(contentRepo: sl()));
  sl.registerFactory(() => RekomendasiProvider(rekomendasiRepo: sl()));
  sl.registerFactory(() => KategoriProvider(kategoriRepo: sl()));
  sl.registerFactory(() => LokasiProvider(lokasiRepo: sl()));
  sl.registerFactory(() => FavoritProvider(favoritRepo: sl()));
  sl.registerFactory(() => LikeProvider(likeRepo: sl()));
}
