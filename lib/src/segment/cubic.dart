import 'segment.dart';

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
}