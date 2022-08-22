// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:supperapp/common/enum/message_enum.dart';
import 'package:supperapp/features/chat/widget/video_player_item.dart';

class DisplayTextImageGif extends StatefulWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGif({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  State<DisplayTextImageGif> createState() => _DisplayTextImageGifState();
}

class _DisplayTextImageGifState extends State<DisplayTextImageGif> {
  bool isPlaying = false;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == MessageEnum.text
        ? Text(
            widget.message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : widget.type == MessageEnum.audio
            ? IconButton(
                constraints: const BoxConstraints(minWidth: 100),
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                    setState(() {
                      isPlaying = false;
                    });
                  } else {
                    await audioPlayer.play(UrlSource(widget.message));
                    setState(() {
                      isPlaying = true;
                    });
                  }
                },
                icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle))
            : widget.type == MessageEnum.video
                ? VideoPlayerItem(videoUrl: widget.message)
                : widget.type == MessageEnum.gif
                    ? CachedNetworkImage(
                        imageUrl: widget.message,
                      )
                    : CachedNetworkImage(
                        imageUrl: widget.message,
                      );
  }
}
