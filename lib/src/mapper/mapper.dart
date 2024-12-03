import 'package:vector_path/src/segment/segment.dart';

export 'bifurcator.dart';
export 'cardinal.dart';
export 'catmull_rom.dart';

typedef SegmentMapper = List<Segment> Function(
    P prev, Segment cur, P next);