import 'package:get_it/get_it.dart';
import 'package:music_player/core/network.dart';

final sl = GetIt.instance;
Future<void> init()async{
//extern
sl.registerSingleton<Network>(Network());
}