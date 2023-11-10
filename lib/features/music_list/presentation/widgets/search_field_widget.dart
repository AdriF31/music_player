import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/music_list/presentation/bloc/music/music_bloc.dart';
import 'package:music_player/utils/style/colors.dart';

class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({super.key,required this.controller,required this.ctx});
  final TextEditingController? controller;
  final BuildContext? ctx;



  @override
  Widget build(BuildContext context) {
    Timer? debounce;
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
              ctx!.read<MusicBloc>().add(OnMusicSearched(term: value));
            }
          });
        },
      ),
    );
  }
}
