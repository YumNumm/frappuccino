import 'package:frappuccino/core/supabase/model/function/get_profile.dart';
import 'package:frappuccino/core/supabase/service/supabase_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile.g.dart';

@Riverpod(keepAlive: true)
Future<GetProfile> getProfile(GetProfileRef ref) =>
    ref.read(frappuccinnoServiceProvider).profileService.getMyProfile();
