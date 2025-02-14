import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

import 'my_game.dart';

/// A falling square. On collision with a bullet, it's destroyed.
class SquareComponent extends PositionComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  final Color color;
  final double fallSpeed = 200; // pixels per second

  SquareComponent({
    required double positionX,
    required double positionY,
    required double size,
    required this.color,
  }) {
    position = Vector2(positionX, positionY);
    this.size = Vector2.all(size);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Add a rectangular hitbox the same size
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = color;
    canvas.drawRect(size.toRect(), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Move downward
    y += fallSpeed * dt;

    // Remove if off-screen
    if (y > gameRef.size.y) {
      removeFromParent();
    }
  }
}
