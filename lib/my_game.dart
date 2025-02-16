import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'square_component.dart';
import 'score_text_component.dart';
import 'player_component.dart';

/// Our main Flame game class. We enable collision detection with the mixin.
class MyGame extends FlameGame with PanDetector, HasCollisionDetection  {
  double _spawnTimer = 0.0;
  final double _spawnInterval = 1.0; // spawn a block every 1 second
  // Keep reference to score text so we can update it.
  late ScoreTextComponent scoreText;

  late LifeComponent health;

  late PlayerComponent player;

  

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
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Spawn new falling squares on a timer
    _spawnTimer += dt;  
    if (_spawnTimer >= _spawnInterval) {
      _spawnTimer = 0;
      spawnFallingSquare();
    }
  }

  void spawnFallingSquare() {
    // Pick a random horizontal position
    final randomX = math.Random().nextDouble() * (size.x - 20);

    // Random color
    final colors = [Colors.red, Colors.green, Colors.yellow, Colors.blue];
    final color = colors[math.Random().nextInt(colors.length)];

    // Create and add the falling square
    final square = SquareComponent(
      positionX: randomX,
      positionY: 0,
      size: 20,
      color: color,
    );
    add(square);
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
