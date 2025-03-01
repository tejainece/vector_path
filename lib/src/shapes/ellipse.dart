import 'dart:math';

import 'package:ramanujan/ramanujan.dart';

/// ((x-h)*cosθ + (y-k)*sinθ)^2/r1^2 + ((x-h)*sinθ - (y-k)^cosθ)*2/r2^2 - 1 = 0
class Ellipse implements ClosedShape {
  final P center;

  final P radii;

  final double rotation;

  Ellipse(this.radii, {this.center = origin, this.rotation = 0});

  factory Ellipse.fromR(R rect) =>
      Ellipse(P(rect.width / 2, rect.height / 2), center: rect.center);

  factory Ellipse.fromSvgParameters(P p1, P p2, P radii,
      {double rotation = 0, bool clockwise = false, bool largeArc = false}) {
    final d = P((p1.x - p2.x) / 2, (p1.y - p2.y) / 2);
    if (d.isEqual(origin)) {
      // Degenerate ellipse
      P center = P(-radii.x, 0).rotate(pi + rotation) + p1;
      return Ellipse(radii, center: center, rotation: rotation);
    }
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
  late final Affine2d unitCircleTransform =
      Affine2d(translateX: center.x, translateY: center.y)
          .rotate(rotation)
          .scale(radii.x, radii.y);

  /// Returns the affine transformation that maps this ellipse to the unit circle
  late final Affine2d inverseUnitCircleTransform =
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
    return unitCircleTransform.apply(P.onCircle(angle));
  }

  Radian angleOfPoint(P point) {
    final inverseUnitCircleTransform = this.inverseUnitCircleTransform;
    final transformedPoint = inverseUnitCircleTransform.apply(point);
    return transformedPoint.angle;
  }

  double tAtPoint(P point) => ilerp(point);

  double tAtAngle(double radians) {
    radians = Radian(radians).value;
    int n = radians ~/ (pi / 2);
    double remainder = radians - n * (pi / 2);

    double ret = 1 / n;
    if (n.isOdd) {
      remainder = pi / 2 - remainder;
    }
    ret += atan(radii.y * tan(remainder) / radii.x);
    return ret;
  }

  double angleAtT(double t) {
    t = Clamp.unit.clamp(t);
    int n = t ~/ 0.25;
    double remainder = t - n * 0.25;

    double ret = 0;
    if (n != 0) {
      ret = n * 2 * pi;
    }
    if (n.isOdd) {
      remainder = 0.25 - remainder;
    }
    ret += atan(radii.y * tan(remainder * pi / 2) / radii.x);
    return ret;
  }

  P lerp(double t) {
    t = Clamp.unit.clamp(t);
    t = 4 * t * (pi / 2);
    var ret = P(radii.x * cos(t), radii.y * sin(t));
    return ret.transform(
        Affine2d(translateX: center.x, translateY: center.y).rotate(rotation));
  }

  P lerpBetweenPoints(P p1, P p2, double t, {bool clockwise = false}) {
    final t1 = ilerp(p1);
    final t2 = ilerp(p2);
    return lerpBetween(t1, t2, t, clockwise: clockwise);
  }

  P lerpBetween(double t1, double t2, double t, {bool clockwise = false}) {
    final forT = Clamp.unit.lerp(t1, t2, t, clockwise: clockwise);
    return lerp(forT);
  }

  double ilerp(P point) {
    final angle = angleOfPoint(point);
    return angle.value / (2 * pi);
  }

  double ilerpBetween(P p1, P p2, P p, {bool clockwise = false}) {
    final t1 = ilerp(p1);
    final t2 = ilerp(p2);
    final t = ilerp(p);
    return Clamp.unit.ilerp(t1, t2, t, clockwise: clockwise);
  }

  bool isEqual(Ellipse other, [double epsilon = 1e-3]) {
    if (!center.isEqual(other.center, epsilon)) return false;
    final a = canonicalForm();
    final b = other.canonicalForm();
    if (!a.radii.isEqual(b.radii, epsilon)) return false;
    if (!a.rotation.equals(b.rotation, epsilon)) return false;
    return true;
  }

