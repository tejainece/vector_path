import 'segment.dart';

class QuadraticSegment extends Segment {
  @override
  P p1;
  @override
  P p2;

  P c;

  QuadraticSegment({required this.p1, required this.p2, required this.c});

  @override
  LineSegment get p1Tangent => LineSegment(p1, c);

  @override
  LineSegment get p2Tangent => LineSegment(c, p2);

  @override
  P pointAtInterval(double t) => P(quadraticBezierLerp(p1.x, c.x, p2.x, t),
      quadraticBezierLerp(p1.y, c.y, p2.y, t));

  @override
  double intervalAtPoint(P point) {
    // TODO
    throw UnimplementedError();
  }

  /*
          """Returns two segments, dividing the given segment at a point t (0->1) along the curve."""
        p4 = self[0].lerp(self[1], t)
        p5 = self[1].lerp(self[2], t)
        p7 = p4.lerp(p5, t)
        return (QuadraticBezier(self[0], p4, p7), QuadraticBezier(p7, p5, self[2]))
   */
  @override
  (QuadraticSegment, QuadraticSegment) splitAtInterval(double t) {
    final curve1cp = LineSegment(p1, c).pointAtInterval(t);
    final curve2cp = LineSegment(c, p2).pointAtInterval(t);
    final bridge = LineSegment(curve1cp, curve2cp).pointAtInterval(t);
    // TODO
    throw UnimplementedError();
    return (
      QuadraticSegment(p1: p1, p2: bridge, c: curve1cp),
      QuadraticSegment(p1: bridge, p2: p2, c: curve2cp),
    );
  }

  @override
  double get length => _quadraticBezierLength(p1, c, p2, 0.01, 0);

  CubicSegment toCubic() => CubicSegment(
      p1: p1,
      p2: p2,
      c1: p1 * (1 / 3.0) + c * (2 / 3.0),
      c2: c * (2 / 3.0) + p2 * (1 / 3.0));
}

double _quadraticBezierLength(P a0, P a1, P a2, double tolerance, int level) {
  double lower = a0.distanceTo(a2);
  double upper = a0.distanceTo(a1) + a1.distanceTo(a2);

  if (upper - lower <= 2 * tolerance || level >= 8) {
    return (lower + upper) / 2;
  }

  P b1 = (a0 + a1) * 0.5;
  P c1 = (a1 + a2) * 0.5;
  P b2 = (b1 + c1) * 0.5;
  return _quadraticBezierLength(a0, b1, b2, 0.5 * tolerance, level + 1) +
      _quadraticBezierLength(b2, c1, a2, 0.5 * tolerance, level + 1);
}

double quadraticBezierLerp(double p0, double p1, double p2, double t) =>
    (1 - t) * (1 - t) * p0 + 2 * (1 - t) * t * p1 + t * t * p2;
