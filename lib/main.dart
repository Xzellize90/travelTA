// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'package:travel/router_helper.dart';
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
import 'package:travel/utill/routes.dart';

import 'di_container.dart' as di;
import 'local/app_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
        ChangeNotifierProvider(create: (context) => di.sl<ContentProvider>()),
        ChangeNotifierProvider(
            create: (context) => di.sl<LocalizationProvider>()),
        ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (context) => di.sl<KategoriProvider>()),
        ChangeNotifierProvider(create: (context) => di.sl<LokasiProvider>()),
        ChangeNotifierProvider(create: (context) => di.sl<FavoritProvider>()),
        ChangeNotifierProvider(create: (context) => di.sl<LikeProvider>()),
        ChangeNotifierProvider(
            create: (context) => di.sl<RekomendasiProvider>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences sharedPreferences;
  String initalRoutes = Routes.LOGIN_SCREEN;

  @override
  void initState() {
    super.initState();
    RouterHelper.setupRouter();
    checking();
  }

  Future<void> checking() async {
    // melakukan pengecekan status login
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      setState(() {
        // apabila sudah melakukan login makan akan dikembalikan kehalaman main
        initalRoutes = Routes.DASHBOARD;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Locale> _locals = [];
    AppConstants.languages.forEach((language) {
      _locals.add(Locale(language.languageCode, language.countryCode));
    });

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          initialRoute: initalRoutes,
          onGenerateRoute: RouterHelper.router.generator,
          title: 'Travel',
          navigatorKey: MyApp.navigatorKey,
          debugShowCheckedModeBanner: false,
          locale: Provider.of<LocalizationProvider>(context).locale,
          localizationsDelegates: [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: _locals,
        );
      },
    );
  }
}