  late final double h = () {
    final diff = radii.x - radii.y;
    final sum = radii.x + radii.y;
    return (diff * diff) / (sum * sum);
  }();

  late final double perimeterApprox = () {
    return pi * (radii.x + radii.y) * (1 + 3 * h / (10 + sqrt(4 - 3 * h)));
  }();

  late final double quart = () {
    final t = atan(radii.y * tan(pi / 2) / radii.x);
    return radii.x *
        integralRiemannSums(0, t, _ellipticIntegrand(m), t * radii.x * 20);
  }();

  @override
  late final double perimeter = 4 * quart;

  double arcLengthAtT(double t) {
    t = Clamp.unit.clamp(t);
    int n = t ~/ 0.25;
    double remainder = t - n * 0.25;

    double ret = 0;
    if (n != 0) {
      ret = n * quart;
    }
    if (n.isOdd) {
      remainder = 0.25 - remainder;
    }
    final tmp = radii.x *
        integralRiemannSums(0, remainder * 4 * pi / 2, _ellipticIntegrand(m),
            remainder * 4 * radii.x * 20);
    if (n.isOdd) {
      ret += quart - tmp;
    } else {
      ret += tmp;
    }
    return ret;
  }

  double arcLengthBetweenT(double t1, double t2, {bool clockwise = false}) {
    final startLen = arcLengthAtT(t1);
    final endLen = arcLengthAtT(t2);
    if (clockwise) {
      if (startLen > endLen) {
        return startLen - endLen;
      }
      return perimeter - (endLen - startLen);
    }
    if (endLen > startLen) {
      return endLen - startLen;
    }
    return perimeter - (startLen - endLen);
  }

  double arcLengthAtAngle(double radians) {
    radians = Radian(radians).value;
    final t = tAtAngle(radians);
    return arcLengthAtT(t);
  }

  double arcLengthBetweenAngles(Radian start, Radian end,
      {bool clockwise = false}) {
    return arcLengthBetweenT(tAtAngle(start.value), tAtAngle(end.value),
        clockwise: clockwise);
  }

  double arcLengthAtPoint(P point) => arcLengthAtT(ilerp(point));

  double arcLengthBetweenPoints(P p1, P p2, {bool clockwise = false}) =>
      arcLengthBetweenT(ilerp(p1), ilerp(p2), clockwise: clockwise);

  double get m => 1 - (radii.y * radii.y) / (radii.x * radii.x);

  @override
  double get area => pi * radii.x * radii.y;

  LineSegment tangentAtT(double t) {
    // TODO
    throw UnimplementedError();
  }

  LineSegment tangentAtAngle(double radians) {
    // TODO
    throw UnimplementedError();
  }

  LineSegment tangentAtPoint(P point) {
    // TODO
    throw UnimplementedError();
  }

  ArcSegment arc(Radian start, Radian end, {bool? clockwise}) {
    clockwise ??= end < start;
    final largeArc = arcLengthBetweenAngles(start, end, clockwise: clockwise) >
        perimeter / 2;
    return ArcSegment(pointAtAngle(start.value), pointAtAngle(end.value), radii,
        rotation: rotation, largeArc: largeArc, clockwise: clockwise);
  }

  @override
  R get boundingBox {
    final xs = xBounds();
    final ys = yBounds();
    return R.fromPoints(P(xs.$1, ys.$1), P(xs.$2, ys.$2));
  }

  (double, double) xBounds() {
    final axis =
        P(unitCircleTransform.elementAt(0), unitCircleTransform.elementAt(1));
    var r = axis.length;
    var mid = unitCircleTransform.elementAt(2);
    return (
      mid - r,
      mid + r,
    );
  }

  (({Radian angle, double value}), ({Radian angle, double value}))
      xBoundsWithAngle() {
    final axis =
        P(unitCircleTransform.elementAt(0), unitCircleTransform.elementAt(1));
    var r = axis.length;
    var mid = unitCircleTransform.elementAt(2);
    final angle = axis.angle;
    return (
      (angle: angle, value: mid + r),
      (angle: angle + pi, value: mid - r)
    );
  }

