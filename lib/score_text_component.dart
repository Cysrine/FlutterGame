import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

import 'my_game.dart';

class ScoreTextComponent extends TextComponent with HasGameRef<MyGame> {
  int score = 0;

  ScoreTextComponent()
      : super(
          text: '0',
          textRenderer: TextPaint(style: const TextStyle(fontSize: 24, color: Colors.white)),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Position near top-left
    position = Vector2(10, 10);
  }

  void increment(int points) {
    score += points;
    text = score.toString();
  }
}
