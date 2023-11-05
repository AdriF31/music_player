import 'package:mockito/annotations.dart';
import 'package:music_player/features/music_list/domain/repositories/music_repository.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [
    MusicRepository
  ],
      customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main(){

}