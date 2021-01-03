import 'package:dio/dio.dart';
import 'package:waterconnection/Helpers/SessionData.dart';

Dio getDio(String requestType) {
  Dio dio = new Dio();
  dio.options.followRedirects = false;
  dio.options.validateStatus = (status) {
    return status <= 500;
  };
  if (requestType == "json") {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
  } else if (requestType == "formdata") {
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Accept'] = '*/*';
  }
  if (SessionData().data.token != null) {
    dio.options.headers['Authorization'] = 'Bearer ' + SessionData().data.token;
  }
  //dio.interceptors.add(DioFirebasePerformanceInterceptor());
  dio.options.responseType = ResponseType.json;

  return dio;
}
