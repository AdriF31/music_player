import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/music_list/domain/entities/music_entity.dart';
import 'package:music_player/features/music_list/presentation/bloc/music_player/music_player_bloc.dart';
import 'package:music_player/features/music_list/presentation/dto/music_dto.dart';

class MusicControllerView extends StatefulWidget {
  const MusicControllerView(
      {super.key, required this.bloc, this.dto, this.music});

  final MusicPlayerBloc bloc;
  final List<ResultEntity>? music;
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
          currentMusic:widget.music?[widget.dto?.index??0], index: widget.dto?.index));
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
        centerTitle: true,
        title: const Text("Now Playing"),
      ),
      body: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        bloc: widget.bloc,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: CachedNetworkImage(
                      imageUrl: widget
                              .music
                              ?[widget.bloc.currentSongIndex ?? 0]
                              .image ??
                          "https://",
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        Text(
                          widget.music?[widget.bloc.currentSongIndex ?? 0]
                              .trackName ??
                              "",
                          style: const TextStyle(
                              fontFamily: 'gilroy',
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.music?[widget.bloc.currentSongIndex ?? 0]
                              .artistName ??
                              "",
                          style: const TextStyle(
                              fontFamily: 'gilroy',
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
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
                                              (position ?? const Duration(seconds: 0))
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
                                                      const Duration(seconds: 0))) ==
                                                      0
                                                      ? "-"
                                                      : formatDuration((widget
                                                      .bloc.player.duration ??
                                                      const Duration(seconds: 0))))
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
                                          widget.bloc.currentSongIndex == 0
                                              ? widget.bloc.add(OnPreviousMusic(
                                              currentMusic: widget.music?[
                                              widget.bloc.currentSongIndex!]))
                                              : widget.bloc.add(OnPreviousMusic(
                                              currentMusic: widget.music?[
                                              widget.bloc.currentSongIndex! -
                                                  1]));
                                          },
                                        icon: const Icon(FluentIcons.previous_24_filled)),
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
                                              currentMusic: widget.music?[widget.bloc
                                                  .currentSongIndex ??
                                                  0],
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
                                        onPressed:widget.bloc.currentSongIndex !=
                                            (widget.music?.length ?? 0) - 1
                                            ?  () {
                                          widget.bloc.add(OnNextMusic(currentMusic: widget.music?[widget.bloc.currentSongIndex!+1]));
                                        }:(){},
                                        icon: Icon(FluentIcons.next_24_filled,color: widget.bloc.currentSongIndex !=
                                            (widget.music?.length ?? 0) - 1
                                            ?IconTheme.of(context).color
                                            : IconTheme.of(context)
                                            .color
                                            ?.withOpacity(0.5),)),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
