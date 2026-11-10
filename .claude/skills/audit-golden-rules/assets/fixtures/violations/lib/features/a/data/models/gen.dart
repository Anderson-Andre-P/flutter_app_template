import 'package:json_annotation/json_annotation.dart';
part 'gen.g.dart';

@JsonSerializable()
class Gen {
  @JsonKey(name: 'x')
  final int x = 0;
}
