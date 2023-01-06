import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import '../core/utils/api_error.dart';
import '../core/utils/message.dart';

enum MethodType { POST, GET, PUT, DELETE }

const Duration timeoutDuration = Duration(seconds: 60);

class APIHandler {
  static Map<String, String> defaultHeaders = {
    "Content-Type": "application/json",
    "device_type": Platform.isAndroid ? "1" : "2",
    "app_version": "1.0.0",
    "Accept": "*/*",
    "Accept-Encoding": "gzip, deflate, br",
  };

  static Dio dio = Dio();

  // POST method
  static Future<dynamic> post({
    dynamic requestBody,
    String? url,
    Map<String, String> additionalHeaders = const {},
  }) async {
    return await _hitApi(
      url: url!,
      methodType: MethodType.POST,
      requestBody: requestBody,
      additionalHeaders: additionalHeaders,
    );
  }

  // GET method
  static Future<dynamic> get({
    required String url,
    dynamic requestBody,
    Map<String, String> additionalHeaders = const {},
  }) async {
    return await _hitApi(
      url: url,
      methodType: MethodType.GET,
      requestBody: requestBody,
      additionalHeaders: additionalHeaders,
    );
  }

  // delete method
  static Future<dynamic> delete({
    required String url,
    dynamic requestBody,
    Map<String, String> additionalHeaders = const {},
  }) async {
    return await _hitApi(
      url: url,
      methodType: MethodType.DELETE,
      requestBody: requestBody,
      additionalHeaders: additionalHeaders,
    );
  }

  // put method
  static Future<dynamic> put({
    required dynamic requestBody,
    required String url,
    Map<String, String> additionalHeaders = const {},
  }) async {
    return await _hitApi(
      url: url,
      methodType: MethodType.PUT,
      requestBody: requestBody,
      additionalHeaders: additionalHeaders,
    );
  }

  // Generic HTTP method
  static Future<dynamic> _hitApi({
    required MethodType methodType,
    required String url,
    dynamic requestBody,
    Map<String, String> additionalHeaders = const {},
  }) async {
    Completer<dynamic> completer = Completer<dynamic>();
    try {
      Map<String, String> headers = {};
      headers.addAll(defaultHeaders);

      headers.addAll(additionalHeaders);

      Response response;

      switch (methodType) {
        case MethodType.POST:
          response = await dio
              .post(
                url,
                options: Options(
                  headers: headers,
                ),
                data: requestBody,
              )
              .timeout(timeoutDuration);

          break;
        case MethodType.GET:
          response = await dio
              .get(url,
                  options: Options(
                    headers: headers,
                  ),
                  queryParameters: requestBody)
              .timeout(timeoutDuration);

          break;
        case MethodType.PUT:
          response = await dio
              .put(
                url,
                data: json.encode(requestBody),
                options: Options(
                  headers: headers,
                ),
              )
              .timeout(timeoutDuration);
          break;
        case MethodType.DELETE:
          response = await dio
              .delete(
                url,
                options: Options(
                  headers: headers,
                ),
              )
              .timeout(timeoutDuration);
          break;
      }

      completer.complete(response.data);
    } on DioError catch (e) {
      if (e.response?.statusCode == 403) {
        APIError apiError = APIError(
          error: parseError(e.response!.data),
          status: 403,
          onAlertPop: () {},
        );
        completer.complete(apiError);
      } else if (e.response?.statusCode == 400) {
        APIError apiError = APIError(
          error: parseError(e.response!.data),
          message: e.response!.data,
          status: 400,
        );
        completer.complete(apiError);
      } else if (e.response?.statusCode == 401) {
        APIError apiError = APIError(
          error: parseError(e.response!.data),
          status: 401,
        );
        completer.complete(apiError);
      } else {
        APIError apiError = APIError(
            error: parseError(e.response?.data ?? ""),
            message: e.response?.data ?? "",
            status: e.response?.statusCode ?? 0);
        completer.complete(apiError);
      }
    } catch (e) {
      APIError apiError = APIError(error: Messages.genericError, status: 500);
      completer.complete(apiError);
    }
    return completer.future;
  }

  static String parseError(dynamic response) {
    try {
      var error = response["error"];
      if (error == null) {
        return error;
      }
      return error['message'];
    } catch (e) {
      return Messages.genericError;
    }
  }

  static String parseErrorMessage(dynamic response) {
    try {
      return response["message"];
    } catch (e) {
      return Messages.genericError;
    }
  }
}
