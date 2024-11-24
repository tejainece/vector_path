import 'dart:collection';

import 'segment/segment.dart';

typedef Smoother = void Function();

class VectorCurve {
  final List<Segment> _segments;

  VectorCurve._(this._segments);

  factory VectorCurve(List<Segment> segments) {
    return VectorCurve._([...segments]);
  }

  void smooth(Smoother smoother) {
    // TODO
  }

  late final Iterable<Segment> segments = UnmodifiableListView(_segments);

  bool get isEmpty => _segments.isEmpty;

  bool get isNotEmpty => _segments.isNotEmpty;

  bool isClosed() {
    if (isEmpty) return false;
    return _segments.first.p1 == _segments.last.p2;
  }

  // TODO split into sub paths
}

extension SegementsExt on Iterable<Segment> {
  String? validate() {
    if (isEmpty) return null;

    Segment prev = first;
    int index = 1;
    for (var segment in skip(1)) {
      if (prev.p2 != segment.p1) {
        return 'At index $index: ${prev.p2} != ${segment.p1}';
      }
      prev = segment;
      index++;
    }
    return null;
  }

  bool isClosed() {
    if (isEmpty) return false;
    return first.p1 == last.p2;
  }
}

class VectorLayer {
  final List<VectorCurve> curves;

  VectorLayer._(this.curves);

  factory VectorLayer(List<VectorCurve> curves) {
    return VectorLayer._([...curves]);
  }
}