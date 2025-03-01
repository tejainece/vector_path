import 'package:ramanujan/ramanujan.dart';

SegmentMapper bifurcator([double t = 0.5]) =>
    (Segment segment) => segment.bifurcateAtInterval(t).toList();

SegmentMapper splitter([int count = 2]) =>
    (Segment segment) => segment.split(count);

extension VectorCurveBifurcationExt on VectorCurve {
  VectorCurve bifurcateSegments([double t = 0.5]) => expand(bifurcator(t));

  VectorCurve splitSegments([int count = 2]) => expand(splitter(count));
}
