import 'package:dio/dio.dart';

import '../api/interceptors.dart';
import '../../../config.dart';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: Config.apiUrl,
  ),
)..interceptors.add(
  DioAuthInterceptors(),
);