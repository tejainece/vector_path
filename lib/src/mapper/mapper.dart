import 'package:vector_path/vector_path.dart';

export 'bifurcator.dart';
export 'cardinal.dart';
export 'catmull_rom.dart';

typedef SegmentMapperWithControls = List<Segment> Function(
    P prev, Segment cur, P next);

typedef SegmentMapper = List<Segment> Function(Segment segment);
