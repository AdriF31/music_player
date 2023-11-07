import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "music player",
      //     style: TextStyle(
      //         fontFamily: 'gilroy', fontSize: 24, fontWeight: FontWeight.bold),
      //   ),
      // ),
      floatingActionButton:BlocBuilder<MusicBloc, MusicState>(
        builder: (context, state) {
          if (state is OnSuccessGetMusic) {
            return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
              bloc: bloc,
              builder: (context, s) {
                if (s is OnMusicPlayed) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MusicControllerPage(
                                bloc: bloc,
                                music: state.data,
                                dto: MusicDTO(
                                    index: bloc.currentSongIndex,
                                    title: state
                                        .data
                                        ?.results?[s.currentSongIndex ?? 0
                                    ]
                                        .trackName,
                                    image: state
                                        .data
                                        ?.results?[s.currentSongIndex ?? 0
                                    ]
                                        .image,
                                    artist: state
                                        .data
                                        ?.results?[s.currentSongIndex ?? 0
                                    ].artistName,
                                    musicUrl: state
                                        .data
                                        ?.results?[s.currentSongIndex ?? 0
                                    ]
                                        .previewUrl),
                              )));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          boxShadow: [BoxShadow(
                              color: greyColor
                          )]
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: state
                                  .data
                                  ?.results?[s.currentSongIndex ?? 0
                              ]
                                  .image ??
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
                                      Text(state
                                          .data
                                          ?.results?[s.currentSongIndex!]
                                          .trackName ??
                                          "", style: const TextStyle(
                                          fontFamily: 'gilroy',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,),
                                      Text(state
                                          .data
                                          ?.results?[s.currentSongIndex!]
                                          .artistName ??
                                          "", style: const TextStyle(
                                          fontFamily: 'gilroy',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,)
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            bloc.add(OnPreviousMusic());
                                          },
                                          icon: Icon(FluentIcons.previous_24_filled)),
                                      IconButton(
                                          onPressed: () {
                                            s.isPlaying!?bloc.add(OnPauseMusic()):
                                            bloc.add(OnResumeMusic());
                                          },
                                          icon: Icon((s.isPlaying!)
                                              ? FluentIcons.pause_24_filled
                                              : s is OnMusicStop
                                              ? FluentIcons.play_24_filled
                                              : FluentIcons.play_24_filled)),
                                      IconButton(
                                          onPressed: () {
                                            bloc.add(OnNextMusic());
                                          },
                                          icon: Icon(FluentIcons.next_24_filled)),
                                    ],
                                  ),
                                )

                              ],
                            ),
                          ),

                          // IconButton(onPressed: (){}, icon: Icon(FluentIcons.next_24_filled)),
                        ],
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            );
          }
          return SizedBox();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSearchField(
                  controller: controller,
                  debounce: _debounce,
                  context: context),
              const SizedBox(
                height: 24,
              ),
              BlocConsumer<MusicBloc, MusicState>(
                listener: (context, state) {
                  if (state is OnSuccessGetMusic) {
                    bloc.add(OnLoadMusic(musicList: state.musicList));
                  }
                },
                builder: (context, state) {
                  if (state is OnSuccessGetMusic) {
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                            children: List.generate(
                                state.data?.results?.length ?? 0, (index) {
                          return Column(
                            children: [
                              if (state.data?.results?[index].previewUrl !=
                                  null)
                                _buildMusicList(
                                    index: index,
                                    bloc: bloc,
                                    music: state.data,
                                    image:
                                        state.data?.results?[index].image,
                                    title: state
                                        .data?.results?[index].trackName,
                                    singer: state
                                        .data?.results?[index].artistName,
                                    musicUrl: state
                                        .data?.results?[index].previewUrl),
                              if (state.data?.results?[index].previewUrl !=
                                      null &&
                                  index !=
                                      (state.data?.results?.length ?? 0) -
                                          1)
                                const Divider(
                                  thickness: 2,
                                  color: dividerColor,
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
        ),
      ),
    );
  }

  Widget _buildSearchField(
      {TextEditingController? controller,
      Timer? debounce,
      BuildContext? context}) {
    return TextField(
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
    );
  }

  Widget _buildMusicList(
      {required MusicPlayerBloc bloc,
        MusicEntity? music,
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
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 8),
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
                IconButton(
                    key: key,
                    onPressed: (state is OnMusicPlayed&&state.isPlaying!) &&
                            bloc.currentSongIndex == index
                        ? () async {
                            bloc.add(OnPauseMusic());
                          }
                        : state is OnMusicPlayed&&state.isPlaying==false&&
                                bloc.currentSongIndex == index
                            ? () {
                                bloc.add(OnResumeMusic());
                              }
                            : () {
                                print(musicUrl);
                                print("key: ${bloc.currentSongIndex}");
                                print("index: $index");
                                bloc.add(OnPlayMusic(
                                    musicUrl: musicUrl ?? "", index: index));
                              },
                    icon: Icon((state is OnMusicPlayed&&state.isPlaying!) &&
                            bloc.currentSongIndex == index
                        ? FluentIcons.pause_24_filled
                        : state is OnMusicStop
                            ? FluentIcons.play_24_filled
                            : FluentIcons.play_24_filled))
              ],
            ),
          ),
        );
      },
    );
  }
}
