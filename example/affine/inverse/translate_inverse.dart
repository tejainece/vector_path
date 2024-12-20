import 'package:vector_path/vector_path.dart';

void main() {
  final rot = Affine2d(translateX: 100, translateY: 100);
  print(rot);
  final p = P(1, 0);
  print(p);
  final p1 = rot.apply(p);
  print(p1);
  final arot = Affine2d(translateX: -100, translateY: -100);
  print(arot);
  final p2 = arot.apply(p1);
  print(p2);

  print(rot * arot);
}