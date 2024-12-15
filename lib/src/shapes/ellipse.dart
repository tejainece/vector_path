import 'package:vector_path/vector_path.dart';

class Ellipse {
  final P center;

  final P radii;

  final double rotation;

  Ellipse(this.radii, {this.center = const P(0, 0), this.rotation = 0});

  factory Ellipse.fromSvgParameters(P p1, P p2, P radii,
      {double rotation = 0, bool clockwise = false, bool largeArc = false}) {
    final d = P((p1.x - p2.x) / 2, (p1.y - p2.y) / 2);
    final costh = cos(rotation);
    final sinth = sin(rotation);
    final transformed =
        P(d.x * costh + d.y * sinth, d.x * -sinth + d.y * costh);
    final rx = radii.x;
    final ry = radii.y;
    final rx2 = rx * rx;
    final ry2 = ry * ry;
    final tx2 = transformed.x * transformed.x;
    final ty2 = transformed.y * transformed.y;
    var factor =
        sqrt((rx2 * ry2 - rx2 * ty2 - ry2 * tx2) / (rx2 * ty2 + ry2 * tx2));
    if (largeArc == clockwise) {
      factor = -factor;
    }
    final centerTransformed = P(factor * (rx * transformed.y) / ry,
        -factor * (ry * transformed.x) / rx);
    final chordMid = (p1 + p2) / 2;
    final center = P(
        costh * centerTransformed.x - sinth * centerTransformed.y + chordMid.x,
        sinth * centerTransformed.x + costh * centerTransformed.y + chordMid.y);
    return Ellipse(radii, center: center, rotation: rotation);
  }

  /// Returns the affine transformation that maps the unit circle to this ellipse
  Affine2d get unitCircleTransform =>
      Affine2d(translateX: center.x, translateY: center.y)
          .rotate(rotation)
          .scale(radii.x, radii.y);

  /// Returns the affine transformation that maps this ellipse to the unit circle
  Affine2d get inverseUnitCircleTransform =>
      Affine2d(scaleX: 1 / radii.x, scaleY: 1 / radii.y)
          .rotate(-rotation)
          .translate(-center.x, -center.y);

  Ellipse canonicalForm() {
    if (radii.x == radii.y) {
      return Ellipse(radii, center: center, rotation: 0);
    }
    double rotation = this.rotation;
    if (rotation < 0) {
      rotation += pi;
    }
    if (rotation >= pi / 2) {
      return Ellipse(P(radii.y, radii.x),
          center: center, rotation: rotation - pi / 2);
    }
    return Ellipse(radii, center: center, rotation: rotation);
  }

  P pointAtAngle(double angle) {
    final unitCircleTransform = this.unitCircleTransform;
    return unitCircleTransform.apply(pointOnCircle(angle));
  }

  Radian angleOfPoint(P point) {
    final inverseUnitCircleTransform = this.inverseUnitCircleTransform;
    return inverseUnitCircleTransform.apply(point).angle;
  }

  // TODO valueAt

  bool isEqual(Ellipse other, [double epsilon = 1e-3]) {
    if (!center.isEqual(other.center, epsilon)) return false;
    final a = canonicalForm();
    final b = other.canonicalForm();
    if (!a.radii.isEqual(b.radii, epsilon)) return false;
    if (!a.rotation.equals(b.rotation, epsilon)) return false;
    return true;
  }

  late final double a = max(radii.x, radii.y);

  late final double b = min(radii.x, radii.y);

  late final double h = () {
    final diff = radii.x - radii.y;
    final sum = radii.x + radii.y;
    return (diff * diff) / (sum * sum);
  }();

  double get perimeter =>
      pi * (radii.x + radii.y) * (1 + 3 * h / (10 + sqrt(4 - 3 * h)));

  double get area => pi * a * b;
}
