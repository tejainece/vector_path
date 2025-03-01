import 'dart:math';

import 'package:ramanujan/src/primitive/angle.dart';

void main() {
  final angle1 = Radian(0.001);
  final angle2 = Radian(2 * pi - 0.001);
  print(angle1.equals(angle2));
  print(angle2.equals(angle1));
}
