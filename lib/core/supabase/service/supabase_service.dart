import 'package:frappuccino/core/supabase/model/db/profiles.dart';
import 'package:frappuccino/core/supabase/model/function/get_group.dart';
import 'package:frappuccino/core/supabase/model/function/get_profile.dart';
import 'package:frappuccino/core/supabase/supabase_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

part 'supabase_service.g.dart';

@Riverpod(keepAlive: true)
FrappuccinnoService frappuccinnoService(FrappuccinnoServiceRef ref) =>
    FrappuccinnoService(ref.watch(supabaseClientProvider));

class FrappuccinnoService {
  FrappuccinnoService(this._client) : super() {
    profileService = ProfileService(_client);
    reservationService = ReservationService(_client);
    groupService = GroupService(_client);
  }
  final SupabaseClient _client;

  late final ProfileService profileService;
  late final ReservationService reservationService;
  late final GroupService groupService;
}

class ProfileService {
  ProfileService(this._client);
  final SupabaseClient _client;

  Future<Profiles> getProfile(String uuid) async {
    try {
      final res = await _client
          .from('profiles')
          .select<PostgrestMapResponse>()
          .eq('uuid', uuid);
      return Profiles.fromJson(res.data ?? {});
    } on Exception catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  Future<List<Profiles>> getProfiles({
    required int offset,
    required int limit,
  }) async {
    try {
      final res = await _client
          .from('profiles')
          .select<PostgrestListResponse>()
          .range(offset, offset + limit - 1);

      return res.data?.map(Profiles.fromJson).toList() ?? [];
    } on Exception catch (e) {
      throw Exception('Failed to get profiles: $e');
    }
  }

  Future<GetProfile> getMyProfile() async {
    final res = await _client.rpc('get_profile');
    try {
      return GetProfile.fromJson(res as Map<String, dynamic>);
    } on Exception {
      throw Exception('Failed to get profile');
    }
  }
}

class ReservationService {
  ReservationService(this._client);
  final SupabaseClient _client;

  Future<void> joinReservation(String slotId) async {
    final res =
        await _client.rpc('join_reservation', params: {'_slot_id': slotId});
    try {
      return res;
    } on PostgrestException catch (e) {
      throw Exception('枠の確保に失敗しました: ${e.message}, ${e.hint}');
    } on Exception catch (e) {
      throw Exception('枠の確保に失敗しました: $e');
    }
  }

  Future<void> leaveReservation(String slotId) async {
    try {
      await _client.rpc('leave_reservation', params: {'_slot_id': slotId});
    } on Exception catch (e) {
      throw Exception('枠の確保解除に失敗しました: $e');
    }
  }
}

class GroupService {
  GroupService(this._client);
  final SupabaseClient _client;

  Future<GetGroup> getGroup(String uuid) async {
    final res = await _client.rpc('get_group', params: {'_group_id': uuid});
    try {
      final data = (res as List<Map<String, dynamic>>).firstOrNull;
      if (data == null) {
        throw Exception('Failed to get group: $uuid, data[0] is null');
      }
      return GetGroup.fromJson(data);
    } on Exception {
      throw Exception('Failed to get group: $uuid');
    }
  }

  Future<List<GetGroup>> getGroups() async {
    final res = await _client.rpc('get_groups');
    try {
      final data = res as List<Map<String, dynamic>>;
      return data.map(GetGroup.fromJson).toList();
    } on Exception {
      throw Exception('Failed to get groups');
    }
  }
}
