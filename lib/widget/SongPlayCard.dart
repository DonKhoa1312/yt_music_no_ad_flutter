import 'package:flutter/material.dart';
import 'package:music_app/model/Songmodel.dart';
import 'package:music_app/ultil/Size.dart';

class SongPlayCard extends StatelessWidget {
  const SongPlayCard(
      {super.key, required this.songmodel, required this.playing});
  final Songmodel songmodel;
  final bool playing;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: gwidth(context, 1),
      color: Colors.teal,
    );
  }
}
