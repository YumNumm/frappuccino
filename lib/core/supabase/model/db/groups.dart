import 'package:freezed_annotation/freezed_annotation.dart';

part 'groups.freezed.dart';
part 'groups.g.dart';

@freezed
class Groups with _$Groups {
  const factory Groups({
    required String uuid,
    @JsonKey(name: 'class') required String? className,
    required String name,
    required String description,
    required String? place,
    required GroupType type,
    required String? imageUrl,
  }) = _Groups;

  factory Groups.fromJson(Map<String, dynamic> json) => _$GroupsFromJson(json);
}

enum GroupType {
  @JsonValue('class')
  classes,
  committee,
  club,
  other,
  ;
}
