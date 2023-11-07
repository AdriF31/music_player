
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';

part 'music_player_event.dart';

part 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  AudioPlayer player = AudioPlayer();
  var playerStateSub;
  int? currentSongIndex;
  bool? isPlaying = false;
  int? musicLength;

  // Define the playlist
  ConcatenatingAudioSource? playlist;

  MusicPlayerBloc() : super(MusicPlayerInitial()) {
    on<MusicPlayerEvent>((event, emit) async {
      if (event is OnLoadMusic) {
        playlist = ConcatenatingAudioSource(
          // Start loading next item just before reaching it
          useLazyPreparation: true,
          // Customise the shuffle algorithm
          shuffleOrder: DefaultShuffleOrder(),
          // Specify the playlist items
          children: event.musicList ?? [],
        );
        musicLength=event.musicList?.length;
        emit(OnMusicLoad(message: "music loaded"));
      }
      if (event is OnPlayMusic) {
        try {
          add(OnIndexChanged(index: event.index));
          add(OnListen());
          await player.setAudioSource(playlist!,
              initialIndex: event.index, initialPosition: Duration.zero);
          // await player.setUrl(event.musicUrl ?? "");
          print("playing ${player.playing}");
          player.play();

          // player.seek(Duration(minutes: 4,seconds: 50));
          emit(OnMusicPlayed(isPlaying: true,currentSongIndex:currentSongIndex ));
          print("music played");
        } catch (e) {
          throw e;
        }
      }
      if(event is OnNextMusic){
        try {
          print("playing ${player.playing}");

          if((currentSongIndex!+1)==musicLength){
            add(OnIndexChanged(index: currentSongIndex));
           await player.seek(player.duration!);
           add(OnPauseMusic());
          }else{
            add(OnIndexChanged(index: currentSongIndex!+1));
            await player.seekToNext();
          }


          player.play();
          // player.seek(Duration(minutes: 4,seconds: 50));
          emit(OnMusicPlayed(isPlaying: true,currentSongIndex: currentSongIndex));
          print("play next music");
        } catch (e) {
          throw e;
        }
      }
      if(event is OnPreviousMusic){
        try {
          print("playing ${player.playing}");

          if(currentSongIndex==0){
            add(OnIndexChanged(index: currentSongIndex!));
           await player.seek(Duration(seconds: 0));
          }else{
            add(OnIndexChanged(index: currentSongIndex!-1));
            await player.seekToPrevious();
          }
          player.play();
          // player.seek(Duration(minutes: 4,seconds: 50));
          emit(OnMusicPlayed(isPlaying: true,currentSongIndex: currentSongIndex));
          print("play previous music");
        } catch (e) {
          throw e;
        }
      }
      if (event is OnPauseMusic) {
        try {
          playerStateSub.pause();
          player.pause();
          emit(OnMusicPlayed(isPlaying: false,currentSongIndex: currentSongIndex));
          print("music paused");
        } catch (e) {
          throw e;
        }
      }
      if (event is OnResumeMusic) {
        try {
          playerStateSub.resume();
          player.play();
          emit(OnMusicPlayed(isPlaying: true,currentSongIndex: currentSongIndex));
          print("music resumed");
        } catch (e) {
          throw e;
        }
      }
      if (event is OnStopMusic) {
        try {
          player.stop();
          playerStateSub.cancel();
          isPlaying = false;
          emit(OnMusicStop(isPlaying: false));
          print("music stop");
        } catch (e) {
          throw e;
        }
      }
      if (event is OnSlideMusic) {
        try {
          player.seek(event.position);
          add(OnResumeMusic());
          print("music resumed");
        } catch (e) {
          throw e;
        }
      }
      if (event is OnListen) {
        playerStateSub = player.playerStateStream.listen((state) async {
          print("sdsds");
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
          if(event==player.duration){
            add(OnNextMusic());
          }
        });
      }
      if(event is OnIndexChanged){
        currentSongIndex=event.index;
      }
    });
  }
}
