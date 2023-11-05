import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';

part 'music_player_event.dart';

part 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  AudioPlayer player = AudioPlayer();
  var playerStateSub;
  MusicPlayerBloc() : super(MusicPlayerInitial()) {

    on<MusicPlayerEvent>((event, emit) async {
      if (event is OnPlayMusic) {
        try {
          add(OnListen());
          await player.setUrl(
              "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview123/v4/ac/2b/54/ac2b5458-02e9-206b-e0f0-cc06f44e59a3/mzaf_5940701668146496946.std.aac.p.m4a");
          print("playing ${player.playing}");
          player.play();

          // player.seek(Duration(minutes: 4,seconds: 50));
          emit(OnMusicPlayed(isPlaying: true));
          print("music played");
        } catch (e) {
          throw e;
        }
      }
      if (event is OnPauseMusic) {
        try {
          print("playing ${player.playing}");
          player.pause();
          print(player.duration);
          emit(OnMusicPaused(isPlaying: false));
          print("music paused");
        } catch (e) {
          throw e;
        }
      }
      if (event is OnResumeMusic) {
        try {
          player.play();
          emit(OnMusicResumed());
          print("music resumed");
        } catch (e) {
          throw e;
        }
      }
      if(event is OnStopMusic){
        try {
          player.stop();
          playerStateSub.cancel();
          emit(OnMusicStop());
          print("music stop");
        } catch (e) {
          throw e;
        }
      }
      if (event is OnListen) {
      playerStateSub=  player.playerStateStream.listen((state)async {
          print("listening");
          if(state.playing){

            switch (state.processingState) {
              case ProcessingState.completed:
                add(OnStopMusic());
                print("music finish");
              case ProcessingState.ready:
                print("music ready");
              default:
                print(state);
            }
          }
        });
      }
    });
  }
}
