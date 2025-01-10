import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify_clone/constants/colors.dart';

import 'package:spotify_clone/data/models/music/music.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MusicPlayer extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  MusicPlayer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final player = AudioPlayer();
  Music music = Music();
  bool _isLoading = true;
  YoutubeExplode yt = YoutubeExplode();

  @override
  void initState() {
    super.initState();
    music = Music(
      songName: widget.title,
      artistName: widget.subtitle,
      songImage: widget.imageUrl,
    );
    _initializePlayer();
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    yt.close();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    try {
      final color = await getImagePalette(NetworkImage(widget.imageUrl));
      if (color != null) {
        setState(() {
          music.songColor = color as Color?; // Update the background color
          music.textColor = getContrastingColor(color);
        });
      }
      final searchQuery = '${music.songName} ${music.artistName}';
      List<Video> searchResult = await yt.search.search(searchQuery);

      final filteredResults = searchResult
          .where(
            (video) => video.title.toLowerCase().contains('lyric'),
          )
          .toList();

      if (filteredResults.isEmpty) {
        final fallbackQuery = '${music.songName} ${music.artistName}';
        searchResult = await yt.search.search(fallbackQuery);
      }

      if (searchResult.isNotEmpty) {
        final video = searchResult.first;
        final manifest =
            await yt.videos.streamsClient.getManifest(video.id.value);

        music.duration = video.duration;
        final audioStream = manifest.audioOnly.first;

        // Set audio source and start Playback
        await player.setSource(UrlSource(audioStream.url.toString()));

        player.play(UrlSource(audioStream.url.toString()));

        setState(() {
          music.duration = video.duration ?? const Duration(minutes: 4);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error initializing music player: $e');
    }
  }

  Future<Color?> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);

    return paletteGenerator.dominantColor?.color;
  }

  Color getContrastingColor(Color color) {
    final brightness =
        (color.red * 0.299 + color.green * 0.587 + color.blue * 0.114) / 255;
    return brightness > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: music.songColor ?? Colors.black,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    CustomColors.primaryColor,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    _buildHeader(context, textTheme),
                    const SizedBox(height: 60),
                    _buildArtwork(),
                    const SizedBox(height: 80),
                    _buildSongInfo(textTheme),
                    const SizedBox(height: 80),
                    _buildProgressBar(),
                    const SizedBox(height: 20),
                    _buildPlaybackControls(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.close, color: Colors.transparent),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Now Playing',
              style: textTheme.bodyMedium?.copyWith(
                color: music.textColor ?? CustomColors.primaryColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.subtitle,
              style: textTheme.bodyLarge
                  ?.copyWith(color: music.textColor ?? Colors.white),
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: music.textColor ?? Colors.white),
        ),
      ],
    );
  }

  Widget _buildArtwork() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          music.songImage ?? "",
          height: 300,
          width: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSongInfo(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoScrollText(
              music.songName ?? "",
              style: textTheme.titleLarge?.copyWith(
                color: music.textColor ?? Colors.white,
              ),
              scrollDirection: Axis.horizontal,
            ),
            Text(
              music.artistName ?? "",
              style: textTheme.titleMedium?.copyWith(
                color: music.textColor?.withOpacity(0.6) ?? Colors.white60,
              ),
            ),
          ],
        ),
        const Icon(
          Icons.favorite,
          color: CustomColors.primaryColor,
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return StreamBuilder(
      stream: player.onPositionChanged,
      builder: (context, data) {
        return ProgressBar(
          progress: data.data ?? const Duration(seconds: 0),
          total: music.duration ?? const Duration(minutes: 4),
          bufferedBarColor:
              music.textColor?.withOpacity(0.38) ?? Colors.white38,
          baseBarColor: music.textColor?.withOpacity(0.1) ?? Colors.white10,
          thumbColor: music.textColor ?? Colors.white,
          progressBarColor: CustomColors.primaryColor,
          timeLabelTextStyle: const TextStyle(color: Colors.white),
          onSeek: (duration) {
            player.seek(duration);
          },
        );
      },
    );
  }

  Widget _buildPlaybackControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.lyrics_outlined,
            color: music.textColor ?? Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.skip_previous,
            color: music.textColor ?? Colors.white,
            size: 36,
          ),
        ),
        IconButton(
          onPressed: () async {
            if (player.state == PlayerState.playing) {
              await player.pause();
            } else {
              await player.resume();
            }
            setState(() {});
          },
          icon: Icon(
            player.state == PlayerState.playing
                ? Icons.pause
                : Icons.play_arrow,
            color: music.textColor ?? Colors.white,
            size: 60,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.skip_next,
            color: music.textColor ?? Colors.white,
            size: 36,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.loop,
            color: music.textColor ?? CustomColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
