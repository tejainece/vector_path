import 'package:vector_path/src/segment/segment.dart';
import 'package:vector_path/src/vector_curve.dart';

SegmentTransformer cardinalSmoother({double tension = 2}) {
  return (P c1, Segment segment, P c2) {
    final p1Prime = (segment.p2 - c1) / tension;
    final p2Prime = (c2 - segment.p1) / tension;

    return [
      CubicSegment(segment.p1, segment.p2, segment.p1 + p1Prime / 3,
          segment.p2 - p2Prime / 3),
    ];
  };
}
