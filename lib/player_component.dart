import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'my_game.dart';
import 'bullet_component.dart';

/// A purple square of size 20x20 at the bottom of the screen, shooting bullets.
class PlayerComponent extends PositionComponent
    with HasGameRef<MyGame> {
  final double _widthAndHeight = 20;
  final double _shootInterval = 1.0; // shoot every 1 second
  double _shootTimer = 0;

  PlayerComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Size of the player
    this.size = Vector2.all(_widthAndHeight);

    // We'll position the player near the bottom center in onMount,
    // since the gameRef.size is known there.
  }

  @override
  void onMount() {
    super.onMount();

    // Bottom-center position
    final gameWidth = gameRef.size.x;
    final gameHeight = gameRef.size.y;
    x = (gameWidth - width) / 2;     // center horizontally
    y = gameHeight - height - 10;    // a bit above bottom
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.purple;
    canvas.drawRect(size.toRect(), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Simple auto-shoot on a timer
    _shootTimer += dt;
    if (_shootTimer >= _shootInterval) {
      _shootTimer = 0;
      _shootThreeBullets();
    }
  }

  /// Fire three bullets: one straight up, and two at ±30° from up.
  void _shootThreeBullets() {
    // We'll define angles in radians, where 0 rad = right, π/2 rad = down, -π/2 rad = up.
    // So "up" is -π/2. We want ±30° from that in degrees => ±(30°) = ±(π/6).
    const double middleAngle = -math.pi / 2; // straight up
    const double angleOffset = math.pi / 6;  // 30 degrees in radians

    final angles = [
      middleAngle - angleOffset, // left bullet (120° from the x-axis)
      middleAngle,               // center bullet (90° from x-axis => straight up)
      middleAngle + angleOffset, // right bullet (60° from the x-axis)
    ];

    for (final angle in angles) {
      final bullet = BulletComponent(
        startX: x + width / 2,  // center of player
        startY: y,
        angle: angle,
      );
      gameRef.add(bullet);
    }
  }
}
