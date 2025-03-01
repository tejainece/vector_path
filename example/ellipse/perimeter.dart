import 'dart:math';

import 'package:ramanujan/ramanujan.dart';

void main() {
  double a = 305;
  double b = 223;
  final ellipse = Ellipse(P(a, b), center: P(0, 0));

  print(ellipse.perimeter);
  print(ellipse.perimeterApprox);

  print(ellipse.arcLengthAtAngle(pi / 6));
  /*print(ellipse.arcLengthTo(pi / 3));
  print(ellipse.arcLengthTo(pi / 2));
  print(ellipse.arcLengthTo(pi / 2 + pi / 6));
  print(ellipse.arcLengthTo(pi / 2 + pi / 3));
  print(ellipse.arcLengthTo(pi));
  print(ellipse.arcLengthTo(pi + pi / 6));
  print(ellipse.arcLengthTo(pi + pi / 3));*/

  print(ellipse.arc(Radian(0), Radian(pi / 6)).soloSvg);
}
