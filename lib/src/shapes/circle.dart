import 'package:vector_path/vector_path.dart';

class Circle {
  final P center;
  final double radius;

  Circle({this.center = const P(0, 0), this.radius = 1});

  P pointAtAngle(double angle) =>
      center + P(radius * cos(angle), radius * sin(angle));

  Radian angleOfPoint(P point) => LineSegment(center, point).angle;

  double arcLengthToT(double t) => perimeter * t;

  double arcLengthAtAngle(double radians) {
    radians = Radian(radians).value;
    return perimeter * radians / (2 * pi);
  }

  CircularArcSegment arc(Radian start, Radian end) {
    return CircularArcSegment(
        pointAtAngle(start.value), pointAtAngle(end.value), radius,
        largeArc: (start.value - end.value).abs() > pi, clockwise: end < start);
  }

  bool isEqual(Circle other, [double epsilon = 1e-3]) {
    if (!center.isEqual(other.center, epsilon)) return false;
    if (!radius.equals(other.radius, epsilon)) return false;
    return true;
  }

  late final double area = pi * radius * radius;

  late final double perimeter = 2 * pi * radius;

  P lerp(double t) => pointAtAngle(2 * pi * t);

  P lerpBetween(double t1, double t2, double t, {bool clockwise = false}) =>
      lerp(Clamp.unit.lerp(t1, t2, t, clockwise: clockwise));

  double ilerp(P point) {
    final angle = angleOfPoint(point);
    return angle.value / (2 * pi);
  }
}
