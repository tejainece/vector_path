import 'dart:math';

import 'package:vector_path/vector_path.dart';

class ArcSegment extends Segment {
  @override
  final P p1;
  @override
  final P p2;

  final P radii;
  final double rotation;
  final bool largeArc;
  final bool clockwise;

  ArcSegment(this.p1, this.p2, this.radii,
      {this.largeArc = false, this.clockwise = true, this.rotation = 0});

  late final Ellipse ellipse = Ellipse.fromSvgParameters(p1, p2, radii,
      rotation: rotation, clockwise: clockwise, largeArc: largeArc);

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
    return ArcSegment(p2, p1, radii,
        largeArc: largeArc, clockwise: !clockwise, rotation: rotation);
  }

  @override
  double get length {
    // TODO
    throw UnimplementedError();
  }

  late final LineSegment chord = LineSegment(p1, p2);

  P get center => ellipse.center;

  @override
  bool operator ==(other) =>
      other is ArcSegment &&
      other.p1 == p1 &&
      other.p2 == p2 &&
      other.radii == radii &&
      other.largeArc == largeArc &&
      other.clockwise == clockwise &&
      other.rotation == rotation;

  @override
  int get hashCode => Object.hash(p1, p2, radii, rotation, largeArc, clockwise);
}
