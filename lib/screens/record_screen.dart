import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http_parser/http_parser.dart';

class RecordScreen extends StatefulWidget {
  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final String _path = 'flutter_sound_example.aac';

  TextEditingController _controller = TextEditingController();

  FlutterSoundPlayer? _player = FlutterSoundPlayer();
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();

  String? _response;
  String? _code;

  bool _playerIsInited = false;
  bool _recorderIsInited = false;
  bool _playbackReady = false;

  @override
  void initState() {
    super.initState();

    _player!.openAudioSession().then((value) {
      setState(() {
        _playerIsInited = true;
      });
    });

    _openTheRecorder().then((value) {
      setState(() {
        _recorderIsInited = true;
      });
    });
  }

  @override
  void dispose() {
    _player!.closeAudioSession();
    _player = null;

    _recorder!.closeAudioSession();
    _recorder = null;
    super.dispose();
  }

  Future<void> _save(List<int> data, int sampleRate) async {
    File recordedFile = File("/storage/emulated/0/recordedFile.wav");

    var channels = 1;

    int byteRate = ((16 * sampleRate * channels) / 8).round();

    var size = data.length;

    var fileSize = size + 36;

    Uint8List header = Uint8List.fromList([
      // "RIFF"
      82, 73, 70, 70,
      fileSize & 0xff,
      (fileSize >> 8) & 0xff,
      (fileSize >> 16) & 0xff,
      (fileSize >> 24) & 0xff,
      // WAVE
      87, 65, 86, 69,
      // fmt
      102, 109, 116, 32,
      // fmt chunk size 16
      16, 0, 0, 0,
      // Type of format
      1, 0,
      // One channel
      channels, 0,
      // Sample rate
      sampleRate & 0xff,
      (sampleRate >> 8) & 0xff,
      (sampleRate >> 16) & 0xff,
      (sampleRate >> 24) & 0xff,
      // Byte rate
      byteRate & 0xff,
      (byteRate >> 8) & 0xff,
      (byteRate >> 16) & 0xff,
      (byteRate >> 24) & 0xff,
      // Uhm
      ((16 * channels) / 8).round(), 0,
      // bitsize
      16, 0,
      // "data"
      100, 97, 116, 97,
      size & 0xff,
      (size >> 8) & 0xff,
      (size >> 16) & 0xff,
      (size >> 24) & 0xff,
      ...data
    ]);
    //return recordedFile.writeAsBytesSync(header, flush: true);
    return;
  }

  _sendAudio(String _url) async {
    try {
      var dioInstance = dio.Dio();

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      dio.FormData formData = dio.FormData.fromMap({
        "audio":
            await dio.MultipartFile.fromFile("$tempPath/$_path", filename: _path, contentType: MediaType("audio", "aac")),
      });

      final response = await dioInstance.post(_url, data: formData);
      _response = response.data.toString();
      _code = response.statusCode.toString();
    } on DioError catch (e) {
      _response = e.response?.data.toString();
      _code = e.response?.statusCode.toString();
    } catch (e) {
      _response = e.toString();
      _code = "ERROR";
    } finally {
      setState(() {});
    }
  }

  Future<void> _openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Debe conceder acceso al micrófono');
      }
    }
    await _recorder!.openAudioSession();
    _recorderIsInited = true;
  }

  void _record() {
    _recorder!
        .startRecorder(
      toFile: _path,
      codec: Codec.defaultCodec,
    )
        .then((value) {
      setState(() {});
    });
  }

  void _stopRecorder() async {
    await _recorder!.stopRecorder().then((value) {
      setState(() {
        //var url = value;
        _playbackReady = true;
      });
    });
  }

  void _play() {
    assert(_playerIsInited &&
        _playbackReady &&
        _recorder!.isStopped &&
        _player!.isStopped);
    _player!
        .startPlayer(
            fromURI: _path,
            codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  void _stopPlayer() {
    _player!.stopPlayer().then((value) {
      setState(() {});
    });
  }

  _getRecordFn() {
    if (!_recorderIsInited || !_player!.isStopped) {
      return null;
    }
    return _recorder!.isStopped ? _record : _stopRecorder;
  }

  _getPlaybackFn() {
    if (!_playerIsInited || !_playbackReady || !_recorder!.isStopped) {
      return null;
    }
    return _player!.isStopped ? _play : _stopPlayer;
  }

  bool get _isValid {
    return _playbackReady && _controller.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 40),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Get.theme.accentColor,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: _getRecordFn(),
                      child: Icon(
                        _recorder!.isRecording ? Icons.pause : Icons.mic,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                Container(height: 20),
                if (_playbackReady)
                  ListTile(
                    title: Text("Ultima grabación"),
                    subtitle: Text(_path),
                    leading: IconButton(
                      onPressed: _getPlaybackFn(),
                      icon: Icon(
                        _player!.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                  ),
                Container(height: 40),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.url,
                    onChanged: (text) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Puede ser la IP local",
                      labelText: "Ruta de la API",
                    ),
                  ),
                ),
                Container(height: 20),
                if (_playbackReady)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextButton(
                      child: Text("Enviar POST"),
                      onPressed: _isValid ? () {
                        _sendAudio(_controller.text);
                      } : null,
                    ),
                  ),
                Container(height: 40),
                if (_code != null && _code!.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: Text("Respuesta $_code"),
                  ),
                if (_response != null && _response!.isNotEmpty)
                  Markdown(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    selectable: true,
                    data: "```json\n$_response\n```",
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
