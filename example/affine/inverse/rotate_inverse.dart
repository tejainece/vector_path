import 'dart:math';

import 'package:vector_path/vector_path.dart';

void main() {
  final angle = pi/3;
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
}