import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:micu/themes/theme.dart';

class RecordBar extends StatefulWidget {
  @override
  _RecordBarState createState() => _RecordBarState();
}

class _RecordBarState extends State<RecordBar> {
  late bool _onRecording;
  late IconData _icon;

  @override
  void initState() {
    super.initState();
    _onRecording = false;
    _icon = Icons.mic_rounded;
  }

  _changeRecordingState() {
    _onRecording = !_onRecording;
    _icon = _onRecording ? Icons.mic_off_rounded : Icons.mic_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Color(0xFF262626),
                  borderRadius: BorderRadius.circular(100)),
            ),
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  color: MainTheme.primaryColor,
                  borderRadius: BorderRadius.circular(100)),
              child: IconButton(
                onPressed: () => {
                  setState(() => {_changeRecordingState()})
                },
                icon: Icon(_icon),
              ),
            ),
            _onRecording
                ? Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              height: 12,
                              width: 12,
                              margin: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: MainTheme.accentColor,
                                  borderRadius: BorderRadius.circular(12))),
                          Text('00:01')
                        ],
                      ),
                    ),
                  )
                : Container()
          ],
        ));
  }
}
