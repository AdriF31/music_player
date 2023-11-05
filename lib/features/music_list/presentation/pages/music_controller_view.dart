import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    double _sliderValue = 0;
    bool? isSliderChange=false;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Playing With Fire"),
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
                             Duration? position = snapshot.data;
                             _sliderValue = position!.inSeconds.toDouble();
                             print(_sliderValue);
                             return Slider(
                               value: _sliderValue,
                               // divisions: widget.bloc.player.duration!.inSeconds,
                               onChanged: (value) {
                                 isSliderChange=true;
                                 position = Duration(seconds: value.toInt());
                                 widget.bloc.add(OnPauseMusic());
                               },
                               onChangeEnd: (value){
                                 position = Duration(seconds: value.toInt());
                                 widget.bloc.player.seek(position);
                                 widget.bloc.add(OnResumeMusic());

                               },
                               min: 0,
                               max: widget.bloc.player.duration!.inSeconds
                                   .toDouble(),
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
