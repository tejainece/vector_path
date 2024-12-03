import 'dart:math';

import 'package:vector_path/src/primitive/primitive.dart';
import 'package:vector_path/src/segment/line.dart';

export '../primitive/primitive.dart';
export 'arc.dart';
export 'circular.dart';
export 'cubic.dart';
export 'line.dart';
export 'quadratic.dart';

abstract class Segment {
  static List<Segment> rect(Rectangle<double> rect) => [
        LineSegment(rect.topLeft, rect.topRight),
        LineSegment(rect.topRight, rect.bottomRight),
        LineSegment(rect.bottomRight, rect.bottomLeft),
        LineSegment(rect.bottomLeft, rect.topLeft)
      ];

  P get p1;

  set p1(P value);

  P get p2;

  set p2(P value);

  LineSegment get p1Tangent;

  LineSegment get p2Tangent;

  LineSegment get line => LineSegment(p1, p2);

  double get length;

  P lerp(double t);

  double ilerp(P point);

  (Segment, Segment) bifurcateAtInterval(double t);

  List<Segment> split([int count = 2]) {
    final ret = <Segment>[];
    final step = 1.0 / count;
    Segment prev = this;
    for (int i = 0; i < count - 1; i++) {
      final t = step * (1 - step * i);
      print(t);
      final parts = prev.bifurcateAtInterval(t);
      prev = parts.$2;
      ret.add(parts.$1);
    }
    ret.add(prev);
    return ret;
  }
}
