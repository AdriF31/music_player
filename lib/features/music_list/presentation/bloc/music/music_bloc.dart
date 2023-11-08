
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';
import 'package:music_player/features/music_list/data/repositories/music_repository_impl.dart';
import 'package:music_player/features/music_list/domain/entities/music_entity.dart';
import 'package:music_player/features/music_list/domain/repositories/music_repository.dart';

part 'music_event.dart';

part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicRepository musicRepository = MusicRepositoryImpl();


  List<AudioSource>? musicList = [];
  List<ResultEntity>? music=[];
  MusicBloc() : super(MusicInitial()) {
    on<MusicEvent>((event, emit) async {
      if (event is OnMusicSearched) {
        emit(OnLoadingGetMusic());
        try {
          var data = await musicRepository.searchMusic(event.term);
          data.fold((l) => emit(OnErrorGetMusic()),
              (r) {
            musicList?.clear();
                r.results?.forEach((element) {
                  if(element.previewUrl!=null){
                    musicList?.add(AudioSource.uri(Uri.parse(element.previewUrl??"")));
                  }
                 });
                emit(OnSuccessGetMusic(data: r,musicList: musicList));
              });
        } catch (e) {
          rethrow;
        }
      }
    });
  }
}
