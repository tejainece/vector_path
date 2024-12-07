import 'segment.dart';

class ArcSegment extends Segment {
  @override
  final P p1;
  @override
  final P p2;

  final P radius;
  final double rotation;
  final bool largeArc;
  final bool clockwise;

  ArcSegment(this.p1, this.p2, this.radius,
      {this.largeArc = false, this.clockwise = true, this.rotation = 0});

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
  (ArcSegment, ArcSegment) bifurcateAtInterval(double t) {
    // TODO
    throw UnimplementedError();
  }

  @override
  ArcSegment reversed() {
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
  bool operator ==(other) =>
      other is ArcSegment &&
          other.p1 == p1 &&
          other.p2 == p2 &&
          other.radius == radius &&
          other.largeArc == largeArc &&
          other.clockwise == clockwise &&
          other.rotation == rotation;

  @override
  int get hashCode => Object.hash(p1, p2, radius, rotation, largeArc, clockwise);
}