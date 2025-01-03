import 'dart:collection';

import 'package:vector_path/vector_path.dart';

export 'segments.dart';

class VectorCurve {
  final List<Segment> _segments;

  VectorCurve._(this._segments);

  factory VectorCurve(Iterable<Segment> segments) {
    return VectorCurve._(List.from(segments));
  }

  late final UnmodifiableListView<Segment> segments =
      UnmodifiableListView(_segments);

  int get numSegments => _segments.length;

  bool get isEmpty => _segments.isEmpty;

  bool get isNotEmpty => _segments.isNotEmpty;

  bool isClosed() => _segments.isClosed();

  VectorCurve expand(SegmentMapper mapper) =>
      VectorCurve(_segments.expand(mapper));

  VectorCurve expandWithControls(SegmentMapperWithControls mapper,
      {P? controlStart, P? controlEnd}) {
    final newSegments = _segments.expandWithControls(mapper,
        controlStart: controlStart, controlEnd: controlEnd);
    return VectorCurve(newSegments);
  }

// TODO split into sub paths
}
