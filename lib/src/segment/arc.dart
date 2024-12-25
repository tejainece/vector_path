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
  LineSegment get p1Tangent => ellipse.tangentAtPoint(p1);

  @override
  LineSegment get p2Tangent => ellipse.tangentAtPoint(p2);

  // TODO tangent at

  @override
  P lerp(double t) =>
      ellipse.lerpBetweenPoints(p1, p2, t, clockwise: clockwise);

  @override
  double ilerp(P point) =>
      ellipse.ilerpBetween(p1, p2, point, clockwise: clockwise);

  @override
  (ArcSegment, ArcSegment) bifurcateAtInterval(double t) {
    P mid = lerp(t);
    bool arc1LargeArc =
        ellipse.arcLengthBetweenPoints(p1, mid, clockwise: clockwise) >
            ellipse.perimeter / 2;
    bool arc2LargeArc =
        ellipse.arcLengthBetweenPoints(mid, p2, clockwise: clockwise) >
            ellipse.perimeter / 2;
    return (
      ArcSegment(p1, mid, radii,
          rotation: rotation, clockwise: clockwise, largeArc: arc1LargeArc),
      ArcSegment(mid, p2, radii,
          rotation: rotation, clockwise: clockwise, largeArc: arc2LargeArc)
    );
  }

  @override
  ArcSegment reversed() {
    return ArcSegment(p2, p1, radii,
        largeArc: largeArc, clockwise: !clockwise, rotation: rotation);
  }

  @override
  double get length => ellipse.arcLengthBetweenAngles(
      ellipse.angleOfPoint(p1), ellipse.angleOfPoint(p2),
      clockwise: clockwise);

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

  String get soloSvg =>
      'M${p1.x},${p1.y}A${radii.x},${radii.y},${rotation},${largeArc ? 1 : 0},${clockwise ? 0 : 1},${p2.x},${p2.y}';
}
