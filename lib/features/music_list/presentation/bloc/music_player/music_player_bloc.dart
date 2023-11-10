import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';
import 'package:music_player/features/music_list/domain/entities/music_entity.dart';

part 'music_player_event.dart';

part 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  AudioPlayer player = AudioPlayer();
  var playerStateSub;
  int? currentSongIndex;
  bool? isPlaying = false;
  int? musicLength;
  List<ResultEntity>? music = [];
  ResultEntity? currentMusic;
  List<AudioSource>? musicList = [];

  // Define the playlist
  ConcatenatingAudioSource? playlist;

  MusicPlayerBloc() : super(MusicPlayerInitial()) {
    on<MusicPlayerEvent>((event, emit) async {
      if (event is OnLoadMusic) {
        musicList?.addAll(event.musicList ?? []);
        playlist = ConcatenatingAudioSource(
          // Start loading next item just before reaching it
          useLazyPreparation: true,
          // Customise the shuffle algorithm
          shuffleOrder: DefaultShuffleOrder(),
          // Specify the playlist items
          children: musicList ?? [],
        );
        musicLength = musicList?.length;
        print("music loaded");
      }
      if (event is OnPlayMusic) {
        try {
          print(event.index);
          add(OnIndexChanged(
              index: event.index, currentMusic: event.currentMusic));
          add(OnListen());
          await player.setAudioSource(playlist!,
              initialIndex: event.index, initialPosition: Duration.zero);
          print(playlist?.length);
          // await player.setUrl(event.musicUrl ?? "");
          print("playing ${player.playing}");
          player.play();

          // player.seek(Duration(minutes: 4,seconds: 50));
          emit(OnMusicPlayed(
              isPlaying: true, currentSongIndex: currentSongIndex));
          print("music played");
        } catch (e) {
          rethrow;
        }
      }
      if (event is OnNextMusic) {
        try {
          print("playing ${player.playing}");
          await player.setAudioSource(playlist!,
              initialIndex: currentSongIndex, initialPosition: Duration.zero);
          if ((currentSongIndex! + 1) == musicLength) {
            add(OnIndexChanged(
                index: currentSongIndex, currentMusic: event.currentMusic));
            await player.seek(player.duration!);
            add(OnPauseMusic());
          } else {
            add(OnIndexChanged(
                index: currentSongIndex! + 1,
                currentMusic: event.currentMusic));
            await player.seekToNext();
          }

          player.play();
          // player.seek(Duration(minutes: 4,seconds: 50));
          emit(OnMusicPlayed(
              isPlaying: true, currentSongIndex: currentSongIndex));
          print("play next music");
        } catch (e) {
          rethrow;
        }
      }
      if (event is OnPreviousMusic) {
        try {
          print("playing ${player.playing}");
          await player.setAudioSource(playlist!,
              initialIndex: currentSongIndex, initialPosition: Duration.zero);
          if (currentSongIndex == 0) {
            print("its first song");
            add(OnIndexChanged(
                index: currentSongIndex!, currentMusic: event.currentMusic));
            await player.seek(const Duration(seconds: 0));
          } else {
            print("its not song");
            add(OnIndexChanged(
                index: currentSongIndex! - 1,
                currentMusic: event.currentMusic));
            await player.seekToPrevious();
          }
          player.play();
          // player.seek(Duration(minutes: 4,seconds: 50));
          emit(OnMusicPlayed(
              isPlaying: true, currentSongIndex: currentSongIndex));
          print("play previous music");
        } catch (e) {
          rethrow;
        }
      }
      if (event is OnPauseMusic) {
        try {
          playerStateSub.pause();
          player.pause();
          emit(OnMusicPlayed(
              isPlaying: false, currentSongIndex: currentSongIndex));
          print("music paused");
        } catch (e) {
          rethrow;
        }
      }
      if (event is OnResumeMusic) {
        try {
          playerStateSub.resume();
          player.play();
          emit(OnMusicPlayed(
              isPlaying: true, currentSongIndex: currentSongIndex));
          print("music resumed");
        } catch (e) {
          rethrow;
        }
      }
      if (event is OnStopMusic) {
        try {
          player.stop();
          playerStateSub.cancel();
          isPlaying = false;
          emit(OnMusicPlayed(
              isPlaying: false, currentSongIndex: currentSongIndex));
          print("music stop");
        } catch (e) {
          rethrow;
        }
      }
      if (event is OnSlideMusic) {
        try {
          player.seek(event.position);
          add(OnResumeMusic());
          print("music resumed");
        } catch (e) {
          rethrow;
        }
      }
      if (event is OnListen) {
        playerStateSub = player.playerStateStream.listen((state) async {
          if (state.playing) {
            print("listening");
            switch (state.processingState) {
              case ProcessingState.completed:
                add(OnStopMusic());
              case ProcessingState.ready:
                isPlaying = true;
              default:
                print(state);
            }
          }
        });
        player.positionStream.listen((event) {
          if (event == player.duration &&
              currentSongIndex != (musicList?.length ?? 0) - 1) {
            add(OnNextMusic());
          }
        });
      }
      if (event is OnIndexChanged) {
        currentSongIndex = event.index;
        currentMusic = event.currentMusic;
      }
      if (event is OnPlaylistChange) {
        musicList?.clear();
        musicList?.insert(
            0, AudioSource.uri(Uri.parse(currentMusic?.previewUrl ?? "")));
      }
    });
  }
}
