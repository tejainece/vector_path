import 'segment.dart';

class CircularArcSegment extends Segment {
  @override
  final P p1;
  @override
  final P p2;

  final double radius;
  final bool largeArc;
  final bool clockwise;

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

  // TODO tangent at

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

  @override
  CircularArcSegment reversed() {
    throw UnimplementedError();
  }

  @override
  bool operator ==(other) =>
      other is CircularArcSegment &&
      other.p1 == p1 &&
      other.p2 == p2 &&
      other.radius == radius &&
      other.largeArc == largeArc &&
      other.clockwise == clockwise;

  @override
  int get hashCode => Object.hash(p1, p2, radius, largeArc, clockwise);
}
