import 'package:frappuccino/core/supabase/model/db/groups.dart';
import 'package:frappuccino/core/supabase/model/db/profiles.dart';
import 'package:frappuccino/core/supabase/model/db/reservation_slots.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_profile.freezed.dart';
part 'get_profile.g.dart';

@freezed
class GetProfile with _$GetProfile {
  const factory GetProfile({
    required Profiles profile,
    required List<ReservationSlots> reservations,
    required List<Groups> groups,
  }) = _GetProfile;

  factory GetProfile.fromJson(Map<String, dynamic> json) =>
      _$GetProfileFromJson(json);
}
