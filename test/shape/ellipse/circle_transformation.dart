import 'package:test/test.dart';
import 'package:vector_path/vector_path.dart';

class _EllipseCircleTransformTestCase {
  final Ellipse ellipse;

  final P pointOnCircle;

  final P pointOnEllipse;

  _EllipseCircleTransformTestCase(
      this.ellipse, this.pointOnCircle, this.pointOnEllipse);

  factory _EllipseCircleTransformTestCase.fromAngle(
      Ellipse ellipse, double angle) {
    final pointOnCircle = ellipse.pointAtAngle(angle);
    final pointOnEllipse =
        ellipse.inverseUnitCircleTransform.apply(pointOnCircle);
    return _EllipseCircleTransformTestCase(
        ellipse, pointOnCircle, pointOnEllipse);
  }

  static List<_EllipseCircleTransformTestCase> cases = [];
}

void main() {
  group('Shape.Ellipse.CircleTransformation', () {
    test('circleTransformation', () {});
  });
}
