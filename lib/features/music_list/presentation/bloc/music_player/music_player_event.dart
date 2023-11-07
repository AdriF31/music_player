part of 'music_player_bloc.dart';

@immutable
abstract class MusicPlayerEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OnPlayMusic extends MusicPlayerEvent{
  ResultEntity? currentMusic;
  int? index;
  OnPlayMusic({this.currentMusic,this.index});
}
class OnLoadMusic extends MusicPlayerEvent{
  List<AudioSource>?musicList;
  OnLoadMusic({this.musicList});
}
class OnPauseMusic extends MusicPlayerEvent{}
class OnResumeMusic extends MusicPlayerEvent{}
class OnStopMusic extends MusicPlayerEvent{}
class OnNextMusic extends MusicPlayerEvent{
  ResultEntity? currentMusic;
  OnNextMusic({this.currentMusic});
}
class OnPreviousMusic extends MusicPlayerEvent{
  ResultEntity? currentMusic;
  OnPreviousMusic({this.currentMusic});
}
class OnIndexChanged extends MusicPlayerEvent{
  int? index;
  ResultEntity? currentMusic;
  OnIndexChanged({this.index,this.currentMusic});
}
class OnSlideMusic extends MusicPlayerEvent{
  Duration? position;
  OnSlideMusic(this.position);
}
class OnPlaylistChange extends MusicPlayerEvent{
}
class OnListen extends MusicPlayerEvent{

}
