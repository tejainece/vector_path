import 'package:vector_path/vector_path.dart';

void main() {
  final scale = P(100, 50);
  final rot = Affine2d(scaleX: scale.x, scaleY: scale.y);
  print(rot);
  final p = P(1, 0);
  print(p);
  final p1 = rot.apply(p);
  print(p1);
  final arot = Affine2d(scaleX: 1 / scale.x, scaleY: 1 / scale.y);
  print(arot);
  final p2 = arot.apply(p1);
  print(p2);

  print(rot * arot);
}
