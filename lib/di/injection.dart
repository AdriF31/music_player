import 'package:get_it/get_it.dart';
import 'package:music_player/core/network.dart';

final sl = GetIt.I;
Future<void> init()async{
//extern
sl.registerFactory(() => Network());
}