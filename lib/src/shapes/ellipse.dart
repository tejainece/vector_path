import 'dart:math';

import 'package:vector_path/vector_path.dart';

class Ellipse {
  final P center;

  final P radii;

  final double rotation;

  Ellipse(this.radii, {this.center = const P(0, 0), this.rotation = 0});

  /// Returns the affine transformation that maps the unit circle to this ellipse
  Affine2d get unitCircleTransform =>
      Affine2d.rotator(rotation).scale(radii.x, radii.y).translate(
          center.x, center.y);

  /*Affine2d get unitCircleTransform => Affine2d(scaleX: radii.x, scaleY: radii.y)
      .rotate(rotation)
      .translate(center.x, center.y);*/

  /// Returns the affine transformation that maps this ellipse to the unit circle
  Affine2d get inverseUnitCircleTransform =>
      Affine2d(translateX: -center.x, translateY: -center.y)
          .rotate(-rotation)
          .scale(-radii.x, -radii.y);

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

  // TODO valueAt

  bool isEqual(Ellipse other, [double epsilon = 1e-3]) {
    if (!center.isEqual(other.center, epsilon)) return false;
    final a = canonicalForm();
    final b = other.canonicalForm();
    if (!a.radii.isEqual(b.radii, epsilon)) return false;
    if (!a.rotation.equals(b.rotation, epsilon)) return false;
    return true;
  }
}
