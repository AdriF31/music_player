
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:music_player/features/music_list/domain/entities/music_entity.dart';
import 'package:music_player/features/music_list/domain/usecases/search_music.dart';

import '../../../../helpers/test_helper.mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  late SearchMusicUseCase searchMusicUseCase;
  late MockMusicRepository mockMusicRepository;

  setUp((){
    mockMusicRepository=MockMusicRepository();
    searchMusicUseCase=SearchMusicUseCase(mockMusicRepository);
  });

  const testMusicList = MusicEntity(
    resultCount: 1,
    results: [ResultEntity(
        artistName: "Eminem",
        collectionExplicitness: "",
        copyright: "",
        country: "",
        description: "",
        image: "",
        isStreamable: true,
        kind: "",
        previewUrl: "",
        primaryGenreName: "",
        trackCount: 1,
        trackId: 1,
        trackName: "",
        trackViewUrl: ""
    )]
  );

  const term = "eminem";
  test('get music from music repository', () async{
    //arrange
    when(
      mockMusicRepository.searchMusic(term)
    ).thenAnswer((_) async=>  const Right(testMusicList));

    //act
    final result = await searchMusicUseCase.execute(term);

    //assert
    expect(result,const Right(testMusicList));
  });
}