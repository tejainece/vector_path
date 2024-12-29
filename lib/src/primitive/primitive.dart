import 'dart:math';

import 'package:vector_path/src/primitive/angle.dart';
import 'package:vector_path/src/segment/line.dart';

export 'affine2d.dart';
export 'angle.dart';
export 'clamp.dart';

typedef P = Point<double>;

const origin = P(0, 0);

P pointOnCircle(double angle, [double radius = 1, P center = origin]) =>
    center + P(radius * cos(angle), radius * sin(angle));

extension PointExt on P {
  Point<double> operator /(double other) => Point(x / other, y / other);

  P rotate(double radians) => P(
      x * cos(radians) - y * sin(radians), x * sin(radians) + y * cos(radians));

  bool isEqual(Point<double> other, [double epsilon = 1e-3]) =>
      x.equals(other.x, epsilon) && y.equals(other.y, epsilon);

  LineSegment lineTo(P other) => LineSegment(this, other);

  LineSegment lineFrom(P other) => LineSegment(other, this);

  Radian get angle => Radian(atan2(y, x));
}
