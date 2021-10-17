import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:micu/models/audio_message.dart';
import 'package:micu/widgets/bubble_tile.dart';
import 'package:micu/widgets/record_bar.dart';


class MemberScreen extends StatefulWidget {
  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Aplicación realizada por grupo de Desarrolladores'),
            ),
      ),
    );
  }

}