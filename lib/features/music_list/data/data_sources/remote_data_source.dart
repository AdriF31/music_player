import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:music_player/const/api_path.dart';
import 'package:music_player/core/error/exception.dart';
import 'package:music_player/core/network.dart';
import 'package:music_player/features/music_list/data/models/music_model.dart';

abstract class MusicRemoteDataSource {
  Future<MusicModel> getMusic(String? term);
}

class MusicRemoteDataSourceImpl extends MusicRemoteDataSource {
  Network network = Network();

  MusicRemoteDataSourceImpl({required this.network});

  @override
  Future<MusicModel> getMusic(String? term) async {
    try {
      var res = await network.dio.get(baseUrl,
          queryParameters: {"term": term, "limit": 20, "entity": "song"});
      if (res.statusCode == 200) {
        return MusicModel.fromJson(jsonDecode(res.data));
      } else {
        throw ServerException();
      }
    } on DioException catch(error){
      throw ServerException();
    }
  }
}
