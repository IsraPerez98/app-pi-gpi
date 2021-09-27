import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:micu/models/audio_message.dart';
import 'package:micu/widgets/bubble_tile.dart';
import 'package:micu/widgets/record_bar.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AudioMessage _audioMessage = AudioMessage
      .empty(); // Este es el modelo AudioMessage que se debiera recibir del backend
  int _itemCount = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          ListView.builder(
              reverse: true,
              padding: EdgeInsets.only(bottom: 100),
              itemCount: _itemCount,
              itemBuilder: (context, index) {
                return BubbleTile(
                    own: (index % 2 == 0), audioMessage: _audioMessage);
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: RecordBar(),
          ),
        ],
      ),
    ));
  }
}
