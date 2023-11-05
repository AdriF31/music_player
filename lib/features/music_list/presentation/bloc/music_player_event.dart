part of 'music_player_bloc.dart';

@immutable
abstract class MusicPlayerEvent {}

class OnPlayMusic extends MusicPlayerEvent{}
class OnPauseMusic extends MusicPlayerEvent{}
class OnResumeMusic extends MusicPlayerEvent{}
class OnStopMusic extends MusicPlayerEvent{}
class OnSlideMusic extends MusicPlayerEvent{
  Duration? position;
  OnSlideMusic(this.position);
}
class OnListen extends MusicPlayerEvent{

}