  (double, double) yBounds() {
    final axis =
        P(unitCircleTransform.elementAt(3), unitCircleTransform.elementAt(4));
    var r = axis.length;
    var mid = unitCircleTransform.elementAt(5);
    return (
      mid - r,
      mid + r,
    );
  }

  (({Radian angle, double value}), ({Radian angle, double value}))
      yBoundsWithAngle() {
    final axis =
        P(unitCircleTransform.elementAt(3), unitCircleTransform.elementAt(4));
    var r = axis.length;
    var mid = unitCircleTransform.elementAt(5);
    final angle = axis.angle;
    return (
      (angle: angle, value: mid + r),
      (angle: angle + pi, value: mid - r),
    );
  }

  static double ellepticE(double t, double m) {
    return integralRiemannSums(0, t, _ellipticIntegrand(m), 100);
  }

  static double Function(num t) _ellipticIntegrand(double m) {
    return (t) => sqrt(1 - pow(sin(t), 2) * m);
  }

  late final costh = cos(rotation);

  late final sinth = sin(rotation);

  @override
  bool containsPoint(P point) {
    final dp = point - center;
    double x2 = dp.x * costh + dp.y * sinth;
    x2 *= x2;
    double y2 = dp.x * sinth - dp.y * costh;
    y2 *= y2;
    double rx2 = radii.x;
    rx2 *= rx2;
    double ry2 = radii.y;
    ry2 *= ry2;
    return x2 / rx2 + y2 / ry2 <= 1;
  }

  @override
  bool isPointOn(P point) {
    final ys = evalY(point.x);
    if (ys.isEmpty) return false;
    return ys.any((y) => (y - point.y).abs() < 1e-6);
  }

  List<double> evalX(double y) {
    final y2 = y * y;
    final r1 = radii.x;
    final r12 = r1 * r1;
    final r2 = radii.y;
    final r22 = r2 * r2;
    final h = center.x;
    final k = center.y;
    final k2 = k * k;
    final sinth2 = sinth * sinth;
    final sinth4 = sinth2 * sinth2;
    final costh2 = costh * costh;
    final costh4 = costh2 * costh2;
    final x1 = costh2 * h * r22 / ((costh2 * r22 + sinth2 * r12)) -
        costh * y * sinth * r22 / ((costh2 * r22 + sinth2 * r12)) +
        costh * k * sinth * r22 / ((costh2 * r22 + sinth2 * r12)) +
        sinth2 * h * r12 / ((costh2 * r22 + sinth2 * r12)) +
        sinth * y * costh * r12 / ((costh2 * r22 + sinth2 * r12)) -
        sinth * k * costh * r12 / ((costh2 * r22 + sinth2 * r12)) +
        r2 *
            r1 *
            pow(
                -2 * costh2 * y2 * sinth2 +
                    4 * costh2 * y * sinth2 * k -
                    2 * costh2 * k2 * sinth2 +
                    costh2 * r22 -
                    costh4 * y2 +
                    2 * costh4 * y * k -
                    costh4 * k2 +
                    sinth2 * r12 -
                    sinth4 * y2 +
                    2 * sinth4 * y * k -
                    sinth4 * k2,
                0.5) /
            ((costh2 * r22 + sinth2 * r12));
    final ret = <double>[if (!x1.isNaN) x1];
    final x2 = costh2 * h * r22 / ((costh2 * r22 + sinth2 * r12)) -
        costh * y * sinth * r22 / ((costh2 * r22 + sinth2 * r12)) +
        costh * k * sinth * r22 / ((costh2 * r22 + sinth2 * r12)) +
        sinth2 * h * r12 / ((costh2 * r22 + sinth2 * r12)) +
        sinth * y * costh * r12 / ((costh2 * r22 + sinth2 * r12)) -
        sinth * k * costh * r12 / ((costh2 * r22 + sinth2 * r12)) -
        r2 *
            r1 *
            pow(
                -2 * costh2 * y2 * sinth2 +
                    4 * costh2 * y * sinth2 * k -
                    2 * costh2 * k2 * sinth2 +
                    costh2 * r22 -
                    costh4 * y2 +
                    2 * costh4 * y * k -
                    costh4 * k2 +
                    sinth2 * r12 -
                    sinth4 * y2 +
                    2 * sinth4 * y * k -
                    sinth4 * k2,
                0.5) /
            ((costh2 * r22 + sinth2 * r12));
    if (!x2.isNaN) {
      if (ret.every((v) => (v - x2).abs() > 1e-6)) ret.add(x2);
    }
    return ret;
  }

