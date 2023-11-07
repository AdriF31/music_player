import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:music_player/features/music_list/domain/entities/music_entity.dart';
import 'package:music_player/features/music_list/presentation/bloc/music_player/music_player_bloc.dart';
import 'package:music_player/features/music_list/presentation/dto/music_dto.dart';
import 'package:music_player/utils/style/colors.dart';

class MusicControllerView extends StatefulWidget {
  const MusicControllerView(
      {super.key, required this.bloc, this.dto, this.music});

  final MusicPlayerBloc bloc;
  final MusicEntity? music;
  final MusicDTO? dto;

  @override
  State<MusicControllerView> createState() => _MusicControllerViewState();
}

class _MusicControllerViewState extends State<MusicControllerView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  double _sliderValue = 0;
  bool? isSliderChange = false;
  Duration? position;

  // String formattedDuration = formatDuration(duration);

  @override
  void initState() {
    if (widget.bloc.currentSongIndex != widget.dto?.index) {
      widget.bloc.add(OnPlayMusic(
          musicUrl: widget.dto?.musicUrl, index: widget.dto?.index));
    }
    super.initState();
  }

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
      body: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        bloc: widget.bloc,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CachedNetworkImage(
                    imageUrl: widget
                            .music
                            ?.results?[widget.bloc.currentSongIndex ?? 0]
                            .image ??
                        "https://",
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  widget.music?.results?[widget.bloc.currentSongIndex ?? 0]
                          .trackName ??
                      "",
                  style: TextStyle(
                      fontFamily: 'gilroy',
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  widget.music?.results?[widget.bloc.currentSongIndex ?? 0]
                          .artistName ??
                      "",
                  style: TextStyle(
                      fontFamily: 'gilroy',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
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
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                if (snapshot.hasData) {
                                  print("has data : ${snapshot.data}");
                                  position = snapshot.data;
                                  _sliderValue =
                                      (position ?? Duration(seconds: 0))
                                          .inSeconds
                                          .toDouble();
                                  print(_sliderValue);
                                  return Column(
                                    children: [
                                      Slider(
                                        value: _sliderValue,
                                        onChanged: (value) {
                                          isSliderChange = true;
                                          position =
                                              Duration(seconds: value.toInt());
                                          widget.bloc.add(OnPauseMusic());
                                        },
                                        onChangeEnd: (value) {
                                          position =
                                              Duration(seconds: value.toInt());
                                          // widget.bloc.player.seek(position);
                                          widget.bloc
                                              .add(OnSlideMusic(position));
                                        },
                                        min: 0,
                                        max: (widget.bloc.player.duration ??
                                                const Duration(seconds: 0))
                                            .inSeconds
                                            .toDouble(),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(formatDuration(position ??
                                              const Duration(seconds: 0))),
                                          Text(formatDuration((widget.bloc
                                                          .player.duration ??
                                                      Duration(seconds: 0))) ==
                                                  0
                                              ? "-"
                                              : formatDuration((widget
                                                      .bloc.player.duration ??
                                                  Duration(seconds: 0))))
                                        ],
                                      )
                                    ],
                                  );
                                } else {
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {
                                  widget.bloc.add(OnPreviousMusic());
                                },
                                icon: Icon(FluentIcons.previous_24_filled)),
                            IconButton(
                                onPressed: state is OnMusicPlayed &&
                                        state.isPlaying!
                                    ? () async {
                                        widget.bloc.add(OnPauseMusic());
                                      }
                                    : state is OnMusicPlayed &&
                                            state.isPlaying == false
                                        ? () {
                                            widget.bloc.add(OnResumeMusic());
                                          }
                                        : () {
                                            widget.bloc.add(OnPlayMusic(
                                                musicUrl: widget
                                                    .music
                                                    ?.results?[widget.bloc
                                                            .currentSongIndex ??
                                                        0]
                                                    .previewUrl,
                                                index: widget
                                                    .bloc.currentSongIndex));
                                          },
                                icon: Icon(
                                    (state is OnMusicPlayed && state.isPlaying!)
                                        ? FluentIcons.pause_24_filled
                                        : state is OnMusicStop
                                            ? FluentIcons.play_24_filled
                                            : FluentIcons.play_24_filled)),
                            IconButton(
                                onPressed: () {
                                  widget.bloc.add(OnNextMusic());
                                },
                                icon: Icon(FluentIcons.next_24_filled)),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
