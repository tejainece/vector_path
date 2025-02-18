import 'package:vector_path/vector_path.dart';

void main() {
  final circle = Circle(center: P(0, 0), radius: 100);
  final line = LineSegment(P(-100, -100), P(100, 100)).standardForm;
  print(line.coefficients);
  // [200.0, -200.0, 0.0]
  final intersections = line.intersectCircle(circle);
  print(intersections);
  // [P(-70.71067811865476, -70.71067811865476), P(70.71067811865476, 70.71067811865476)]
}
