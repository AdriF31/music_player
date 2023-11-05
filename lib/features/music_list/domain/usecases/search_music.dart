import 'package:dartz/dartz.dart';
import 'package:music_player/core/error/failure.dart';
import 'package:music_player/features/music_list/domain/entities/music_entity.dart';
import 'package:music_player/features/music_list/domain/repositories/music_repository.dart';

class SearchMusicUseCase{
  final MusicRepository musicRepository;

  SearchMusicUseCase(this.musicRepository);

  Future<Either<Failure,MusicEntity>> execute(String term){
    return musicRepository.searchMusic(term);
  }

}