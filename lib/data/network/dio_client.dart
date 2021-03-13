import 'package:boilerplate/main.dart';
import 'package:dio/dio.dart';

import '../../nav_service.dart';
import '../../routes.dart';

class DioClient {
  // dio instance
  final Dio _dio;

  // injecting dio instance
  DioClient(this._dio);

  // Get:-----------------------------------------------------------------------
  Future<dynamic> get(
    String uri, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return response.data;
    } catch (e) {
      if (e?.response?.statusCode == 401) {
        appComponent.getRepository().logOut().then((res) {
          NavigationService.instance.navigateToRemoevUntil(Routes.login);
        });
      }
      throw e;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<dynamic> post(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      if (e?.response?.statusCode == 401) {
        appComponent.getRepository().logOut().then((res) {
          NavigationService.instance.navigateToRemoevUntil(Routes.login);
        });
      }
      throw e;
    }
  }

  //put
  Future<dynamic> put(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      if (e?.response?.statusCode == 401) {
        appComponent.getRepository().logOut().then((res) {
          NavigationService.instance.navigateToRemoevUntil(Routes.login);
        });
      }
      throw e;
    }
  }

  //delet
  Future<dynamic> delete(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      if (e?.response?.statusCode == 401) {
        appComponent.getRepository().logOut().then((res) {
          NavigationService.instance.navigateToRemoevUntil(Routes.login);
        });
      }
      throw e;
    }
  }
}
