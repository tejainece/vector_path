import 'dart:math';

import 'package:vector_path/src/primitive/angle.dart';
import 'package:vector_path/src/segment/line.dart';

export 'affine2d.dart';
export 'angle.dart';
export 'clamp.dart';

class P {
  final double x;
  final double y;

  const P(this.x, this.y);

  factory P.onCircle(double angle, [double radius = 1, P center = origin]) =>
      center + P(radius * cos(angle), radius * sin(angle));

  P operator -() => P(-x, -y);

  P operator +(other) {
    if (other is num) {
      return P(x + other, y + other);
    } else if (other is P) {
      return P(x + other.x, y + other.y);
    }
    throw ArgumentError('Unsupported type: ${other.runtimeType}');
  }

  P operator -(other) {
    if (other is num) {
      return P(x - other, y - other);
    } else if (other is P) {
      return P(x - other.x, y - other.y);
    }
    throw ArgumentError('Unsupported type: ${other.runtimeType}');
  }

  P operator *(other) {
    if (other is num) {
      return P(x * other, y * other);
    } else if (other is P) {
      return P(x * other.x, y * other.y);
    }
    throw ArgumentError('Unsupported type: ${other.runtimeType}');
  }

  P operator /(other) {
    if (other is num) {
      return P(x / other, y / other);
    } else if (other is P) {
      return P(x / other.x, y / other.y);
    }
    throw ArgumentError('Unsupported type: ${other.runtimeType}');
  }

  double get length => sqrt(x * x + y * y);

  /// Returns the distance between `this` and [other].
  /// ```dart
  /// var distanceTo = const P(0, 0).distanceTo(const P(0, 0)); // 0.0
  /// distanceTo = const P(0, 0).distanceTo(const P(10, 0)); // 10.0
  /// distanceTo = const P(0, 0).distanceTo(const P(0, -10)); // 10.0
  /// distanceTo = const P(-10, 0).distanceTo(const P(100, 0)); // 110.0
  /// ```
  double distanceTo(P other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }

  P rotate(double radians) => P(
      x * cos(radians) - y * sin(radians), x * sin(radians) + y * cos(radians));

  bool isEqual(P other, [double epsilon = 1e-3]) =>
      x.equals(other.x, epsilon) && y.equals(other.y, epsilon);

  @override
  bool operator ==(Object other) =>
      other is P && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x.hashCode, y.hashCode);

  LineSegment lineTo(P other) => LineSegment(this, other);

  LineSegment lineFrom(P other) => LineSegment(other, this);

  Radian get angle => Radian(atan2(y, x));

  double operator [](int index) {
    switch (index) {
      case 0:
        return x;
      case 1:
        return y;
      default:
        throw ArgumentError('Invalid index: $index');
    }
  }
}

const origin = P(0, 0);
