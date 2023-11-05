import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/music_list/presentation/bloc/music/music_bloc.dart';
import 'package:music_player/features/music_list/presentation/bloc/music_player/music_player_bloc.dart';
import 'package:music_player/features/music_list/presentation/dto/music_dto.dart';
import 'package:music_player/features/music_list/presentation/pages/music_controller/music_controller_page.dart';
import 'package:music_player/utils/style/colors.dart';
import 'package:just_audio/just_audio.dart';

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
                  // TODO: implement listener
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
                                    image: state.data?.results?[index].image,
                                    title:
                                        state.data?.results?[index].trackName,
                                    singer:
                                        state.data?.results?[index].artistName,
                                    musicUrl:
                                        state.data?.results?[index].previewUrl),
                              if (state.data?.results?[index].previewUrl !=
                              null&&index !=
                                  (state.data?.results?.length ?? 0) - 1)
                                Divider(
                                  thickness: 2,
                                  color: dividerColor,
                                )
                            ],
                          );
                        })),
                      ),
                    );
                  }
                  if(state is OnLoadingGetMusic){
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
                     Center(child: Text("Silahkan Cari Musik Yang anda suka"),),
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
        debounce = Timer(Duration(seconds: 1), () {
          if (value.isNotEmpty && value.length > 5) {
            context!.read<MusicBloc>().add(OnMusicSearched(term: value));
          }
        });
      },
    );
  }

  Widget _buildMusicList(
      {required MusicPlayerBloc bloc,
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
                        title ?? "",
                        style: TextStyle(
                            fontFamily: 'gilroy',
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(FluentIcons.music_note_1_20_regular),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              singer ?? "-",
                              style: TextStyle(
                                  fontFamily: 'gilroy',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                IconButton(
                    key: key,
                    onPressed:
                        (state is OnMusicPlayed || state is OnMusicResumed) &&
                                bloc.currentSongIndex == index
                            ? () async {
                                bloc.add(OnPauseMusic());
                              }
                            : state is OnMusicPaused &&
                                    bloc.currentSongIndex == index
                                ? () {
                                    bloc.add(OnResumeMusic());
                                  }
                                : () {
                                    print(musicUrl);
                                    print("key: ${bloc.currentSongIndex}");
                                    print("index: $index");
                                    bloc.add(OnPlayMusic(
                                        musicUrl: musicUrl ?? "",
                                        index: index));
                                  },
                    icon: Icon(
                        (state is OnMusicPlayed || state is OnMusicResumed) &&
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
