part of 'music_bloc.dart';

@immutable
abstract class MusicState  extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MusicInitial extends MusicState {}

class OnLoadingGetMusic extends MusicState{}

class OnSuccessGetMusic extends MusicState{
  MusicEntity? data;
  List<AudioSource>? musicList;
  OnSuccessGetMusic({this.data,this.musicList});
}

class OnErrorGetMusic extends MusicState{}
