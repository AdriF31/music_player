import 'dart:async';

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
  bool? isPlaying=false;
  MusicPlayerBloc() : super(MusicPlayerInitial()) {

    on<MusicPlayerEvent>((event, emit) async {
      if (event is OnPlayMusic) {
        try {

            currentSongIndex=event.index;

          add(OnListen());
          await player.setUrl(event.musicUrl??"");
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
          playerStateSub.pause();
          player.pause();
          emit(OnMusicPaused(isPlaying: false));
          print("music paused");
        } catch (e) {
          throw e;
        }
      }
      if (event is OnResumeMusic) {
        try {
          playerStateSub.resume();
          player.play();
          emit(OnMusicResumed(isPlaying: true));
          print("music resumed");
        } catch (e) {
          throw e;
        }
      }
      if(event is OnStopMusic){
        try {
          player.stop();
          playerStateSub.cancel();
          isPlaying=false;
          emit(OnMusicStop(isPlaying: false));
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
        print("sdsds");
          if(state.playing){
            print("listening");
            switch (state.processingState) {
              case ProcessingState.completed:
                add(OnStopMusic());
              case ProcessingState.ready:
                isPlaying=true;
              default:
                print(state);
            }
          }
        });
      }
    });
  }
}
