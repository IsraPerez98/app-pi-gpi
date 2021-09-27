import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecordTile extends StatefulWidget {
  // RecordTile({Key key}) : super(key: key);

  @override
  _RecordTileState createState() => _RecordTileState();
}

class _RecordTileState extends State<RecordTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        height: 95,
        color: Colors.red,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text('a'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Frase'),
                  Text('fonemas', style: TextStyle()),
                  Chip(
                      padding: EdgeInsets.all(0),
                      label: Text(
                        'Pendiente',
                        style: TextStyle(fontSize: 14),
                      ))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              alignment: Alignment.centerRight,
              child: Icon(Icons.mic),
            )
          ],
        ),
      ),
    );
  }
}
