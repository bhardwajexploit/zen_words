import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/connect.dart';

class ApiService extends GetConnect {
  final String url;
  final dynamic data;

  ApiService({required this.url, required this.data});

  Dio _dio() {
    // Put your authorization token here..
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(minutes: 1),
        receiveTimeout: const Duration(minutes: 1),
        followRedirects: true,
        // responseType: ResponseType.plain,
        headers: {"Content-Type": "application/json; charset=utf-8"},
      ),
    );

    // dio.interceptors.add(
    //   InterceptorsWrapper(
    //     onResponse: (response, handler) {
    //       if (response.data is String) {
    //         response.data = json.decode(utf8.decode(response.data.codeUnits));
    //       }
    //       handler.next(response);
    //     },
    //   ),
    // );

    return dio;
  }

  // To print API request details..
  void _logRequest(String method) {
    if (kDebugMode) {
      print("🚨 🌐 API CALL Method >>>>>>>>>>  [$method]");
      print("🚨 ➡️ API URL >>>>>>>>>>  $url");
      print("🚨 ➡️ APT Request Data >>>>>>>>>>  $data \n");
    }
  }

  // Get request..
  void getRequest({
    required Function() beforeSend,
    required Function(dynamic data) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    _logRequest("GET");
    beforeSend();
    await _dio()
        .get(url /*, data: json.encode(data)*/)
        .then((response) {
      if (kDebugMode) {
        print("🚨 Dio Full Raw Response SUCCESS >>>>>>>>>>  ${response.data}");
      }
      onSuccess(response.data);
    })
        .catchError((error) {
      // Handle errors here...
      onError(_handleErrors(error));
    });
  }

  // Post request with json data..
  void postRequest({
    required Function() beforeSend,
    required Function(dynamic data) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    _logRequest("POST");
    beforeSend();
    await _dio()
        .post(url, data: json.encode(data))
        .then((response) {
      if (kDebugMode) {
        print("🚨 Dio Full Raw Response SUCCESS >>>>>>>>>>  ${response.data}");
      }
      onSuccess(response.data);
    })
        .catchError((error) {
      // Handle errors here...
      onError(_handleErrors(error));
    });
  }

  // Post request to upload image with form data..
  void postRequestMultipart({
    required Function() beforeSend,
    required Function(dynamic data) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    _logRequest("POST");
    beforeSend();
    await _dio()
        .post(
      url,
      data: data,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    )
        .then((response) {
      if (kDebugMode) {
        print("🚨 Dio Full Raw Response SUCCESS >>>>>>>>>>  ${response.data}");
      }
      onSuccess(response.data);
    })
        .catchError((error) {
      // Handle errors here...
      onError(_handleErrors(error));
    });
  }

  // Put request with json data..
  void putRequest({
    required Function() beforeSend,
    required Function(dynamic data) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    _logRequest("PUT");
    beforeSend();
    await _dio()
        .put(url, data: json.encode(data))
        .then((response) {
      if (kDebugMode) {
        print("🚨 Dio Full Raw Response SUCCESS >>>>>>>>>>  ${response.data}");
      }
      onSuccess(response.data);
    })
        .catchError((error) {
      // Handle errors here...
      onError(_handleErrors(error));
    });
  }

  // Put request to upload image with form data..
  void putRequestMultipart({
    required Function() beforeSend,
    required Function(dynamic data) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    _logRequest("PUT");
    beforeSend();
    await _dio()
        .put(
      url,
      data: data,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    )
        .then((response) {
      if (kDebugMode) {
        print("🚨 Dio Full Raw Response SUCCESS >>>>>>>>>>  ${response.data}");
      }
      onSuccess(response.data);
    })
        .catchError((error) {
      // Handle errors here...
      onError(_handleErrors(error));
    });
  }

  // Delete request with json data..
  void deleteRequest({
    required Function() beforeSend,
    required Function(dynamic data) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    _logRequest("DELETE");
    beforeSend();
    await _dio()
        .delete(url, data: json.encode(data))
        .then((response) {
      if (kDebugMode) {
        print("🚨 Dio Full Raw Response SUCCESS >>>>>>>>>>  ${response.data}");
      }
      onSuccess(response.data);
    })
        .catchError((error) {
      // Handle errors here...
      onError(_handleErrors(error));
    });
  }

  Map<String, dynamic> _handleErrors(error) {
    if (error == null) {
      return {'code': -1, 'message': 'Unknown error occurred.'};
    }

    if (kDebugMode) {
      print("🚨 Dio Full Raw Response ERROR >>>>>>>>>>  ${error.toString()}");
      if (error is DioException) {
        print("🚨 Dio ERROR Type >>>>>>>>>>  ${error.type}");
        print("🚨 Dio ERROR Message >>>>>>>>>>  ${error.message}");
        print(
          "🚨 Dio ERROR Response StatusCode >>>>>>>>>>  ${error.response?.statusCode?.toString() ?? "No status code"}",
        );
        print("🚨 Dio ERROR Response StatusMessage >>>>>>>>>>  ${error.response?.statusMessage ?? "No message"}");
        print("🚨 Dio ERROR Response >>>>>>>>>>  ${error.response ?? "No response"}");
        print("🚨 Dio ERROR Response Data >>>>>>>>>>  ${error.response?.data.toString() ?? "No data"}");
      }
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return {'code': 0, 'message': 'Connection timeout, please try again.'};

        case DioExceptionType.cancel:
          return {'code': 0, 'message': 'Request was cancelled.'};

        case DioExceptionType.badCertificate:
          return {'code': 0, 'message': 'Invalid SSL certificate.'};

        case DioExceptionType.connectionError:
          return {'code': 0, 'message': 'Network error occurred.'};

        case DioExceptionType.badResponse:
          final responseData = error.response?.data;

          if (responseData == null) {
            return {'code': 0, 'message': 'Server error occurred.'};
          }

          String message;

          if (responseData is Map && responseData['message'] != null) {
            message = responseData['message'].toString();
          } else {
            message = error.response?.statusMessage ?? 'Server error occurred.';
          }

          return {'code': error.response?.statusCode ?? 0, 'message': message, 'data': responseData};

        case DioExceptionType.unknown:
          return {'code': 0, 'message': 'Unexpected error occurred.'};

      }
    }

    // Not a Dio error..
    return {'code': -1, 'message': 'Something went wrong.'};
  }

// // Previous handleErrors method..
// Map<String, dynamic>? handleErrors(error) {
//   if (error == null) return null;
//   if (kDebugMode) {
//     print("🚨 Full ERROR:  $error");
//     print("🚨 Full ERROR Response:  ${error.response}");
//   }
//   Map<String, dynamic>? errorDetails;
//
//   if (error.response != null) {
//     try {
//       if (kDebugMode) {
//         print("🚨 ERROR Response Code: ${error.response?.statusCode}");
//         print("🚨 ERROR Response StatusMessage: ${error.response?.statusMessage}");
//         print("🚨 ERROR Response Data:  ${error.response?.data}");
//       }
//       errorDetails = {
//         'code': error.response?.statusCode,
//         'message': error.response?.data['message'],
//         'data': error.response?.data,
//       };
//     } catch (e) {
//       errorDetails = {'code': error.response?.statusCode, 'message': error.response?.statusMessage};
//     }
//   } else {
//     if (kDebugMode) {
//       print("🚨 Dio ERROR Message: ${error.message}");
//     }
//     errorDetails = {'code': 0, 'message': "Network error occurred!"};
//   }
//   return errorDetails;
// }
}