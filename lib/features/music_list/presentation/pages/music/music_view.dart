import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:music_player/features/music_list/domain/entities/music_entity.dart';
import 'package:music_player/features/music_list/presentation/bloc/music/music_bloc.dart';
import 'package:music_player/features/music_list/presentation/bloc/music_player/music_player_bloc.dart';
import 'package:music_player/features/music_list/presentation/dto/music_dto.dart';
import 'package:music_player/features/music_list/presentation/pages/music_controller/music_controller_page.dart';
import 'package:music_player/utils/style/colors.dart';

class MusicView extends StatelessWidget {
  const MusicView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    Timer? _debounce;
    MusicPlayerBloc bloc = MusicPlayerBloc();
    Duration? position;
    double _sliderValue;
    List<ResultEntity>? music = [];
    return Scaffold(
      floatingActionButton: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        bloc: bloc,
        builder: (context, s) {
          print("bangsat" + s.toString());
          if (s is OnMusicPlayed) {
            return SafeArea(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MusicControllerPage(
                                bloc: bloc,
                                music: music,
                                dto: MusicDTO(
                                    index: bloc.currentSongIndex,
                                    title: music[s.currentSongIndex ?? 0]
                                        .trackName,
                                    image: music[s.currentSongIndex ?? 0].image,
                                    artist: music[s.currentSongIndex ?? 0]
                                        .artistName,
                                    musicUrl: music[s.currentSongIndex ?? 0]
                                        .previewUrl),
                              )));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    height: 140,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: greyColor,
                        border: BorderDirectional(
                            top: BorderSide(width: 1, color: greyColor))),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: music[s.currentSongIndex ?? 0].image ??
                                "https://",
                            width: 80,
                            height: 80,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      music[s.currentSongIndex!].trackName ??
                                          "",
                                      style: const TextStyle(
                                          fontFamily: 'gilroy',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      music[s.currentSongIndex!].artistName ??
                                          "",
                                      style: const TextStyle(
                                          fontFamily: 'gilroy',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          bloc.currentSongIndex == 0
                                              ? bloc.add(OnPreviousMusic(
                                                  currentMusic: music[
                                                      bloc.currentSongIndex!]))
                                              : bloc.add(OnPreviousMusic(
                                                  currentMusic: music[
                                                      bloc.currentSongIndex! -
                                                          1]));
                                        },
                                        icon: Icon(
                                            FluentIcons.previous_24_filled)),
                                    IconButton(
                                        onPressed: () {
                                          s.isPlaying!
                                              ? bloc.add(OnPauseMusic())
                                              : bloc.add(OnResumeMusic());
                                        },
                                        icon: Icon((s.isPlaying!)
                                            ? FluentIcons.pause_24_filled
                                            : FluentIcons.play_24_filled)),
                                    IconButton(
                                        onPressed: bloc.currentSongIndex !=
                                                (music.length ?? 0) - 1
                                            ? () {
                                                bloc.add(OnNextMusic(
                                                    currentMusic: music[
                                                        bloc.currentSongIndex! +
                                                            1]));
                                              }
                                            : () {},
                                        icon: Icon(
                                          FluentIcons.next_24_filled,
                                          color: bloc.currentSongIndex !=
                                                  (music.length ?? 0) - 1
                                              ? IconTheme.of(context).color
                                              : IconTheme.of(context)
                                                  .color
                                                  ?.withOpacity(0.5),
                                        )),
                                  ],
                                ),
                              ),
                              StreamBuilder(
                                  stream: bloc.player.positionStream,
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
                                        return Slider(
                                          value: _sliderValue,
                                          onChanged: (value) {
                                            position = Duration(
                                                seconds: value.toInt());
                                            bloc.add(OnPauseMusic());
                                          },
                                          onChangeEnd: (value) {
                                            position = Duration(
                                                seconds: value.toInt());
                                            // widget.bloc.player.seek(position);
                                            bloc.add(OnSlideMusic(position));
                                          },
                                          min: 0,
                                          max: (bloc.player.duration ??
                                                  const Duration(seconds: 0))
                                              .inSeconds
                                              .toDouble(),
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
                            ],
                          ),
                        ),
                        // IconButton(onPressed: (){}, icon: Icon(FluentIcons.next_24_filled)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        children: [
          SafeArea(
            child: _buildSearchField(
                controller: controller, debounce: _debounce, context: context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Icon(FluentIcons.clock_24_filled),
                      SizedBox(
                        height: 8,
                      ),
                      Text("Recent")
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Icon(FluentIcons.music_note_1_24_filled),
                      SizedBox(
                        height: 8,
                      ),
                      Text("Playlist")
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Icon(FluentIcons.heart_24_filled),
                      SizedBox(
                        height: 8,
                      ),
                      Text("Liked Song")
                    ],
                  ),
                ),
              ],
            ),
          ),
          BlocConsumer<MusicBloc, MusicState>(
            listener: (context, state) {
              if (state is OnSuccessGetMusic) {
                music.clear();
                if (bloc.currentMusic != null) {
                  music.add(bloc.currentMusic ?? ResultEntity());
                  music.addAll(state.data?.results ?? []);
                  bloc.add(OnPlaylistChange());
                  bloc.add(OnIndexChanged(index: 0, currentMusic: music[0]));
                  bloc.add(OnLoadMusic(musicList: state.musicList));
                  print("adding ${bloc.currentMusic}");
                } else {
                  bloc.musicList?.clear();
                  music.addAll(state.data?.results ?? []);
                  bloc.add(OnLoadMusic(musicList: state.musicList));
                }
              }
            },
            builder: (context, state) {
              if (state is OnSuccessGetMusic) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                        children: List.generate(music.length ?? 0, (index) {
                      return Column(
                        children: [
                          if (music[index].previewUrl != null)
                            _buildMusicList(
                                index: index,
                                bloc: bloc,
                                music: music,
                                image: music[index].image,
                                title: music[index].trackName,
                                singer: music[index].artistName,
                                musicUrl: music[index].previewUrl),
                          if (music[index].previewUrl != null &&
                              index != (music.length ?? 0) - 1)
                            const Divider(
                              thickness: 1,
                              color: dividerColor,
                            ),
                          if (index == (music.length ?? 0) - 1)
                            SizedBox(
                              height: 150,
                            )
                        ],
                      );
                    })),
                  ),
                );
              }
              if (state is OnLoadingGetMusic) {
                return const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ),
                );
              }
              return const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("Silahkan Cari Musik Yang anda suka"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(
      {TextEditingController? controller,
      Timer? debounce,
      BuildContext? context}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        cursorColor: Colors.white,
        decoration: InputDecoration(
            fillColor: greyColor,
            filled: true,
            hintText: "Search your song...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: greyColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: greyColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: greyColor),
            ),
            suffixIcon: const Icon(
              FluentIcons.search_24_regular,
              color: iconColor,
            )),
        onChanged: (value) {
          if (debounce?.isActive ?? false) debounce?.cancel();
          debounce = Timer(const Duration(seconds: 1), () {
            if (value.isNotEmpty && value.length > 2) {
              context!.read<MusicBloc>().add(OnMusicSearched(term: value));
            }
          });
        },
      ),
    );
  }

  Widget _buildMusicList(
      {required MusicPlayerBloc bloc,
      List<ResultEntity>? music,
      String? image,
      String? title,
      String? singer,
      String? musicUrl,
      int? index}) {
    return BlocConsumer<MusicPlayerBloc, MusicPlayerState>(
      bloc: bloc,
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return InkWell(
          onTap: () {
            if (state is OnMusicPlayed &&
                state.isPlaying! &&
                bloc.currentSongIndex == index) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MusicControllerPage(
                            bloc: bloc,
                            music: music,
                            dto: MusicDTO(
                                index: index,
                                title: title,
                                image: image,
                                artist: singer,
                                musicUrl: musicUrl),
                          )));
            } else {
              bloc.add(
                  OnPlayMusic(index: index, currentMusic: music?[index ?? 0]));
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: image ?? "https://",
                    width: 80,
                    height: 80,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? "-",
                        style: const TextStyle(
                            fontFamily: 'gilroy',
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        singer ?? "-",
                        style: const TextStyle(
                            fontFamily: 'gilroy',
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                if (state is OnMusicPlayed &&
                    state.isPlaying! &&
                    bloc.currentSongIndex == index)
                  LottieBuilder.asset("assets/lottie/music.json")
                // IconButton(
                //     key: key,
                //     onPressed: (state is OnMusicPlayed&&state.isPlaying!) &&
                //             bloc.currentSongIndex == index
                //         ? () async {
                //             bloc.add(OnPauseMusic());
                //           }
                //         : state is OnMusicPlayed&&state.isPlaying==false&&
                //                 bloc.currentSongIndex == index
                //             ? () {
                //                 bloc.add(OnResumeMusic());
                //               }
                //             : () {
                //                 print(musicUrl);
                //                 print("key: ${bloc.currentSongIndex}");
                //                 print("index: $index");
                //                 bloc.add(OnPlayMusic(
                //                     musicUrl: musicUrl ?? "", index: index));
                //               },
                //     icon: Icon((state is OnMusicPlayed&&state.isPlaying!) &&
                //             bloc.currentSongIndex == index
                //         ? FluentIcons.pause_24_filled
                //         : state is OnMusicStop
                //             ? FluentIcons.play_24_filled
                //             : FluentIcons.play_24_filled))
              ],
            ),
          ),
        );
      },
    );
  }
}
