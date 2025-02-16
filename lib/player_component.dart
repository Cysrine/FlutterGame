import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/square_component.dart';
import 'dart:math' as math;

import 'my_game.dart';
import 'bullet_component.dart';
import 'main.dart';


class PlayerComponent extends SpriteComponent with CollisionCallbacks, HasGameRef<MyGame> {
  final double _shootInterval = 1.0; // shoot every 1 second
  double _shootTimer = 0;

  PlayerComponent() : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the .webp sprite
    sprite = await gameRef.loadSprite('player.webp');

    // Set the initial size
    // Option A: match the image’s original size:
    // size = sprite!.srcSize;
    // Option B: explicitly define the size in logical pixels:
    size = Vector2.all(50);
    angle = -math.pi / 2;
    debugMode = true;
    add(RectangleHitbox());
    // We'll position the player near the bottom in onMount(),
    // once gameRef.size is known.
  }

  @override
  void onMount() {
    super.onMount();

    // Bottom-center position, 50px above bottom for example:
    final gameWidth = gameRef.size.x;
    final gameHeight = gameRef.size.y;
    x = (gameWidth - width) / 2;
    y = gameHeight - height - 50;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Shooting logic remains the same
    _shootTimer += dt;
    if (_shootTimer >= _shootInterval) {
      _shootTimer = 0;
      _shootThreeBullets();
    }
  }

  void _shootThreeBullets() {
    const double middleAngle = -math.pi / 2; // straight up
    const double angleOffset = math.pi / 6;  // 30 degrees

    final angles = [
      middleAngle - angleOffset,
      middleAngle,
      middleAngle + angleOffset,
    ];

    // Center bullets relative to player's mid-top
    for (final angle in angles) {
      final bullet = BulletComponent(
        startX: x + width / 2,
        startY: y,
        angle: angle,
      );
      gameRef.add(bullet);
    }

  }

  @override
void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
  super.onCollision(intersectionPoints, other);

  if (other is SquareComponent) {
    other.removeFromParent();
    gameRef.hitDamage();

    // Handle player damage or response here
  }
}

}
