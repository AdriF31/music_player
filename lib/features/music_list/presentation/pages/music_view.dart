import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/music_list/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/music_list/presentation/pages/music_controller_page.dart';
import 'package:music_player/utils/style/colors.dart';
import 'package:just_audio/just_audio.dart';

class MusicView extends StatelessWidget {
  const MusicView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    AudioPlayer player = AudioPlayer();
    Timer? _debounce;
    MusicPlayerBloc bloc=MusicPlayerBloc();
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
              _buildSearchField(controller: controller, debounce: _debounce),
              SizedBox(
                height: 24,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                      children: List.generate(
                          10,
                          (index) => Column(
                                children: [
                                  _buildMusicList(player: player,bloc: bloc),
                                  if (index != 9)
                                    Divider(
                                      thickness: 2,
                                      color: dividerColor,
                                    )
                                ],
                              ))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(
      {TextEditingController? controller, Timer? debounce}) {
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
            print(value);
          }
        });
      },
    );
  }

  Widget _buildMusicList({required AudioPlayer player,required MusicPlayerBloc bloc}) {
    return BlocConsumer<MusicPlayerBloc, MusicPlayerState>(
      bloc: bloc,
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MusicControllerPage(bloc: bloc,)));
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://static.wikia.nocookie.net/blinks/images/0/07/The_Album_Version_4_Album_Cover.png/revision/latest?cb=20200903175351",
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Playing With Fire",
                          style: TextStyle(
                              fontFamily: 'gilroy',
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
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
                            Text(
                              "Blackpink",
                              style: TextStyle(
                                  fontFamily: 'gilroy',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                IconButton(
                    onPressed: state is OnMusicPlayed||state is OnMusicResumed
                        ? () async {
                            bloc.add(OnPauseMusic());
                          }
                        : state is OnMusicPaused
                            ? () {
                                bloc
                                    .add(OnResumeMusic());
                              }
                            : () {
                     bloc
                          .add(OnPlayMusic());
                    },
                    icon: Icon(state is OnMusicPlayed||state is OnMusicResumed
                        ? FluentIcons.pause_24_filled
                        : state is OnMusicStop?FluentIcons.play_24_filled:FluentIcons.play_24_filled))
              ],
            ),
          ),
        );
      },
    );
  }
}
