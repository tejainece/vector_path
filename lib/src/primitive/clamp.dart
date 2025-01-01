import 'dart:math';

import 'angle.dart';

class Clamp {
  final double width;
  final bool center0;

  const Clamp(this.width, [this.center0 = false]);

  double get min => center0 ? -width / 2 : 0;

  double get max => center0 ? width / 2 : width;

  double clamp(double value) =>
      center0 ? value.clampAngle0(width) : value.clampAngle(width);

  @override
  bool operator ==(Object other) =>
      other is Clamp &&
      other.width.equals(other.width) &&
      other.center0 == center0;

  bool areValuesEqual(double a, double b, [double epsilon = 1e-3]) {
    a = clamp(a);
    b = clamp(b);
    double diff = (a - b).abs();
    double upper = (diff - width).abs();
    return diff < epsilon || upper < epsilon;
  }

  double lerp(double t1, double t2, double t, {bool clockwise = false}) {
    print('t1: $t1, t2: $t2, t: $t, clockwise: $clockwise');
    if (clockwise) {
      if (t1 < t2) {
        return clamp(t2 + (1 - t2 + t1) * t);
      }
      return t1 + (t2 - t1) * t;
    }
    if (t1 < t2) {
      return t1 + (t2 - t1) * t;
    }
    return clamp(t1 + (1 - t1 + t2) * t);
  }

  double ilerp(double t1, double t2, double t, {bool clockwise = false}) {
    if (clockwise) {
      if (t1 < t2) {
        return clamp(t1 - t) / clamp(t2 - t1);
      }
      return (t - t1) / (t2 - t1);
    }
    if (t1 < t2) {
      return (t - t1) / (t2 - t1);
    }
    return clamp(t - t1) / clamp(t2 - t1);
  }

  bool isBetweenCCW(double start, double end, double value) {
    start = clamp(start);
    end = clamp(end);
    value = clamp(value);
    if (areValuesEqual(start, end)) {
      return areValuesEqual(start, value);
    }
    if (start < end) {
      return value >= start && value <= end;
    }
    return value >= start || value <= end;
  }

  bool isBetweenCW(double start, double end, double value) {
    start = clamp(start);
    end = clamp(end);
    value = clamp(value);
    if (areValuesEqual(start, end)) {
      return areValuesEqual(start, value);
    }
    if (start > end) {
      return value >= end && value <= start;
    }
    return value >= end || value <= start;
  }

  @override
  int get hashCode => Object.hash(width, center0);

  static const Clamp unit = Clamp(1);

  static const Clamp radian = Clamp(2 * pi);

  static const Clamp radian0 = Clamp(2 * pi, true);

  static const Clamp degree = Clamp(360);

  static const Clamp degree0 = Clamp(360, true);
}
