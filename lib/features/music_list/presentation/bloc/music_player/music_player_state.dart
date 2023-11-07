part of 'music_player_bloc.dart';

@immutable
abstract class MusicPlayerState {}

class MusicPlayerInitial extends MusicPlayerState {}


class OnMusicLoad extends MusicPlayerState{
  String? message;
  OnMusicLoad({this.message});
}

class OnMusicPlayed extends MusicPlayerState{
  bool? isPlaying;
  int? currentSongIndex;
  OnMusicPlayed({this.isPlaying,this.currentSongIndex});
}

class OnMusicPaused extends MusicPlayerState{
  bool? isPlaying;
  int? currentSongIndex;
  OnMusicPaused({this.isPlaying,this.currentSongIndex});
}

class OnMusicResumed extends MusicPlayerState{
  bool? isPlaying;
  OnMusicResumed({this.isPlaying});
}

class OnMusicNext extends MusicPlayerState{
  bool? isPlaying;
  OnMusicNext({this.isPlaying});
}


class OnMusicSeek extends MusicPlayerState{

}

class OnMusicStop extends MusicPlayerState{
  bool? isPlaying;
  OnMusicStop({this.isPlaying});
}
