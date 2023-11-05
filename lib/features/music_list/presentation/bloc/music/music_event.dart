part of 'music_bloc.dart';

@immutable
abstract class MusicEvent {}

class OnMusicSearched extends MusicEvent{
  String? term;
  OnMusicSearched({this.term});
}
