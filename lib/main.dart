import 'package:boilerplate/constants/app_theme.dart';
import 'package:boilerplate/constants/strings.dart';
import 'package:boilerplate/di/components/app_component.dart';
import 'package:boilerplate/di/modules/local_module.dart';
import 'package:boilerplate/di/modules/netwok_module.dart';
import 'package:boilerplate/di/modules/preference_module.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/amenity/amenity_store.dart';
import 'package:boilerplate/stores/area/area_store.dart';
import 'package:boilerplate/stores/category/category_store.dart';
import 'package:boilerplate/stores/city/city_store.dart';
import 'package:boilerplate/stores/district/district_store.dart';
import 'package:boilerplate/stores/form/filter_form.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/stores/type/type_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/splash/splash.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:inject/inject.dart';
import 'package:provider/provider.dart';

import 'nav_service.dart';
import 'notifications/notification_manageer.dart';

// global instance for app component
AppComponent appComponent;

void main() {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.white, // navigation bar color
  //   // statusBarColor: Colors.black, // status bar color
  // ));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) async {
    appComponent = await AppComponent.create(
      NetworkModule(),
      LocalModule(),
      PreferenceModule(),
    );
    runApp(appComponent.app);
  });
}

@provide
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // Create your store as a final variable in a base Widget. This works better
  // with Hot Reload than creating it directly in the `build` function.
  final ThemeStore _themeStore = ThemeStore(appComponent.getRepository());
  final PostStore _postStore = PostStore(appComponent.getRepository());
  final CityStore _cityStore = CityStore(appComponent.getRepository());
  final AreaStore _areaStore = AreaStore(appComponent.getRepository());
  final _filterStore = FilterFormStore();
  final AmenityStore _amenityStore = AmenityStore(appComponent.getRepository());
  final DistrictStore _districtStore =
      DistrictStore(appComponent.getRepository());
  final CategoryStore _categoryStore =
      CategoryStore(appComponent.getRepository());
  final LanguageStore _languageStore =
      LanguageStore(appComponent.getRepository());
  final TypeStore _typeStore = TypeStore(appComponent.getRepository());
  final UserStore userStore = UserStore(appComponent.getRepository());
  final PushNotificationsManager _firebaseMessaging =
      PushNotificationsManager();

  @override
  Widget build(BuildContext context) {
    // void logOut() {
    //   appComponent.getRepository().logOut();
    //   Navigator.of(context)
    //       .pushNamedAndRemoveUntil(Routes.login, (vakue) => false);
    // }

    return MultiProvider(
      providers: [
        Provider<ThemeStore>(create: (_) => _themeStore),
        Provider<CityStore>(create: (_) => _cityStore),
        Provider<PostStore>(create: (_) => _postStore),
        Provider<AreaStore>(create: (_) => _areaStore),
        Provider<FilterFormStore>(create: (_) => _filterStore),
        Provider<DistrictStore>(create: (_) => _districtStore),
        Provider<CategoryStore>(create: (_) => _categoryStore),
        Provider<LanguageStore>(create: (_) => _languageStore),
        Provider<TypeStore>(create: (_) => _typeStore),
        Provider<UserStore>(create: (_) => userStore),
        Provider<AmenityStore>(create: (_) => _amenityStore),
        Provider<PushNotificationsManager>(create: (_) => _firebaseMessaging),
      ],
      child: Observer(
        name: 'global-observer',
        builder: (context) {
          return MaterialApp(
            navigatorKey: NavigationService.instance.navigationKey,
            debugShowCheckedModeBanner: false,
            title: Strings.appName,
            theme: _themeStore.darkMode ? themeDataDark : themeData,
            routes: Routes.routes,
            locale: Locale(_languageStore.locale),
            supportedLocales: _languageStore.supportedLanguages
                .map((language) => Locale(language.locale, language.code))
                .toList(),
            localizationsDelegates: [
              // A class which loads the translations from JSON files
              AppLocalizations.delegate,
              // Built-in localization of basic text for Material widgets
              GlobalMaterialLocalizations.delegate,
              // Built-in localization for text direction LTR/RTL
              GlobalWidgetsLocalizations.delegate,
              // Built-in localization of basic text for Cupertino widgets
              GlobalCupertinoLocalizations.delegate,
            ],
            home: MySplashScreen(),
          );
        },
      ),
    );
  }
}
