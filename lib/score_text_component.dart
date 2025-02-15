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

class LifeComponent extends PositionComponent with HasGameRef<MyGame> {
  int life = 5;
  final double space = 30;
  late SpriteComponent heartComponent;
  final List<SpriteComponent> hearts = [];

  LifeComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    for(int i = 0; i < life; i++) {
      heartComponent = SpriteComponent();
      heartComponent.sprite = await gameRef.loadSprite('heart.png');
      heartComponent.size = Vector2(45, 45);
      heartComponent.position = Vector2(30 + (i*space), 40);
      add(heartComponent);
      hearts.add(heartComponent);
    }
  }
  void byeByeHeart() {
    if (life >= 0) {
      life -= 1;
      remove(hearts[life]);
    }
  }
}
