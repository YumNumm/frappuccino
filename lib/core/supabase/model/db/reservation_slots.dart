import 'package:freezed_annotation/freezed_annotation.dart';

part 'reservation_slots.freezed.dart';
part 'reservation_slots.g.dart';

@freezed
class ReservationSlots with _$ReservationSlots {
  const factory ReservationSlots({
    required String id,
    required String groupId,
    required String? name,
    required int? maxCount,
    required ReservationType type,
    required int? price,
    required DateTime createdAt,
  }) = _ReservationSlots;

  factory ReservationSlots.fromJson(Map<String, dynamic> json) =>
      _$ReservationSlotsFromJson(json);
}

enum ReservationType {
  item,
  food,
  ;
}
