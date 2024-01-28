import 'dart:ui';

import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/widgets.dart';
import 'package:flame/palette.dart';

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
