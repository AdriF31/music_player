import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:music_player/const/api_path.dart';
import 'package:music_player/core/error/exception.dart';
import 'package:music_player/core/error/failure.dart';
import 'package:music_player/core/network.dart';
import 'package:music_player/di/injection.dart';
import 'package:music_player/features/music_list/data/data_sources/remote_data_source.dart';
import 'package:music_player/features/music_list/data/models/music_model.dart';
import 'package:music_player/features/music_list/domain/entities/music_entity.dart';
import 'package:music_player/features/music_list/domain/repositories/music_repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class MusicRepositoryImpl implements MusicRepository {
  MusicRemoteDataSource musicRemoteDataSource=MusicRemoteDataSourceImpl(network: sl());

  @override
  Future<Either<Failure, MusicEntity>> searchMusic(String? term) async {
    try {
    var res = await musicRemoteDataSource.getMusic(term);
    return Right(res);
    } on ServerException{
      return Left(ServerFailure("An error has Occured"));
    }
    on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    }
  }
}
