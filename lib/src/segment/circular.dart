import 'segment.dart';

class CircularArcSegment extends Segment {
  @override
  P p1;
  @override
  P p2;

  double radius;
  bool largeArc;
  bool clockwise;

  CircularArcSegment(this.p1, this.p2, this.radius,
      {this.largeArc = false, this.clockwise = true});

  double get center {
    // TODO
    throw UnimplementedError();
  }

  @override
  LineSegment get p1Tangent {
    // TODO
    throw UnimplementedError();
  }

  @override
  LineSegment get p2Tangent {
    // TODO
    throw UnimplementedError();
  }
}