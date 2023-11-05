
import 'package:flutter/material.dart';
import 'package:music_player/features/music_list/presentation/pages/music/music_page.dart';
import 'package:music_player/utils/style/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      home:const MusicPage(),
    );
  }
}