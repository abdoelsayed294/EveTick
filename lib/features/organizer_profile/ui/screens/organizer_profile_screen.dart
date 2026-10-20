import 'package:evetick/features/organizer_profile/ui/widgets/organizer_profile_bloc_builder.dart';
import 'package:flutter/material.dart';

class OrganizerProfileScreen extends StatelessWidget {
  const OrganizerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: OrganizerProfileBlocBuilder());
  }
}
