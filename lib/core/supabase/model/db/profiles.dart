import 'package:freezed_annotation/freezed_annotation.dart';

part 'profiles.freezed.dart';
part 'profiles.g.dart';

@freezed
class Profiles with _$Profiles {
  const factory Profiles({
    required String id,
    required String name,
    required String email,
    required UserType type,
    required DateTime createdAt,
    required DateTime? comeAt,
    required DateTime? leaveAt,
  }) = _Profiles;

  factory Profiles.fromJson(Map<String, dynamic> json) =>
      _$ProfilesFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum UserType {
  /// 管理者
  admin,

  /// グループ管理者
  groupAdmin,

  /// 学校関係者
  school,

  /// 受験生
  examinee,

  /// 一般
  general,
  ;
}
