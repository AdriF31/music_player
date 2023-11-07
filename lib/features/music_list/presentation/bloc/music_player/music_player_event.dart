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
class OnLoadMusic extends MusicPlayerEvent{
  List<AudioSource>?musicList;
  OnLoadMusic({this.musicList});
}
class OnPauseMusic extends MusicPlayerEvent{}
class OnResumeMusic extends MusicPlayerEvent{}
class OnStopMusic extends MusicPlayerEvent{}
class OnNextMusic extends MusicPlayerEvent{}
class OnPreviousMusic extends MusicPlayerEvent{}
class OnIndexChanged extends MusicPlayerEvent{
  int? index;
  OnIndexChanged({this.index});
}
class OnSlideMusic extends MusicPlayerEvent{
  Duration? position;
  OnSlideMusic(this.position);
}
class OnListen extends MusicPlayerEvent{

}
