import 'dart:ui';
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart' hide Timer;
import 'package:flutter/widgets.dart';

import 'components/ball.dart';
import 'components/wall.dart';

void main() {
  runApp(const GameWidget.controlled(gameFactory: FruitGame.new));
}

// Fixed viewport size
final screenSize = Vector2(720, 1280);

// Scaled viewport size
const scale = 100.0;
final worldSize = screenSize / scale;

class FruitGame extends Forge2DGame {
  FruitGame()
      : super(
          zoom: scale,
          cameraComponent: CameraComponent.withFixedResolution(
              width: screenSize.x, height: screenSize.y),
          gravity: Vector2(0, 10),
        );

  final Component myBall = Ball(
    radius: 0.3,
    restitution: 0.8,
    friction: 0.4,
    angularDamping: 0.8,
    size: 0.9,
    image: 'apple.png',
  );
  Timer interval = Timer(1);

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport.add(FpsTextComponent());
    await loadSprite('apple.png');
    world.add(myBall);
    world.addAll(createBoundaries());
    interval = Timer(
      5,
      onTick: () {
        world.add(
          Ball(
            radius: 0.3,
            restitution: 0.8,
            friction: 0.4,
            angularDamping: 0.8,
            size: 0.9,
            image: 'apple.png',
          ),
        );
      },
    );
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
