
import 'package:vector_path/vector_path.dart';

void main() {
  final center = P(0, 0);
  final radius = 1.0;
  final startAngle = Radian(0);
  final endAngle = Radian(3 * pi / 2);
  final clockwise = startAngle < endAngle;
  final largeArc =
      Radian((endAngle.value - startAngle.value).abs()) > Radian(pi);
  final arc = CircularArcSegment(
      pointOnCircle(startAngle.value, radius, center),
      pointOnCircle(endAngle.value, radius, center),
      radius,
      clockwise: clockwise,
      largeArc: largeArc);
  print('angle: ${arc.angle.toDegree}');
}
