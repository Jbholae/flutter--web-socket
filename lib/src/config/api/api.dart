import 'package:dio/dio.dart';

import '../api/interceptors.dart';
import '../../../config.dart';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: Config.apiUrl,
  ),
)
  ..interceptors.add(
    LogInterceptor(
      request: true,
      error: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
    ),
  )
  ..interceptors.add(
    DioAuthInterceptors(),
  );
