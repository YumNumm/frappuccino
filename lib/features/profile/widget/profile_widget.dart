import 'package:flutter/material.dart';
import 'package:frappuccino/core/supabase/model/db/profiles.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({required this.profile, super.key});

  final Profiles profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('id: ${profile.id}'),
            Text('name: ${profile.name}'),
            Text('email: ${profile.email}'),
            Text('createdAt: ${profile.createdAt}'),
            Text('comeAt: ${profile.comeAt}'),
            Text('leaveAt: ${profile.leaveAt}'),
          ],
        ),
      ),
    );
  }
}
