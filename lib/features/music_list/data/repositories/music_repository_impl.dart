import 'package:dartz/dartz.dart';
import 'package:music_player/core/error/failure.dart';
import 'package:music_player/features/music_list/domain/entities/music_entity.dart';
import 'package:music_player/features/music_list/domain/repositories/music_repository.dart';

class MusicRepositoryImpl implements MusicRepository{
  @override
  Future<Either<Failure, MusicEntity>> searchMusic(String? term) {
    // TODO: implement searchMusic
    throw UnimplementedError();
  }

}