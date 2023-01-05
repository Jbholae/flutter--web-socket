import 'dart:ui';

class APIError {
  String? error;
  dynamic message;
  int? status;
  VoidCallback? onAlertPop;

  APIError({this.error, this.status, this.message, this.onAlertPop});

  APIError.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    return data;
  }
}

class APIErrorMessage {
  bool? success;
  int? errorCode;
  int? status;
  String? message;
  ErrorData? errorData;

  APIErrorMessage(
      {this.success,
      this.errorCode,
      this.status,
      this.message,
      this.errorData});

  APIErrorMessage.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    errorCode = json['errorCode'];
    status = json['status'];
    message = json['message'];
    errorData =
        json['data'] != null ? new ErrorData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['errorCode'] = this.errorCode;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.errorData != null) {
      data['error_data'] = this.errorData!.toJson();
    }
    return data;
  }
}

class ErrorData {
  String? info;

  ErrorData({this.info});

  ErrorData.fromJson(Map<String, dynamic> json) {
    info = json['info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['info'] = this.info;
    return data;
  }
}
