import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'my_game.dart';
import 'square_component.dart';

/// A bullet that spawns at (startX, startY) and travels in [angle] direction.
/// On collision with a falling square, the bullet and the square are removed
/// and score is incremented.
class BulletComponent extends PositionComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  final double speed = 300; // pixels per second
  final double angle;       // direction in radians

  BulletComponent({
    required double startX,
    required double startY,
    required this.angle,
  }) {
    // bullet size, e.g. 5x10
    size = Vector2(5, 10);
    position = Vector2(startX - size.x / 2, startY - size.y); // center align
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Add a collision shape (rectangle) the same size as the bullet
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.white;
    canvas.drawRect(size.toRect(), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move in direction of [angle]
    //   0 rad is "to the right"
    //   -π/2 is "up"
    final direction = Vector2(math.cos(angle), math.sin(angle));
    position += direction * speed * dt;

    // Remove bullet if it goes off-screen
    if (x < 0 || x > gameRef.size.x || y < 0 || y > gameRef.size.y) {
      removeFromParent();
    }
  }

  /// Called when this bullet collides with another CollisionCallbacks component
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // If we hit a falling square, remove both and increment score
    if (other is SquareComponent) {
      other.removeFromParent(); // remove the square
      removeFromParent();       // remove the bullet
      gameRef.addToScore(1);
    }
  }
}
