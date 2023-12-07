import 'dart:developer';
import 'package:dio/dio.dart';

class CustomInterceptors extends Interceptor {
  CustomInterceptors();
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept'] = 'application/json';

    log("┌------------------------------------------------------------------------------");
    log('''| [DIO] Request: ${options.method} ${options.uri}
      | ${options.data.toString()}''');
    log("├------------------------------------------------------------------------------");

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("| [DIO] Response [code ${response.statusCode}]: ${response.data.toString()}");
    log("└------------------------------------------------------------------------------");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    log('| [DIO] Error: [code ${err.response?.statusCode}] ${err.response}');
    log("└------------------------------------------------------------------------------");
    super.onError(err, handler);
  }




}
