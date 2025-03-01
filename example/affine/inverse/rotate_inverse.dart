import 'dart:math';

import 'package:ramanujan/ramanujan.dart';

void main() {
  final angle = pi / 3;
  final rot = Affine2d.rotator(angle);
  print(rot);
  final p = P(1, 0);
  print(p);
  final p1 = rot.apply(p);
  print(p1);

  final arot = Affine2d.rotator(-angle);
  print(arot);
  final p2 = arot.apply(p1);
  print(p2);
  print(rot * arot);

  final arot1 = rot.inverse();
  print(arot1);
  final p3 = arot1.apply(p2);
  print(p3);
  print(rot * arot1);
}
