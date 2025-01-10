import 'dart:math';

import 'package:vector_path/vector_path.dart';

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
    return LineSegment(center, P.onCircle(angle, radius, center));
  }

  factory LineSegment.horizontal(double x1, double x2, [double y = 0]) =>
      LineSegment(P(x1, y), P(x2, y));

  factory LineSegment.vertical(double y1, double y2, [double x = 0]) =>
      LineSegment(P(x, y1), P(x, y2));

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

  bool isOnExtendedLine(P p, {double epsilon = 1e-3}) =>
      ((p2.x - p1.x) * (p.y - p1.y) - (p2.y - p1.y) * (p.x - p1.x)).abs() <
          epsilon;

  bool hasPoint(P p, {double epsilon = 1e-3}) {
    if(!isOnExtendedLine(p, epsilon: epsilon)) return false;
    if(p.x < min(p1.x, p2.x) || p.x > max(p1.x, p2.x)) return false;
    return true;
  }

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

  @override
  R get boundingBox => R.fromPoints(p1, p2);

  late final LineStandardForm standardForm =
      LineStandardForm.fromPoints(p1, p2);

  @override
  List<P> intersect(Segment other) {
    if (other is LineSegment) {
      final ret = intersectLineSegment(other);
      return ret != null ? [ret] : [];
    }
    throw ArgumentError(
        'Finding intersect LineSegment with ${other.runtimeType} is not implemented');
  }

  P? intersectLineSegment(LineSegment other) {
    final ret = standardForm.intersect(other.standardForm);
    if(!hasPoint(ret) || !other.hasPoint(ret)) return null;
    return ret;
  }

  /// https://mathworld.wolfram.com/Circle-LineIntersection.html
  List<P> intersectCircle(Circle circle) {
    final ret = <P>[];
    final det = p1.x * p2.y - p2.x * p1.y;
    final r2 = circle.radius * circle.radius;
    final det2 = det * det;
    final dx = p2.x - p1.x;
    final dy = p2.y - p1.y;
    final dr2 = dx * dx + dy * dy;
    final discriminant = r2 * dr2 - det2;
    if (discriminant < 0) {
      return ret;
    } else if (discriminant == 0) {
      ret.add(
          P(det * dy / dr2, -det * dx / dr2));
      return ret;
    }
    final discriminantSqrt = sqrt(discriminant);
    final y1 = (-det * dx - dy.abs() * discriminantSqrt) / dr2;
    final y2 = (-det * dx + dy.abs() * discriminantSqrt) / dr2;
    final x1 =
        (det * dy - dy.sign * dx * discriminantSqrt) / dr2;
    final x2 =
        (det * dy + dy.sign * dx * discriminantSqrt) / dr2;
    ret.add(P(x1, y1));
    ret.add(P(x2, y2));
    return ret;
  }
}

class LineVectorForm with ILine {
  final P p;
  @override
  final Radian angle;

  const LineVectorForm(this.p, this.angle);

  @override
  double get slope => angle.slope;
}

class LineSlopeForm with ILine {
  final double m;

  final double c;

  const LineSlopeForm(this.m, this.c);

  @override
  Radian get angle => Radian(atan(m));

  @override
  double get slope => m;

  @override
  String toString() => 'y = $m * x + $c';
}

class LineStandardForm with ILine {
  final double a;
  final double b;
  final double c;

  const LineStandardForm(this.a, this.b, this.c);

  factory LineStandardForm.fromPoints(P p1, P p2) {
    final a = p2.y - p1.y;
    final b = p1.x - p2.x;
    final c = p1.y * (p2.x - p1.x) - (p2.y - p1.y) * p1.x;
    return LineStandardForm(a, b, c);
  }

  @override
  double get slope => -a / b;

  @override
  Radian get angle => Radian(atan2(a, b));

  @override
  String toString() => '$a * x + $b * y + $c = 0';

  P intersect(LineStandardForm other) {
    final div = other.a * b - other.b * a;
    final x = (other.b * c - other.c * b) / div;
    final y = (-other.a * c + other.c * a) / div;
    return P(x, y);
  }
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
