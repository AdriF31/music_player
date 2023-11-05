import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/music_list/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/music_list/presentation/pages/music_controller_view.dart';

class MusicControllerPage extends StatelessWidget {
  const MusicControllerPage({super.key, required this.bloc});

  final MusicPlayerBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MusicPlayerBloc(),
      child: MusicControllerView(bloc: bloc,),
    );
  }
}
