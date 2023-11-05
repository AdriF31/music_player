import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:music_player/features/music_list/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/utils/style/colors.dart';

class MusicControllerView extends StatefulWidget{
  const MusicControllerView({super.key, required this.bloc});

  final MusicPlayerBloc bloc;

  @override
  State<MusicControllerView> createState() => _MusicControllerViewState();
}

class _MusicControllerViewState extends State<MusicControllerView> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  double _sliderValue = 0;
  bool? isSliderChange=false;
  Duration? position ;

  // String formattedDuration = formatDuration(duration);

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "$twoDigitMinutes:$twoDigitSeconds";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Now Playing"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CachedNetworkImage(
                imageUrl:
                    "https://static.wikia.nocookie.net/blinks/images/0/07/The_Album_Version_4_Album_Cover.png/revision/latest?cb=20200903175351",
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Text("Playing With Fire",style: TextStyle(
                fontFamily: 'gilroy',
                fontSize: 24,
                fontWeight: FontWeight.bold),),
            SizedBox(
              height: 8,
            ),
            Text("BlackPink",style: TextStyle(
                fontFamily: 'gilroy',
                fontSize: 16,
                fontWeight: FontWeight.bold),),
            SizedBox(
              height: 24,
            ),
            BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
              bloc: widget.bloc,
              builder: (context, state) {
                return Column(
                  children: [
                    StreamBuilder(
                        stream: widget.bloc.player.positionStream,
                        builder: (context, snapshot) {
                          print(snapshot.connectionState);
                         if(snapshot.connectionState==ConnectionState.active){
                           if (snapshot.hasData) {
                             print("has data : ${snapshot.data}");
                               position = snapshot.data;
                             _sliderValue = (position??Duration(seconds: 0)).inSeconds.toDouble();
                             print(_sliderValue);
                             return Column(
                               children: [
                                 Slider(
                                   value: _sliderValue,
                                   divisions: (widget.bloc.player.duration??Duration(seconds: 0)).inSeconds,
                                   onChanged: (value) {
                                     isSliderChange=true;
                                     position = Duration(seconds: value.toInt());
                                     widget.bloc.add(OnPauseMusic());
                                   },
                                   onChangeEnd: (value){
                                     position = Duration(seconds: value.toInt());
                                     // widget.bloc.player.seek(position);
                                     widget.bloc.add(OnSlideMusic(position));
                                   },
                                   min: 0,
                                   max: (widget.bloc.player.duration??Duration(seconds: 0)).inSeconds
                                       .toDouble(),
                                 ),
                                 Row(
                                   mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(formatDuration(position??Duration(seconds: 0))),
                                     Text(formatDuration((widget.bloc.player.duration??Duration(seconds: 0)))==0?"-":formatDuration((widget.bloc.player.duration??Duration(seconds: 0))))
                                   ],
                                 )
                               ],
                             );
                           }else{
                             return Slider(
                               value: 0,
                               onChanged: (value) {},
                             );
                           }
                         }
                         return Slider(
                           value: 0,
                           onChanged: (value) {},
                         );

                        }),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed: (){}, icon: Icon(FluentIcons.previous_24_filled)),
                        IconButton(
                            onPressed:
                                state is OnMusicPlayed || state is OnMusicResumed
                                    ? () async {
                                        widget.bloc.add(OnPauseMusic());
                                      }
                                    : state is OnMusicPaused
                                        ? () {
                                            widget.bloc.add(OnResumeMusic());
                                          }
                                        : () {
                                            widget.bloc.add(OnPlayMusic());
                                          },
                            icon: Icon(
                                state is OnMusicPlayed || state is OnMusicResumed
                                    ? FluentIcons.pause_24_filled
                                    : state is OnMusicStop
                                        ? FluentIcons.play_24_filled
                                        : FluentIcons.play_24_filled)),
                        IconButton(onPressed: (){}, icon: Icon(FluentIcons.next_24_filled)),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
