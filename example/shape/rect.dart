import 'package:vector_path/vector_path.dart';

void main() {
  final r = R(10, 10, 0, 0);
  print(r.containsPoint(P(10, 10)));
  print(r.width);
  print(r.height);
}