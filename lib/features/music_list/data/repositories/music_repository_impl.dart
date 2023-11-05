import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:music_player/const/api_path.dart';
import 'package:music_player/core/error/failure.dart';
import 'package:music_player/features/music_list/data/models/music_model.dart';
import 'package:music_player/features/music_list/domain/entities/music_entity.dart';
import 'package:music_player/features/music_list/domain/repositories/music_repository.dart';

class MusicRepositoryImpl implements MusicRepository {
  Dio dio = Dio();

  @override
  Future<Either<Failure, MusicEntity>> searchMusic(String? term) async {
    try {
      dio.interceptors.add(LogInterceptor(request: true,responseBody: true));
      var res = await dio.get(baseUrl, queryParameters: {"term": term});
      if (res.statusCode == 200) {
        var data = MusicModel.fromJson(jsonDecode(res.data));
        return Right(data);
      } else {
        return Left(ServerFailure(res.statusMessage));
      }
    } catch (e) {
      rethrow;
    }
  }
}
