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
    return diff.isParallelTo(Radian(pi / 2), epsilon);
  }
}

class LineSegment extends Segment with ILine {
  @override
  final P p1;
  @override
  final P p2;

  LineSegment(this.p1, this.p2);

  LineSegment.origin(this.p2) : p1 = origin;

  factory LineSegment.radial(double angle,
      [double radius = 1, P center = origin]) {
    return LineSegment(center, pointOnCircle(angle, radius, center));
  }

  @override
  LineSegment get p1Tangent => LineSegment(p1, p2);

  @override
  LineSegment get p2Tangent => LineSegment(p1, p2);

  @override
  double get slope => (p2.y - p1.y) / (p2.x - p1.x);

  @override
  Radian get angle => Radian(atan2(p2.y - p1.y, p2.x - p1.x));

  P get midpoint => (p1 + p2) / 2;

  LineSegment rotate(double radians) =>
      LineSegment(p1, p1 + (p2 - p1).rotate(radians));

  Radian angleTo(LineSegment other) => angle - other.angle;

  P pointAt(double x) => P(x, slope * x + yIntercept);

  double get yIntercept => p1.y - slope * p1.x;

  double lerpX(double t) => p1.x + (p2.x - p1.x) * t;

  @override
  P lerp(double t) => p1 * (1 - t) + p2 * t;

  @override
  double ilerp(P point) => (point.x - p1.x) / (p2.x - p1.x);

  @override
  (LineSegment, LineSegment) bifurcateAtInterval(double t) {
    final point = lerp(t);
    return (LineSegment(p1, point), LineSegment(point, p2));
  }

  @override
  double get length => p1.distanceTo(p2);

  P pointAtDistanceFromP1(double distance) => lerp(distance / length);

  P pointAtDistanceFromP2(double distance) => lerp(1 - distance / length);

  P pointAtDistanceFrom(P p, double distance) {
    if (!hasPoint(p)) {
      throw Exception('Point $p is not on the line');
    }
    final dist1 = p1.distanceTo(p);
    final dist2 = p2.distanceTo(p);
    if (dist1 >= dist2) {
      return LineSegment(p, p1).lerp(distance / dist1);
    }
    return LineSegment(p, p2).lerp(distance / dist2);
  }

  bool hasPoint(P p, {double epsilon = 1e-3}) =>
      ((p2.x - p1.x) * (p.y - p1.y) - (p2.y - p1.y) * (p.x - p1.x)).abs() <
          epsilon;

  @override
  LineSegment reversed() => LineSegment(p2, p1);

  @override
  bool operator ==(other) =>
      other is LineSegment && other.p1.isEqual(p1) && other.p2.isEqual(p2);

  LineSegment normalAt(P point, {double? length, bool cw = true}) {
    final angle = this.angle + Radian(cw ? pi / 2 : 3 * pi / 2);
    return LineSegment.radial(angle.value, length ?? 1, point);
  }

  LineSegment normalAtP1({double? length, bool cw = true}) =>
      normalAt(p1, length: length, cw: cw);

  LineSegment normalAtP2({double? length, bool cw = true}) =>
      normalAt(p2, length: length, cw: cw);

  LineSegment bisector({double? length, bool cw = true}) =>
      normalAt(midpoint, length: length, cw: cw);

  LineSegment transform(Affine2d affine) =>
      LineSegment(affine.apply(p1), affine.apply(p2));

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

extension PointsLineSegmentExt on Iterable<P> {
  List<LineSegment> toLines() {
    final lines = <LineSegment>[];
    if (length < 2) return lines;
    P pivot = first;
    for (final cur in skip(1)) {
      lines.add(LineSegment(pivot, cur));
      pivot = cur;
    }
    return lines;
  }
}
