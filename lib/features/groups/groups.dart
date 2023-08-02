import 'package:frappuccino/core/supabase/model/db/groups.dart';
import 'package:frappuccino/core/supabase/service/supabase_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'groups.g.dart';

@Riverpod(keepAlive: true)
Future<List<Groups>> groupsList(GroupsListRef ref) =>
    ref.read(frappuccinnoServiceProvider).groupService.getGroupList();
