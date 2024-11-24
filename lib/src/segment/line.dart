import 'dart:math';

import 'segment.dart';

abstract mixin class ILine {
  Radian get angle;

  double get slope;

  double get normalSlope => -1 / slope;

  Radian get normalAngle => angle + pi / 2;

  bool isParallelTo(ILine other, [double epsilon = 1e-3]) {
    final diff = angle - other.angle;
    return diff.equals(Radian(0), epsilon) || diff.equals(Radian(pi), epsilon);
  }

  bool isPerpendicularTo(ILine other, [double epsilon = 1e-3]) {
    final diff = angle - other.angle;
    return diff.equals(Radian(pi / 2), epsilon) ||
        diff.equals(Radian(3 * pi / 2), epsilon);
  }
}

class LineSegment extends Segment with ILine {
  @override
  P p1;
  @override
  P p2;

  LineSegment(this.p1, this.p2);

  LineSegment.origin(this.p2) : p1 = origin;

  factory LineSegment.radial(double angle,
      [double radius = 1, P center = origin]) {
    return LineSegment(
        center, center + P(radius * cos(angle), radius * sin(angle)));
  }

  @override
  LineSegment get p1Tangent => LineSegment(p1, p2);

  @override
  LineSegment get p2Tangent => LineSegment(p1, p2);

  @override
  double get slope => (p2.y - p1.y) / (p2.x - p1.x);

  @override
  Radian get angle => Radian(atan2(slope, 1));

  P get midpoint => (p1 + p2) / 2;

  LineSegment rotate(double radians) =>
      LineSegment(p1, p1 + (p2 - p1).rotate(radians));

  Radian angleTo(LineSegment other) => angle - other.angle;

  @override
  bool operator ==(other) =>
      other is LineSegment && other.p1.isEqual(p1) && other.p2.isEqual(p2);

  @override
  int get hashCode => Object.hash(p1, p2);

  @override
  String toString() => 'Line($p1, $p2)';
}

class Line with ILine {
  final P p;
  @override
  final Radian angle;

  const Line(this.p, this.angle);

  @override
  double get slope => angle.slope;
}
