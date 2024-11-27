import 'dart:collection';

import 'segment/segment.dart';

typedef SegmentTransformer = List<Segment> Function(
    P prev, Segment cur, P next);

class VectorCurve {
  final List<Segment> _segments;

  VectorCurve._(this._segments);

  factory VectorCurve(Iterable<Segment> segments) {
    return VectorCurve._(List.from(segments));
  }

  void smooth(SegmentTransformer smoother) {
    // TODO
  }

  late final Iterable<Segment> segments = UnmodifiableListView(_segments);

  bool get isEmpty => _segments.isEmpty;

  bool get isNotEmpty => _segments.isNotEmpty;

  bool isClosed() => _segments.isClosed();

  VectorCurve transform(SegmentTransformer smoother,
          {P? controlStart, P? controlEnd}) =>
      VectorCurve(_segments.transform(smoother,
          controlStart: controlStart, controlEnd: controlEnd));

// TODO split into sub paths
}

extension SegementsExt on List<Segment> {
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

  VectorCurve toCurve() => VectorCurve(this);

  List<Segment> transform(SegmentTransformer smoother,
      {P? controlStart, P? controlEnd}) {
    if (length < 2) return toList();

    final ret = <Segment>[];
    P cp1 = first.p1;
    if (controlStart != null) {
      cp1 = controlStart;
    }

    for (int i = 0; i < length - 1; i++) {
      final cur = this[i];
      final next = this[i + 1];
      ret.addAll(smoother(cp1, cur, next.p2));
      cp1 = cur.p1;
    }
    ret.addAll(smoother(cp1, last, controlEnd ?? last.p2));
    return ret;
  }
}
