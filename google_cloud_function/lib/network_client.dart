import 'package:dio/dio.dart';

class NetworkClient {
  static Dio client = Dio();

  static init() {
    client.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print("Sent Request to ${options.uri}");
        handler.next(options);
      },
      onResponse: (response, handler) {
        print("Received Response ${response.data}");
        handler.next(response);
      },
      onError: (e, handler) {
        print("Error ${e.message}");
        handler.next(e);
      },
    ));
  }
}
