import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  final playerX;
  final playerWidth;

  MyPlayer({this.playerX });


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(playerX, 0.9),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 10,
          width: MediaQuery.of(context).size.width * playerWidth / 2,
          color: const Color.fromARGB(255, 6, 27, 182)
        ),
      ),
    );
  }
}