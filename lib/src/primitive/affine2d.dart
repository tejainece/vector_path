import 'dart:math';

import 'package:vector_path/src/primitive/primitive.dart';

/// [ scaleX
class Affine2d {
  final double scaleX, shearY, shearX, scaleY, translateX, translateY;

  Affine2d(
      {this.scaleX = 1,
      this.shearX = 0,
      this.translateX = 0,
      this.scaleY = 1,
      this.shearY = 0,
      this.translateY = 0});

  factory Affine2d.scaler(double s) => Affine2d(scaleX: s, scaleY: s);

  factory Affine2d.rotator(double angle) => Affine2d(
        scaleX: cos(angle),
        shearX: -sin(angle),
        scaleY: cos(angle),
        shearY: sin(angle),
      );

  factory Affine2d.translator(double tx, double ty) =>
      Affine2d(translateX: tx, translateY: ty);

  Affine2d scale(double sx, double sy) => Affine2d(
      scaleX: scaleX * sx,
      shearX: shearX * sx,
      scaleY: scaleY * sy,
      shearY: shearY * sy,
      translateX: translateX,
      translateY: translateY);

  Affine2d translate(double tx, double ty) => Affine2d(
      scaleX: scaleX,
      scaleY: scaleY,
      shearX: shearX,
      shearY: shearY,
      translateX: translateX + tx,
      translateY: translateY + ty);

  Affine2d rotate(double angle) => Affine2d(
      scaleX: scaleX * cos(angle) + shearX * sin(angle),
      shearX: scaleX * -sin(angle) + shearX * cos(angle),
      shearY: shearY * cos(angle) + scaleY * sin(angle),
      scaleY: shearY * -sin(angle) + scaleY * cos(angle),
      translateX: translateX,
      translateY: translateY);

  Affine2d invert() {
    // TODO
    throw UnimplementedError();
  }

  /// Applies the affine transformation to the [point].
  P apply(P point) => point.affine(this);
}

extension PointAffineExt on P {
  P affine(Affine2d affine) => P(
      affine.scaleX * x + affine.shearX * y + affine.translateX,
      affine.shearY * x + affine.scaleY * y + affine.translateY);
}
