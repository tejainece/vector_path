import 'dart:math';

import 'segment.dart';

class CircularArcSegment extends Segment {
  @override
  final P p1;
  @override
  final P p2;

  final double radius;
  final bool largeArc;
  final bool clockwise;

  CircularArcSegment(this.p1, this.p2, this.radius,
      {this.largeArc = false, this.clockwise = true});

  @override
  LineSegment get p1Tangent => radial1.normalAtP2(length: radius);

  @override
  LineSegment get p2Tangent => radial2.normalAtP2(length: radius);

  LineSegment tangentAt(P p) =>
      LineSegment(center, p).normalAtP2(length: radius);

  bool isOnCircle(P point, {double epsilon = 1e-3}) {
    final c = center;
    final diff = point - c;
    return (diff.x * diff.x + diff.y * diff.y - radius * radius)
        .equals(0, epsilon);
  }

  bool isOn(P point, {double epsilon = 1e-3}) {
    if (!isOnCircle(point, epsilon: epsilon)) return false;
    final ang = angleOfPoint(point);
    return startAngle <= ang && ang <= endAngle;
  }

  @override
  P lerp(double t) {
    Radian angle;
    if (clockwise) {
      angle = startAngle + this.angle.value * t;
    } else {
      angle = endAngle + this.angle.value * t;
    }
    return pointOnCircle(angle.value, radius, center);
  }

  @override
  double ilerp(P point) {
    final ang = angleOfPoint(point);

    double ret;
    if (clockwise) {
      ret = (ang - startAngle).value / angle.value;
    } else {
      ret = (ang - endAngle).value / angle.value;
    }
    return ret;
  }

  @override
  (CircularArcSegment, CircularArcSegment) bifurcateAtInterval(double t) {
    final p = lerp(t);
    final arc1LargeArc = angle.value * t > pi;
    final arc2LargeArc = angle.value * (1 - t) > pi;
    return (
      CircularArcSegment(p1, p, radius,
          largeArc: clockwise ? arc1LargeArc : arc2LargeArc,
          clockwise: clockwise),
      CircularArcSegment(p, p2, radius,
          largeArc: clockwise ? arc2LargeArc : arc1LargeArc,
          clockwise: clockwise)
    );
  }

  @override
  CircularArcSegment reversed() => CircularArcSegment(p2, p1, radius,
      largeArc: largeArc, clockwise: !clockwise);

  @override
  double get length => radius * angle.value;

  P get center {
    final dist = radius * cos(angle.value / 2);
    final bisector = line.bisector(length: dist, cw: clockwise);
    return bisector.p2;
  }

  Radian get angle {
    final opp = line.length / 2;
    final hypotenuse = radius;
    double angle = asin(opp / hypotenuse) * 2;
    if (!largeArc) return Radian(angle);
    return Radian(2 * pi - angle);
  }

  Radian angleOfPoint(P point) => LineSegment(center, point).angle;

  Radian get startAngle => LineSegment(center, p1).angle;

  Radian get endAngle => LineSegment(center, p2).angle;

  LineSegment get radial1 => LineSegment(center, p1);

  LineSegment get radial2 => LineSegment(center, p2);

  @override
  bool operator ==(other) =>
      other is CircularArcSegment &&
      other.p1 == p1 &&
      other.p2 == p2 &&
      other.radius == radius &&
      other.largeArc == largeArc &&
      other.clockwise == clockwise;

  @override
  int get hashCode => Object.hash(p1, p2, radius, largeArc, clockwise);
}
