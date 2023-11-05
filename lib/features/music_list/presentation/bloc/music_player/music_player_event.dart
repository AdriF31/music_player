part of 'music_player_bloc.dart';

@immutable
abstract class MusicPlayerEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OnPlayMusic extends MusicPlayerEvent{
  String? musicUrl;
  int? index;
  OnPlayMusic({this.musicUrl,this.index});
}
class OnPauseMusic extends MusicPlayerEvent{}
class OnResumeMusic extends MusicPlayerEvent{}
class OnStopMusic extends MusicPlayerEvent{}
class OnSlideMusic extends MusicPlayerEvent{
  Duration? position;
  OnSlideMusic(this.position);
}
class OnListen extends MusicPlayerEvent{

}
