import 'segment.dart';

///
class CubicSegment extends Segment {
  @override
  P p1;
  @override
  P p2;

  P c1;
  P c2;

  CubicSegment(
      {required this.p1, required this.p2, required this.c1, required this.c2});

  @override
  LineSegment get p1Tangent => LineSegment(p1, c1);

  @override
  LineSegment get p2Tangent => LineSegment(c2, p2);

  @override
  double get length => _cubicBezierLength(p1, c1, c2, p2, 0.01, 0);

  @override
  P pointAtInterval(double t) => P(cubicBezierLerp(p1.x, c1.x, c2.x, p2.x, t),
      cubicBezierLerp(p1.y, c1.y, c2.y, p2.y, t));

  @override
  double intervalAtPoint(P point) {
    // TODO
    throw UnimplementedError();
  }

  @override
  (CubicSegment, CubicSegment) splitAtInterval(double t) {
    // TODO
    throw UnimplementedError();
  }
}

double _cubicBezierLength(P a0, P a1, P a2, P a3, double tolerance, int level) {
  double lower = a0.distanceTo(a2);
  double upper = a0.distanceTo(a1) + a1.distanceTo(a2) + a2.distanceTo(a3);

  if (upper - lower <= 2 * tolerance || level >= 8) {
    return (lower + upper) / 2;
  }
  P b1 = (a0 + a1) * 0.5;
  P t0 = (a1 + a2) * 0.5;
  P c1 = (a2 + a3) * 0.5;
  P b2 = (b1 + t0) * 0.5;
  P c2 = (t0 + c1) * 0.5;
  P b3 = (b2 + c2) * 0.5;

  return _cubicBezierLength(a0, b1, b2, b3, 0.5 * tolerance, level + 1) +
      _cubicBezierLength(b3, c2, c1, a3, 0.5 * tolerance, level + 1);
}

double cubicBezierLerp(double p0, double p1, double p2, double p3, double t) =>
    (1 - t) * (1 - t) * (1 - t) * p0 +
    3 * (1 - t) * (1 - t) * t * p1 +
    3 * (1 - t) * t * t * p2 +
    t * t * t * p3;
