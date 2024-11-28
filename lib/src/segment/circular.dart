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

  @override
  double get length {
    // TODO
    throw UnimplementedError();
  }

  double get center {
    // TODO
    throw UnimplementedError();
  }

  @override
  P pointAtInterval(double t) {
    // TODO
    throw UnimplementedError();
  }

  @override
  double intervalAtPoint(P point) {
    // TODO
    throw UnimplementedError();
  }

  @override
  (CircularArcSegment, CircularArcSegment) splitAtInterval(double t) {
    // TODO
    throw UnimplementedError();
  }
}