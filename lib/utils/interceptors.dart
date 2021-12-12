// import 'dart:async';

// import 'package:dio/dio.dart';
// import 'package:logger/logger.dart';

// class AppInterceptors extends Interceptor {
//   Dio dio;
//   AppInterceptors({required this.dio});

//   Logger _logger = Logger();

//   @override
//   Future<dynamic> onError(
//       DioError dioError, ErrorInterceptorHandler error) async {
//     switch (dioError.response?.statusCode) {
//       case 400:
//         break;
//       case 401:
//         break;
//       case 403:
//         break;
//       case 409:
//         break;
//       case 408:
//         break;
//       case 500:
//         _logger.e("Request Error ::" + dioError.message);
//         break;
//       default:
//     }
//   }

//   @override
//   Future<dynamic> onResponse(
//       Response response, ResponseInterceptorHandler handler) async {
//     switch (response.statusCode) {
//       case 200:
//         _logger.d("Request Success :: " + response.toString());
//         return response;
//       case 204:
//         _logger.d("Request Success :: " + response.toString());
//         return response;
//       default:
//         return response;
//     }
//   }
// }
