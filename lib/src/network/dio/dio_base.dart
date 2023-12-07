import 'package:dio/dio.dart';

import '../../../config.dart';
import '../interceptor/custom_interceptor.dart';


class BaseDio {
  static BaseDio instance = BaseDio._internal();
  late Dio dio;

  factory BaseDio({required String hostUrl, int defaultTimeOut = 15000}) {
    instance =
        BaseDio._internal(hostUrl: hostUrl, defaultTimeOut: defaultTimeOut);
    return instance;
  }

  BaseDio._internal({String hostUrl = Config.baseUrl, int defaultTimeOut = 15000}) {
    dio = Dio(BaseOptions(
        baseUrl: hostUrl,
        connectTimeout: Duration(milliseconds: defaultTimeOut)));
    dio.interceptors.add(CustomInterceptors());
  }

  Future<Response> get(String pathUrl, {String? path}) async {
    return await dio.get(pathUrl);
  }

  Future<Response> post(String pathUrl, {body}) async {
    return await dio.post(pathUrl, data: body);
  }

  Future<Response> put({required String pathUrl, body}) async {
    return await dio.put(pathUrl, data: body);
  }

  Future<Response> delete({required String pathUrl, body}) async {
    return await dio.delete(pathUrl, data: body);
  }
}
