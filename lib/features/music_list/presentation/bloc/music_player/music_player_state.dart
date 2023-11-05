part of 'music_player_bloc.dart';

@immutable
abstract class MusicPlayerState {}

class MusicPlayerInitial extends MusicPlayerState {}

class OnMusicPlayed extends MusicPlayerState{
  bool? isPlaying;
  OnMusicPlayed({this.isPlaying});
}

class OnMusicPaused extends MusicPlayerState{
  bool? isPlaying;
  OnMusicPaused({this.isPlaying});
}

class OnMusicResumed extends MusicPlayerState{
  bool? isPlaying;
  OnMusicResumed({this.isPlaying});
}


class OnMusicSeek extends MusicPlayerState{

}

class OnMusicStop extends MusicPlayerState{
  bool? isPlaying;
  OnMusicStop({this.isPlaying});
}
