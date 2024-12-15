import 'dart:math';
import 'dart:typed_data';

import 'package:vector_path/src/primitive/primitive.dart';

/// [ scaleX shearX translateX ]
/// [ shearY scaleY translateY ]
/// [    0     0        1      ]
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

  Affine2d scale(double sx, double sy) => Affine2d(
      scaleX: scaleX * sx,
      shearX: shearX * sy,
      scaleY: scaleY * sy,
      shearY: shearY * sx,
      translateX: translateX,
      translateY: translateY);

  Affine2d translate(double tx, double ty) => Affine2d(
        scaleX: scaleX,
        scaleY: scaleY,
        shearX: shearX,
        shearY: shearY,
        translateX: scaleX * tx + shearX * ty + translateX,
        translateY: shearY * tx + scaleY * ty + translateY,
      );

  Affine2d rotate(double angle) => Affine2d(
      scaleX: scaleX * cos(angle) + shearX * sin(angle),
      shearX: scaleX * -sin(angle) + shearX * cos(angle),
      shearY: shearY * cos(angle) + scaleY * sin(angle),
      scaleY: shearY * -sin(angle) + scaleY * cos(angle),
      translateX: translateX,
      translateY: translateY);

  Affine2d invert() {
    throw UnimplementedError();
    // TODO
    return Affine2d(
        // TODO
        );
  }

  Affine2d withTranslate(double tx, double ty) {
    return Affine2d(
        scaleX: scaleX,
        scaleY: scaleY,
        shearX: shearX,
        shearY: shearY,
        translateX: tx,
        translateY: ty);
  }

  /// Applies the affine transformation to the [point].
  P apply(P point) => point.transform(this);

  Float64List get matrix => Float64List.fromList([
        scaleX, shearX, translateX, // row1
        shearY, scaleY, translateY, // row2
        0, 0, 1, // row3
      ]);

  Float64List get matrixColMajor => Float64List.fromList([
        scaleX, shearY, 0, // row1
        shearX, scaleY, 0, // row2
        translateX, translateY, 1, // row3
      ]);

  Float64List get matrix4d => Float64List.fromList([
        scaleX, shearX, translateX, 0, // row1
        shearY, scaleY, translateY, 0, // row2
        0, 0, 1, 0, // row3
        0, 0, 0, 1, // row4
      ]);

  Affine2d operator *(value) {
    if (value is num) {
      return Affine2d(
        scaleX: scaleX * value,
        shearX: shearX * value,
        scaleY: scaleY * value,
        shearY: shearY * value,
        translateX: translateX * value,
        translateY: translateY * value,
      );
    } else if (value is Affine2d) {
      return Affine2d(
        scaleX: scaleX * value.scaleX + shearX * value.shearY,
        shearX: scaleX * value.shearX + shearX * value.scaleY,
        translateX:
            scaleX * value.translateX + shearX * value.translateY + translateX,
        shearY: shearY * value.scaleX + scaleY * value.shearY,
        scaleY: shearY * value.shearX + scaleY * value.scaleY,
        translateY:
            shearY * value.translateX + scaleY * value.translateY + translateY,
      );
    }
    throw UnsupportedError(
        'Type ${value.runtimeType} not supported for matrix multiplication');
  }

  @override
  String toString() {
    final sb = StringBuffer();
    sb.write('[ $scaleX $shearX $translateX ]\n');
    sb.write('[ $shearY $scaleY $translateY ]\n');
    sb.write('[ 0 0 1 ]');
    return sb.toString();
  }
}

extension PointAffineExt on P {
  P transform(Affine2d affine) => P(
      affine.scaleX * x + affine.shearX * y + affine.translateX,
      affine.shearY * x + affine.scaleY * y + affine.translateY);
}
