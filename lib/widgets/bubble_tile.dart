import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:micu/models/audio_message.dart';
import 'package:micu/themes/theme.dart';
import 'package:micu/utils/audio_manager.dart';

class BubbleTile extends StatefulWidget {
  final own; // Booleano que determinará si el mensaje lo escribió el usuario (true) o es la respuesta con la traducción (false).
  final AudioMessage audioMessage;

  BubbleTile({Key? key, required this.own, required this.audioMessage})
      : super(key: key);

  @override
  _BubbleTileState createState() => _BubbleTileState();
}

class _BubbleTileState extends State<BubbleTile> {
  late Color _bubbleColor;
  late Color _bubbleTextColor = Colors.black54;
  late BubbleNip _bubbleNip;
  late AudioManager _audioManager;

  @override
  void initState() {
    super.initState();
    if (widget.own) {
      _bubbleColor = MainTheme.primaryColor;
      _bubbleNip = BubbleNip.rightTop;
    } else {
      _bubbleColor = MainTheme.accentColor;
      _bubbleNip = BubbleNip.leftTop;
    }
    _audioManager = AudioManager(
        'https://file-examples-com.github.io/uploads/2017/11/file_example_OOG_1MG.ogg'); // Esta url es de prueba. Deberá reemplazarse por el archivo respectivo.
  }

  @override
  void dispose() {
    _audioManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
          height: 95,
          child: Bubble(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      widget.audioMessage.message,
                      style: TextStyle(color: _bubbleTextColor, fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ValueListenableBuilder<ButtonState>(
                        valueListenable: _audioManager.buttonNotifier,
                        builder: (_, value, __) {
                          switch (value) {
                            case ButtonState.loading:
                              return Container(
                                margin: EdgeInsets.all(5),
                                width: 32.0,
                                height: 32.0,
                                child: SpinKitWave(
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                              );
                            case ButtonState.paused:
                              return IconButton(
                                icon: Icon(Icons.play_arrow),
                                iconSize: 32.0,
                                onPressed: _audioManager.play,
                              );
                            case ButtonState.playing:
                              return IconButton(
                                icon: Icon(Icons.pause),
                                iconSize: 32.0,
                                onPressed: _audioManager.pause,
                              );
                          }
                        },
                      ),
                      Expanded(
                        child: ValueListenableBuilder<ProgressBarState>(
                          valueListenable: _audioManager.progressNotifier,
                          builder: (_, value, __) {
                            return ProgressBar(
                              progressBarColor: Colors.white,
                              baseBarColor: Colors.black12,
                              bufferedBarColor: Colors.white38,
                              thumbColor: Colors.white,
                              progress: value.current,
                              buffered: value.buffered,
                              total: value.total,
                              onSeek: _audioManager.seek,
                            );
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
              color: _bubbleColor,
              nip: _bubbleNip)),
    );
  }
}
