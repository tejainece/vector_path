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
  P lerp(double t) {
    // TODO
    throw UnimplementedError();
  }

  @override
  double ilerp(P point) {
    // TODO
    throw UnimplementedError();
  }

  @override
  (CircularArcSegment, CircularArcSegment) bifurcateAtInterval(double t) {
    // TODO
    throw UnimplementedError();
  }
}