  List<double> evalY(double x) {
    final x2 = x * x;
    final r1 = radii.x;
    final r12 = r1 * r1;
    final r2 = radii.y;
    final r22 = r2 * r2;
    final h = center.x;
    final h2 = h * h;
    final k = center.y;
    final sinth2 = sinth * sinth;
    final sinth4 = sinth2 * sinth2;
    final costh2 = costh * costh;
    final costh4 = costh2 * costh2;
    final y1 = -x * costh * sinth * r22 / ((sinth2 * r22 + costh2 * r12)) +
        h * costh * sinth * r22 / ((sinth2 * r22 + costh2 * r12)) +
        sinth2 * k * r22 / ((sinth2 * r22 + costh2 * r12)) +
        x * sinth * costh * r12 / ((sinth2 * r22 + costh2 * r12)) -
        h * sinth * costh * r12 / ((sinth2 * r22 + costh2 * r12)) +
        costh2 * k * r12 / ((sinth2 * r22 + costh2 * r12)) +
        r2 *
            r1 *
            pow(
                -2 * x2 * costh2 * sinth2 +
                    4 * x * costh2 * sinth2 * h -
                    2 * h2 * costh2 * sinth2 +
                    sinth2 * r22 -
                    sinth4 * x2 +
                    2 * sinth4 * x * h -
                    sinth4 * h2 +
                    costh2 * r12 -
                    costh4 * x2 +
                    2 * costh4 * x * h -
                    costh4 * h2,
                0.5) /
            ((sinth2 * r22 + costh2 * r12));
    final ret = [if (!y1.isNaN) y1];
    final y2 = -x * costh * sinth * r22 / ((sinth2 * r22 + costh2 * r12)) +
        h * costh * sinth * r22 / ((sinth2 * r22 + costh2 * r12)) +
        sinth2 * k * r22 / ((sinth2 * r22 + costh2 * r12)) +
        x * sinth * costh * r12 / ((sinth2 * r22 + costh2 * r12)) -
        h * sinth * costh * r12 / ((sinth2 * r22 + costh2 * r12)) +
        costh2 * k * r12 / ((sinth2 * r22 + costh2 * r12)) -
        r2 *
            r1 *
            pow(
                -2 * x2 * costh2 * sinth2 +
                    4 * x * costh2 * sinth2 * h -
                    2 * h2 * costh2 * sinth2 +
                    sinth2 * r22 -
                    sinth4 * x2 +
                    2 * sinth4 * x * h -
                    sinth4 * h2 +
                    costh2 * r12 -
                    costh4 * x2 +
                    2 * costh4 * x * h -
                    costh4 * h2,
                0.5) /
            ((sinth2 * r22 + costh2 * r12));
    if (!y2.isNaN) {
      if (ret.every((v) => (v - y2).abs() > 1e-6)) ret.add(y2);
    }
    return ret;
  }
}

typedef UnivariateIntegrand = double Function(num t);

double integralRiemannSums(num min, num max, UnivariateIntegrand func, num n) {
  double sum = 0;
  var dx = (max - min) / n;
  var currentX = min + dx / 2;
  for (var i = 0; i < n; i++) {
    var currentY = func(currentX);
    sum += dx * currentY;
    currentX += dx;
  }
  return sum;
}
