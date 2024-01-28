import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/widgets.dart';

class Ball extends BodyComponent with TapCallbacks {
  Ball({
    Vector2? initialPosition,
    required double radius,
    required double restitution,
    required double friction,
    required double angularDamping,
    required this.size,
    required this.image,
  }) : super(
          fixtureDefs: [
            FixtureDef(
              CircleShape()..radius = radius,
              restitution: restitution,
              friction: friction,
            ),
          ],
          bodyDef: BodyDef(
            angularDamping: angularDamping,
            position: initialPosition ?? Vector2.zero(),
            type: BodyType.dynamic,
          ),
        );

  late final double size;
  late final String image;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(game.images.fromCache(image));
    paint = Paint()..color = const Color(0x00000000);
    add(
      SpriteComponent(
        sprite: sprite,
        size: Vector2(size, size),
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void onTapDown(event) {
    body.applyLinearImpulse(Vector2.random() * 5);
  }
}
