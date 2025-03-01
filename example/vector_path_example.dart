import 'package:ramanujan/ramanujan.dart';

void main() {
  // print(-268.0.toRadian.clampAngle0(pi).toDegree);
  /*print((-90).toRadian.clampAngle0(pi).toDegree);
  print((-270).toRadian.clampAngle0(pi).toDegree);
  print((-271).toRadian.clampAngle0(pi).toDegree);
  print((-269).toRadian.clampAngle0(pi).toDegree);*/

  final a = Degree(60).toRadian;
  final b = Degree(-30).toRadian;
  print('$a $b ${b.unclamped} ${(a.value - b.value).toDegree}');
  final diff = a - b;
  print('$a $b ${diff.toDegree.value}');
}
