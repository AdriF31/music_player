import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:music_player/const/api_path.dart';
import 'package:music_player/core/network.dart';
import 'package:music_player/di/injection.dart';
import 'package:music_player/features/music_list/data/data_sources/remote_data_source.dart';
import 'package:music_player/features/music_list/data/models/music_model.dart';
import 'package:music_player/features/music_list/domain/repositories/music_repository.dart';
import 'package:http/http.dart' as http;

import '../../../../helpers/json_reader.dart';
import '../../../../helpers/test_helper.mocks.dart';

@GenerateMocks(
  [
    MusicRepository
  ],
  customMocks: [MockSpec<http.Client>(as:#MockHttpClient)],
)

void main(){
  final network = Network();
  final dioAdapter = DioAdapter(dio:network.dio );
  late MusicRemoteDataSourceImpl musicRemoteDataSourceImpl;

  setUp(() {
    musicRemoteDataSourceImpl=MusicRemoteDataSourceImpl(network: network);
  });

  group('get music', () {
    test('should return music model if response statue code is 200', ()async {
      //arrange
      when(dioAdapter.onGet(baseUrl,(server){
        server.reply(200, readJson('helpers/dummy_data/dummy_music_data.json'));
      },queryParameters: {"term": "eminem","limit":20,"entity":"song"}));
      //act
      final result = await musicRemoteDataSourceImpl.getMusic('eminem');
      //assert
      expect(result, isA<MusicModel>());
    });
  });

}

