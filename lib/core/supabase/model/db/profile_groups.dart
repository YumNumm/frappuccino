import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_groups.freezed.dart';
part 'profile_groups.g.dart';

@freezed
class ProfileGroups with _$ProfileGroups {
  const factory ProfileGroups({
    required String groupId,
    required String userId,
  }) = _ProfileGroups;

  factory ProfileGroups.fromJson(Map<String, dynamic> json) =>
      _$ProfileGroupsFromJson(json);
}
