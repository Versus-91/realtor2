import 'dart:async' as _i14;

import 'package:dio/src/dio.dart' as _i5;

import '../../data/local/datasources/city_datasource.dart' as _i12;
import '../../data/local/datasources/post/favorite_datasource.dart' as _i10;
import '../../data/local/datasources/post/post_datasource.dart' as _i9;
import '../../data/local/datasources/search_datasource.dart' as _i11;
import '../../data/network/apis/posts/post_api.dart' as _i8;
import '../../data/network/dio_client.dart' as _i6;
import '../../data/network/rest_client.dart' as _i7;
import '../../data/repository.dart' as _i13;
import '../../data/sharedpref/shared_preference_helper.dart' as _i4;
import '../../main.dart' as _i16;
import '../modules/local_module.dart' as _i2;
import '../modules/netwok_module.dart' as _i15;
import '../modules/preference_module.dart' as _i3;
import 'app_component.dart' as _i1;

class AppComponent$Injector implements _i1.AppComponent {
  AppComponent$Injector._(this._localModule, this._preferenceModule);

  final _i2.LocalModule _localModule;

  final _i3.PreferenceModule _preferenceModule;

  _i4.SharedPreferenceHelper _singletonSharedPreferenceHelper;

  _i5.Dio _singletonDio;

  _i6.DioClient _singletonDioClient;

  _i7.RestClient _singletonRestClient;

  _i8.PostApi _singletonPostApi;

  _i9.PostDataSource _singletonPostDataSource;

  _i10.FavoriteDataSource _singletonFavoriteDataSource;

  _i11.SearchDataSource _singletonSearchDataSource;

  _i12.CityDataSource _singletonCityDataSource;

  _i13.Repository _singletonRepository;

  static _i14.Future<_i1.AppComponent> create(
      _i15.NetworkModule _,
      _i2.LocalModule localModule,
      _i3.PreferenceModule preferenceModule) async {
    final injector = AppComponent$Injector._(localModule, preferenceModule);

    return injector;
  }

  _i16.MyApp _createMyApp() => _i16.MyApp();
  _i13.Repository _createRepository() =>
      _singletonRepository ??= _localModule.provideRepository(
          _createPostApi(),
          _createSharedPreferenceHelper(),
          _createPostDataSource(),
          _createFavoriteDataSource(),
          _createSearchDataSource(),
          _createCityDataSource());
  _i8.PostApi _createPostApi() => _singletonPostApi ??=
      _localModule.providePostApi(_createDioClient(), _createRestClient());
  _i6.DioClient _createDioClient() =>
      _singletonDioClient ??= _localModule.provideDioClient(_createDio());
  _i5.Dio _createDio() => _singletonDio ??=
      _localModule.provideDio(_createSharedPreferenceHelper());
  _i4.SharedPreferenceHelper _createSharedPreferenceHelper() =>
      _singletonSharedPreferenceHelper ??=
          _preferenceModule.provideSharedPreferenceHelper();
  _i7.RestClient _createRestClient() =>
      _singletonRestClient ??= _localModule.provideRestClient();
  _i9.PostDataSource _createPostDataSource() =>
      _singletonPostDataSource ??= _localModule.providePostDataSource();
  _i10.FavoriteDataSource _createFavoriteDataSource() =>
      _singletonFavoriteDataSource ??= _localModule.provideFavoriteDataSource();
  _i11.SearchDataSource _createSearchDataSource() =>
      _singletonSearchDataSource ??= _localModule.provideSearchDataSource();
  _i12.CityDataSource _createCityDataSource() =>
      _singletonCityDataSource ??= _localModule.provideCityDataSource();
  @override
  _i16.MyApp get app => _createMyApp();
  @override
  _i13.Repository getRepository() => _createRepository();
}
