import 'package:flutter/material.dart';
import 'package:music_player/core/app/app.dart';
import 'package:music_player/di/injection.dart'as di;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const App());
}

