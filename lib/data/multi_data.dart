
export 'package:common_tool_box/data/multi_data.dart';

class PairData<T1,T2> {

  PairData(this.first, this.second);  

  final T1 first;
  final T2 second;

}

class ThreeData<T1, T2, T3> extends PairData<T1, T2> {

  ThreeData(super.first, super.second, this.third);

  final T3 third;

}
