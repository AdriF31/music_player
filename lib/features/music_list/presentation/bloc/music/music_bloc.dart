import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:music_player/features/music_list/data/models/music_model.dart';
import 'package:music_player/features/music_list/data/repositories/music_repository_impl.dart';
import 'package:music_player/features/music_list/domain/entities/music_entity.dart';
import 'package:music_player/features/music_list/domain/repositories/music_repository.dart';

part 'music_event.dart';

part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicRepository musicRepository = MusicRepositoryImpl();

  MusicBloc() : super(MusicInitial()) {
    on<MusicEvent>((event, emit) async {
      if (event is OnMusicSearched) {
        emit(OnLoadingGetMusic());
        try {
          var data = await musicRepository.searchMusic(event.term);
          data.fold((l) => emit(OnErrorGetMusic()),
              (r) => emit(OnSuccessGetMusic(data: r)));
        } catch (e) {
          rethrow;
        }
      }
    });
  }
}
