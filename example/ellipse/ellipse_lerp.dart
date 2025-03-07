import 'dart:math';

import 'package:ramanujan/ramanujan.dart';

void main() {
  final ellipse = Ellipse(P(100, 60));
  final angle = pi / 6;
  final point = ellipse.lerp(angle / (2 * pi));
  print(point.angle);
  print(angle);
  print(ellipse.angleOfPoint(point));
}
