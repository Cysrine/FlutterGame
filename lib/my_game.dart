import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'dart:math' as math;

import 'square_component.dart';
import 'score_text_component.dart';
import 'player_component.dart';

/// Our main Flame game class. We enable collision detection with the mixin.
class MyGame extends FlameGame with PanDetector, HasCollisionDetection  {
  double _spawnTimer = 0.0;
  double _difficultyTimer = 0.0;
  double fallSpeed = 200;
  double _spawnInterval = 1.0; // spawn a block every 1 second
  // Keep reference to score text so we can update it.
  late ScoreTextComponent scoreText;

  late LifeComponent health;

  late PlayerComponent player;

  late SquareComponent square;

  

  @override
  Future<void> onLoad() async { 
    await super.onLoad();

    // Add the score text at the top-left
    scoreText = ScoreTextComponent();
    add(scoreText);

    health = LifeComponent();
    add(health);

    // Add the player near the bottom center
    // We'll position it after the game has a defined size (in onMount below).
    player = PlayerComponent();
    add(player);

    FlameAudio.audioCache.load('bulletCollision.mp3');
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Spawn new falling squares on a timer
    _spawnTimer += dt;  
    _difficultyTimer += dt;
    fallSpeed += (3*dt);

    if (_spawnTimer >= _spawnInterval) {
      _spawnTimer = 0;
      spawnFallingSquare();
    }
    if(_difficultyTimer >= 30) {
      _difficultyTimer = 0;
      //fallSpeed += 100;
      if(_spawnInterval > 0.25) {
        _spawnInterval -= 0.25;
      }
    }
  }

  

  void spawnFallingSquare() {
    // Pick a random horizontal position
    final randomX = math.Random().nextDouble() * (size.x - 20);

    // Random color
    final colors = [Colors.red, Colors.green, Colors.yellow, Colors.blue];
    final color = colors[math.Random().nextInt(colors.length)];

    // Create and add the falling square
    square = SquareComponent(
      positionX: randomX,
      positionY: 0,
      size: 20,
      color: color,
    );
    add(square);
  }

void increaseDifficulty(double dt) {
    increaseDifficulty(dt);
    
  }
  /// Increase the displayed score by [points].
  void addToScore(int points) {
    scoreText.increment(points);
  }

  void hitDamage() {
    health.byeByeHeart();
  }

  void gameOver() {
  pauseEngine(); 
  overlays.add('GameOver'); 
}

  void reset() {
    resumeEngine();
    scoreText.score = 0;
    scoreText.increment(0);
    health.resuscitate();
    _spawnInterval = 1.0;
    fallSpeed = 100;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    final dragPosition = info.eventPosition.global;
    player.x = dragPosition.x - (player.width / 2);

    // Clamp player position within screen bounds
    if (player.x < 0) {
      player.x = 0;
    } else if (player.x + player.width > size.x) {
      player.x = size.x - player.width;
    }
  }
}
