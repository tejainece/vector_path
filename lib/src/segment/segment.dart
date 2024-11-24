import 'package:vector_path/src/primitive/primitive.dart';
import 'package:vector_path/src/segment/line.dart';

export 'arc.dart';
export 'circular.dart';
export 'cubic.dart';
export 'line.dart';
export 'quadratic.dart';

export '../primitive/primitive.dart';

abstract class Segment {
  P get p1;

  set p1(P value);

  P get p2;

  set p2(P value);

  LineSegment get p1Tangent;

  LineSegment get p2Tangent;
}