import 'dart:math';

import 'segment.dart';

class QuadraticSegment extends Segment {
  @override
  P p1;
  @override
  P p2;

  P c;

  QuadraticSegment(this.p1, this.p2, this.c);

  @override
  LineSegment get p1Tangent => LineSegment(p1, c);

  @override
  LineSegment get p2Tangent => LineSegment(c, p2);

  @override
  P pointAtInterval(double t) => P(quadraticBezierLerp(p1.x, c.x, p2.x, t),
      quadraticBezierLerp(p1.y, c.y, p2.y, t));
}

double quadraticBezierLerp(double p0, double p1, double p2, double t) =>
    (1 - t) * (1 - t) * p0 + 2 * (1 - t) * t * p1 + t * t * p2;
