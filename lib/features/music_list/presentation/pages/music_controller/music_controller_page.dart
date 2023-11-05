import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/music_list/presentation/bloc/music_player/music_player_bloc.dart';
import 'package:music_player/features/music_list/presentation/dto/music_dto.dart';
import 'package:music_player/features/music_list/presentation/pages/music_controller/music_controller_view.dart';

class MusicControllerPage extends StatelessWidget {
  const MusicControllerPage({super.key, required this.bloc,this.dto});

  final MusicPlayerBloc bloc;
  final MusicDTO? dto;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MusicPlayerBloc(),
      child: MusicControllerView(bloc: bloc,dto: dto,),
    );
  }
}
