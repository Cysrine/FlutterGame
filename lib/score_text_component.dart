import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flame_audio/flame_audio.dart'; 
import 'my_game.dart';

class ScoreTextComponent extends PositionComponent with HasGameRef<MyGame> {
  int score = 0;
  int highScore = 0;
  late TextComponent scoreText;
  late TextComponent highScoreText;

  ScoreTextComponent();
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Position near top-left
    scoreText = TextComponent(
          text: 'Score: 0',
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 24, 
              color: Colors.white, 
              fontFamily: 'PixelFont')),
              position: Vector2(10, 30));
    add(scoreText);

    highScoreText = TextComponent(
          text: 'High Score: 0',
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 24, 
              color: Colors.white, 
              fontFamily: 'PixelFont')),
              position: Vector2(10, gameRef.size.y - 40));
    add(highScoreText);
  }

  void increment(int points) {
    score += points;
    scoreText.text = "Score: $score";
  }

  void updateHighScore() {
    if (highScore < score) {
        highScore = score;
        highScoreText.text = "High Score: $highScore";
      }
  }
}

class LifeComponent extends PositionComponent with HasGameRef<MyGame> {
  late int life;
  final double space = 30;
  late SpriteComponent heartComponent;
  late TextComponent healthText;
  List<SpriteComponent> hearts = [];
  LifeComponent();


  @override
  Future<void> onLoad() async {
    await super.onLoad();
    resuscitate();
    healthText = TextComponent(
      text: "Health: ",
      textRenderer: TextPaint(style: const TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'PixelFont')),
      position: Vector2(10, 65), // Positioned near hearts
    );
    add(healthText);
    }

  void resuscitate() async {
    hearts = [];
    life = 5;
    for(int i = 0; i < life; i++) {
      heartComponent = (SpriteComponent()
      ..sprite = await gameRef.loadSprite('heart.png')
      ..size = Vector2(45, 45)
      ..position = Vector2(175 + (i*space), 60)
      );
      add(heartComponent);
      hearts.add(heartComponent);
    }
  }

  void byeByeHeart() {
    FlameAudio.play('damagesound.mp3');
    if (life > 1) {
      life -= 1;
      remove(hearts[life]);
    }
    else {
      remove(hearts[life-1]);
      gameRef.scoreText.updateHighScore();
      gameRef.gameOver();
    }
  }
}
