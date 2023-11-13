import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/annotations.dart';
import 'package:music_player/const/api_path.dart';
import 'package:music_player/core/error/exception.dart';
import 'package:music_player/core/network.dart';
import 'package:music_player/di/injection.dart';
import 'package:music_player/features/music_list/data/data_sources/remote_data_source.dart';
import 'package:music_player/features/music_list/data/models/music_model.dart';
import 'package:music_player/features/music_list/domain/repositories/music_repository.dart';


import '../../../../core/mock_network.dart';
import '../../../../helpers/json_reader.dart';

@GenerateMocks([
  MusicRepository,
])
void main() {
  late DioAdapter dioAdapter;
  late MusicRemoteDataSourceImpl musicRemoteDataSourceImpl;
  setUp(() async {
    setupLocatorForTests();
    dioAdapter = DioAdapter(dio: sl<Network>().dio);
    musicRemoteDataSourceImpl =
        MusicRemoteDataSourceImpl(network: sl<Network>());
  });

  group('get music', () {
    test('should return music model if response status code is 200', () async {
      // Arrange
      dioAdapter.onGet(baseUrl, (server) {
        server.reply(200, readJson('helpers/dummy_data/dummy_music_data.json'));
      }, queryParameters: {"term": "eminem", "limit": 20, "entity": "song"});

      // Act
      final result = await musicRemoteDataSourceImpl.getMusic('eminem');

      // Assert
      expect(result, isA<MusicModel>());
    });

    test('should throw ServerException if response status code is 404 or other',
        () async {
      // Arrange
      dioAdapter.onGet(baseUrl, (server) {
        server.reply(404, {"error": "Not found"});
      }, queryParameters: {"term": "eminem", "limit": 20, "entity": "song"});

      // Act & Assert
      expect(() async => await musicRemoteDataSourceImpl.getMusic('eminem'),
          throwsA(isA<ServerException>()));
    });
  });
}
