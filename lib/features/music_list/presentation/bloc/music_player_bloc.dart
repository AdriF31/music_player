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
              "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/27/39/18/27391889-acec-5c7d-feae-10b77f420ee6/mzaf_7325735014632280538.plus.aac.p.m4a");
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
          add(OnListen());
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
      if(event is OnSlideMusic){
        try {
          player.seek(event.position);
          add(OnResumeMusic());
          print("music resumed");
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
