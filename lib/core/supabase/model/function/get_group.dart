import 'package:frappuccino/core/supabase/model/db/groups.dart';
import 'package:frappuccino/core/supabase/model/db/reservation_slots.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_group.freezed.dart';
part 'get_group.g.dart';

@freezed
class GetGroup with _$GetGroup {
  const factory GetGroup({
    required Groups group,
    required List<ReservationSlots> slots,
  }) = _GetGroup;

  factory GetGroup.fromJson(Map<String, dynamic> json) =>
      _$GetGroupFromJson(json);
}
