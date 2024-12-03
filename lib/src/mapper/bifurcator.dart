import 'package:vector_path/vector_path.dart';

SegmentMapper bifurcator([double t = 0.5]) =>
    (P c1, Segment segment, P c2) => segment.bifurcateAtInterval(t).toList();

SegmentMapper splitter([int count = 2]) =>
    (P c1, Segment segment, P c2) => segment.split(count);

extension VectorCurveBifurcationExt on VectorCurve {
  VectorCurve bifurcateSegments([double t = 0.5]) => map(bifurcator(t));

  VectorCurve splitSegments([int count = 2]) => map(splitter(count));
}
