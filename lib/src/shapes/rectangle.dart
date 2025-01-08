import 'dart:math';
import 'package:vector_path/vector_path.dart';

class R implements ClosedShape {
  /// The x-coordinate of the left edge.ble left;
  final double left;

  /// The y-coordinate of the top edge.
  final double top;

  /// The width of the rectangle.
  final double width;

  /// The height of the rectangle.
  final double height;

  const R(this.left, this.top, this.width, this.height)
      : assert(width >= 0),
        assert(height >= 0);

  factory R.fromPoints(P p1, P p2) {
    final left = min(p1.x, p2.x);
    final width = max(p1.x, p2.x) - left;
    final top = min(p1.y, p2.y);
    final height = max(p1.y, p2.y) - top;
    return R(left, top, width, height);
  }

  /// The x-coordinate of the right edge.
  double get right => left + width;

  /// The y-coordinate of the bottom edge.
  double get bottom => top + height;

  @override
  String toString() => 'Rectangle ($left, $top) $width x $height';

  @override
  bool operator ==(Object other) =>
      other is Rectangle &&
      left == other.left &&
      top == other.top &&
      width == other.width &&
      height == other.height;

  @override
  int get hashCode => Object.hash(left, top, right, bottom);

  /// Computes the intersection of `this` and [other].
  ///
  /// The intersection of two axis-aligned rectangles, if any, is always another
  /// axis-aligned rectangle.
  ///
  /// Returns the intersection of this and `other`, or `null` if they don't
  /// intersect.
  R? intersection(R other) {
    var x0 = max(left, other.left);
    var x1 = min(left + width, other.left + other.width);

    if (x0 <= x1) {
      var y0 = max(top, other.top);
      var y1 = min(top + height, other.top + other.height);

      if (y0 <= y1) {
        return R(x0, y0, x1 - x0, y1 - y0);
      }
    }
    return null;
  }

  /// Returns true if `this` intersects [other].
  bool intersects(R other) {
    return (left <= other.left + other.width &&
        other.left <= left + width &&
        top <= other.top + other.height &&
        other.top <= top + height);
  }

  @override
  R get boundingBox => this;

  /// Tests whether `this` entirely contains [another].
  bool containsRectangle(R another) {
    return left <= another.left &&
        left + width >= another.left + another.width &&
        top <= another.top &&
        top + height >= another.top + another.height;
  }

  /// Tests whether [another] is inside or along the edges of `this`.
  @override
  bool containsPoint(P another) {
    return another.x >= left &&
        another.x <= left + width &&
        another.y >= top &&
        another.y <= top + height;
  }

  P get topLeft => P(left, top);

  P get topRight => P(left + width, top);

  P get bottomRight => P(left + width, top + height);

  P get bottomLeft => P(left, top + height);
  
  P get center => P(left + width / 2, top + height / 2);
  
  P get topCenter => P(left + width / 2, top);

  P get bottomCenter => P(left + width / 2, bottom);

  P get leftCenter => P(left, top + height / 2);

  P get rightCenter => P(right, top + height / 2);

  R shift(P offset) => R(left + offset.x, top + offset.y, width, height);

  R inflate(double delta) =>
      R(left - delta, top - delta, width + 2 * delta, height + 2 * delta);

  R deflate(double delta) =>
      R(left + delta, top + delta, width - 2 * delta, height - 2 * delta);

  /// Returns a new rectangle which completely contains `this` and [other].
  R include(R other) {
    var right = max(this.left + width, other.left + other.width);
    var bottom = max(this.top + height, other.top + other.height);

    var left = min(this.left, other.left);
    var top = min(this.top, other.top);

    return R(left, top, right - left, bottom - top);
  }

  R includePoint(double x, double y) => R(min(left, x), min(top, y),
      max(right, x) - min(left, x), max(bottom, y) - min(top, y));

  R includeX(double x) =>
      R.fromPoints(P(min(left, x), top), P(max(right, x), bottom));

  R includeY(double y) =>
      R.fromPoints(P(left, min(top, y)), P(right, max(bottom, y)));

  @override
  double get perimeter => 2 * (width + height);

  @override
  double get area => width * height;
}
