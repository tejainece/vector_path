import 'segment.dart';

///
class CubicSegment extends Segment {
  @override
  P p1;
  @override
  P p2;

  P c1;
  P c2;

  CubicSegment(this.p1, this.p2, this.c1, this.c2);

  @override
  LineSegment get p1Tangent => LineSegment(p1, c1);

  @override
  LineSegment get p2Tangent => LineSegment(c2, p2);

  @override
  P pointAtInterval(double t) => P(cubicBezierLerp(p1.x, c1.x, c2.x, p2.x, t),
      cubicBezierLerp(p1.y, c1.y, c2.y, p2.y, t));
}

double cubicBezierLerp(double p0, double p1, double p2, double p3, double t) =>
    (1 - t) * (1 - t) * (1 - t) * p0 +
    3 * (1 - t) * (1 - t) * t * p1 +
    3 * (1 - t) * t * t * p2 +
    t * t * t * p3;
