import 'package:vector_path/vector_path.dart';

export 'circle.dart';
export 'ellipse.dart';
export 'rectangle.dart';

abstract class Shape {
  const Shape();

  double get perimeter;

  R get boundingBox;
}

abstract class ClosedShape extends Shape {
  const ClosedShape();

  bool containsPoint(P point);

  bool isPointOn(P point);

  double get area;
}