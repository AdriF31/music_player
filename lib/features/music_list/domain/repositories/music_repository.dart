import 'package:music_player/core/error/failure.dart';
import 'package:music_player/features/music_list/domain/entities/music_entity.dart';
import 'package:dartz/dartz.dart';
abstract class MusicRepository{
  Future<Either<Failure,MusicEntity>> searchMusic(String? term);
}