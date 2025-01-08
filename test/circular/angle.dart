import 'dart:math';

import 'package:test/test.dart';
import 'package:vector_path/vector_path.dart';

class _CircularArcAngleCase {
  final Radian startAngle, endAngle, angle;

  const _CircularArcAngleCase(this.startAngle, this.endAngle, this.angle);

  static List<_CircularArcAngleCase> cases = [
    _CircularArcAngleCase(Radian(0), Radian(pi / 2), Radian(pi / 2)),
    _CircularArcAngleCase(Radian(pi / 6), Radian(0), Radian(pi / 6)),
    _CircularArcAngleCase(Radian(pi / 2), Radian(3 * pi / 2), Radian(pi)),
    _CircularArcAngleCase(Radian(3 * pi / 2), Radian(pi / 2), Radian(pi)),
    _CircularArcAngleCase(Radian(0), Radian(3 * pi / 2), Radian(3 * pi / 2)),
    _CircularArcAngleCase(Radian(3 * pi / 2), Radian(0), Radian(3 * pi / 2)),
    _CircularArcAngleCase(
        Radian(pi + 0.1), Radian(2 * pi - 0.1), Radian(pi - 0.2)),
  ];

  bool get clockwise => endAngle > startAngle;

  CircularArcSegment get arc => CircularArcSegment(
      P.onCircle(startAngle.value), P.onCircle(endAngle.value), 1,
      clockwise: clockwise);
}

void main() {
  group('CircularArc', () {
    test('angle', () {
      for (final test in _CircularArcAngleCase.cases) {
        expect(test.arc.angle, RadianEqualityMatcher(test.angle),
            reason:
                'testing angle; ${test.startAngle.toDegree} ${test.endAngle.toDegree}');
        expect(test.arc.startAngle, RadianEqualityMatcher(test.startAngle),
            reason:
                'testing startAngle; ${test.startAngle.toDegree} ${test.endAngle.toDegree}');
        expect(test.arc.endAngle, RadianEqualityMatcher(test.endAngle),
            reason:
                'testing endAngle; ${test.startAngle.toDegree} ${test.endAngle.toDegree}');
      }
    });
  });
}

class RadianEqualityMatcher extends Matcher {
  final Radian expected;
  final double epsilon;

  const RadianEqualityMatcher(this.expected, [this.epsilon = 1e-3]);

  @override
  Description describe(Description description) {
    return description.add('equals $expected with epsilon $epsilon');
  }

  @override
  bool matches(angle, Map<dynamic, dynamic> matchState) {
    if (angle is! Angle) return false;
    return angle.equals(angle, 1e-3);
  }
}
