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
}