import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/widgets.dart';
import 'package:flame/palette.dart';

void main() {
  runApp(const GameWidget.controlled(gameFactory: Forge2DExample.new));
}

// Fixed viewport size
final screenSize = Vector2(720, 1280);

// Scaled viewport size
const scale = 100.0;
final worldSize = screenSize / scale;

class Forge2DExample extends Forge2DGame {
  Forge2DExample()
      : super(
          zoom: scale,
          cameraComponent: CameraComponent.withFixedResolution(
              width: screenSize.x, height: screenSize.y),
          gravity: Vector2(0, 10),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport.add(FpsTextComponent());
    await loadSprite('apple.png');
    world.add(Ball());
    world.addAll(createBoundaries());
  }

  List<Component> createBoundaries() {
    final visibleRect = camera.visibleWorldRect;
    final left = lerpDouble(visibleRect.left, visibleRect.right, 0.2);
    final right = lerpDouble(visibleRect.left, visibleRect.right, 0.8);
    final top = lerpDouble(visibleRect.top, visibleRect.bottom, 0.3);
    final bottom = lerpDouble(visibleRect.top, visibleRect.bottom, 0.9);
    final topLeft = Vector2(left!, top!);
    final topRight = Vector2(right!, top);
    final bottomLeft = Vector2(left, bottom!);
    final bottomRight = Vector2(right, bottom);

    return [
      Wall(topRight, bottomRight),
      Wall(bottomLeft, bottomRight),
      Wall(topLeft, bottomLeft),
    ];
  }
}

class Ball extends BodyComponent with TapCallbacks {
  Ball({Vector2? initialPosition})
      : super(
          fixtureDefs: [
            FixtureDef(
              CircleShape()..radius = 0.3,
              restitution: 0.8,
              friction: 0.4,
            ),
          ],
          bodyDef: BodyDef(
            angularDamping: 0.8,
            position: initialPosition ?? Vector2.zero(),
            type: BodyType.dynamic,
          ),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(game.images.fromCache('apple.png'));
    paint = Paint()..color = const Color(0x00000000);
    add(
      SpriteComponent(
        sprite: sprite,
        size: Vector2(0.9, 0.9),
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void onTapDown(_) {
    body.applyLinearImpulse(Vector2.random() * 5000);
  }

  @override
  void render(Canvas canvas) {
    // Render the sprite instead of the CircleShape
    super.render(canvas);
  }
}

class Wall extends BodyComponent {
  final Vector2 _start;
  final Vector2 _end;

  Wall(this._start, this._end);

  @override
  Body createBody() {
    final shape = EdgeShape()..set(_start, _end);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(
      position: Vector2.zero(),
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void render(Canvas canvas) {
    final Paint paint = BasicPalette.white.paint()
      ..strokeWidth = 0.3; // You can customize the color
    canvas.drawLine(_start.toOffset(), _end.toOffset(), paint);
  }
}
