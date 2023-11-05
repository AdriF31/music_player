import 'package:flutter/material.dart';
import 'package:music_player/features/music_list/presentation/bloc/music/music_bloc.dart';
import 'package:music_player/features/music_list/presentation/bloc/music_player/music_player_bloc.dart';
import 'package:music_player/features/music_list/presentation/pages/music/music_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<MusicPlayerBloc>(create: (context) => MusicPlayerBloc()),
      BlocProvider(create: (context) => MusicBloc())
    ], child: const MusicView());
  }
}
