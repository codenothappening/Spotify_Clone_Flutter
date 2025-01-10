import 'package:flutter/material.dart';

class Music {
  Duration? duration;
  String? artistName;
  String? songName;
  String? artistImage;
  String? songImage;
  Color? songColor;
  String? musicTrackId;
  Color? textColor;

  Music({
    this.duration,
    this.artistName,
    this.songName,
    this.artistImage,
    this.songImage,
    this.songColor,
    this.musicTrackId,
    this.textColor = Colors.white,
  });
}
