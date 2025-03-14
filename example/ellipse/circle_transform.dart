import 'dart:math';

import 'package:vector_math/vector_math.dart';
import 'package:ramanujan/ramanujan.dart';

void main() {
  final radii = P(100, 50);
  final center = P(100, 100);
  final rotation = pi / 3;
  final ellipse = Ellipse(radii, center: center, rotation: rotation);
  final uct = ellipse.unitCircleTransform;
  print(uct);
  final iuct = ellipse.inverseUnitCircleTransform;
  final res = uct * iuct;
  print(res);

  final angle = pi / 3;
  final p = P.onCircle(angle);
  print(p);
  final p1 = uct.apply(p);
  print(p1);
  final p2 = iuct.apply(p1);
  print(p2);
  print(p2.angle);

  /*final uctm = Matrix3(uct.scaleX, uct.shearY, 0, uct.shearX, uct.scaleY, 0,
      uct.translateX, uct.translateY, 1);
  final iuctm = Matrix3.copy(uctm)..invert();
  print('------');
  print(iuctm.pretty);
  final iuct2 = iuctm.affine;
  print(iuct2);
  print(uct * iuct2);
  print(iuct2.apply(p1));
  print('------');*/
}

extension on Affine2d {
  Matrix3 get matrix3 {
    return Matrix3(
        scaleX, shearY, 0, shearX, scaleY, 0, translateX, translateY, 1);
  }
}

extension on Matrix3 {
  String get pretty {
    return '''[${this[0]}, ${this[3]}, ${this[6]}
[${this[1]}, ${this[4]}, ${this[7]}
[${this[2]}, ${this[5]}, ${this[8]}]''';
  }

  Affine2d get affine {
    // TODO check that this is affine
    if (!this[2].equals(0)) throw Exception('(2,0) != 0');
    if (!this[5].equals(0)) throw Exception('(2,1) != 0');
    if (!this[8].equals(1)) throw Exception('(2,2) != 1');
    return Affine2d(
        scaleX: this[0],
        shearX: this[3],
        scaleY: this[4],
        shearY: this[1],
        translateX: this[6],
        translateY: this[7]);
  }
}
