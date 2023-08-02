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
    @JsonKey(fromJson: _reservationsFromJson)
    required List<ReservationSlots> reservations,
    @JsonKey(fromJson: _groupsFromJson)
    required List<Groups> groups,
  }) = _GetProfile;

  factory GetProfile.fromJson(Map<String, dynamic> json) =>
      _$GetProfileFromJson(json);
}

// reservationsFromJson
List<ReservationSlots> _reservationsFromJson(List<dynamic> json) {
  return json
      .where((element) => element != null)
      .map((e) => ReservationSlots.fromJson(e as Map<String, dynamic>))
      .toList();
}

List<Groups> _groupsFromJson(List<dynamic> json) {
  return json
      .where((element) => element != null)
      .map((e) => Groups.fromJson(e as Map<String, dynamic>))
      .toList();
}
