import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_player/core/network.dart';
import 'package:music_player/di/injection.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class MockNetwork extends Mock implements Network {
  Dio dio = Dio();
  MockNetwork() {
    dio.options = BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {"Accept": "application/json"});
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 140));
  }
}

void setupLocatorForTests()  {
  sl.reset(); // Reset the locator to clear any previous registrations

  // Register your mock dependencies here
  sl.registerSingleton<Network>(MockNetwork());
}
