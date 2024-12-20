import 'package:calculess/calculess.dart';
import 'package:vector_path/vector_path.dart';

typedef Func = double Function(num t);

Func ellipticIntegrand(double m) {
  return (t) => sqrt(1 - pow(sin(t), 2) * m);
}

void main() {
  final double a = 3.05;
  final double b = 2.23;
  final double angle = 90.toRadian;
  ellipticIntegral(a, b, angle);
}

void ellipticIntegral(double a, double b, double angle) {
  final double t = atan(b * tan(angle) / a);
  print('t: $t');
  double m = 1 - (b * b) / (a * a);
  print('m: $m');
  final arcLength = a * Calc.integral(0, t, ellipticIntegrand(m), 30);
  print(arcLength);
  print(arcLength * 4);
}