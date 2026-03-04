import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class CustomYoutubePlayer extends StatefulWidget {
  const CustomYoutubePlayer({super.key, required this.videoUrl});
  final String videoUrl;

  @override
  State<CustomYoutubePlayer> createState() => _CustomYoutubePlayerState();
}

class _CustomYoutubePlayerState extends State<CustomYoutubePlayer> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    final videoId =
    YoutubePlayerController.convertUrlToId(widget.videoUrl);

    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
      ),
    )..loadVideoById(videoId: videoId!);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: YoutubePlayer(
        controller: _controller,
      ),
    );
  }
}