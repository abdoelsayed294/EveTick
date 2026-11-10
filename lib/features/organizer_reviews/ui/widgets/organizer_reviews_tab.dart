import 'package:evetick/features/organizer_reviews/logic/organizer_reviews_cubit.dart';
import 'package:evetick/features/organizer_reviews/ui/widgets/organizer_reviews_bloc_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrganizerReviewsTab extends StatefulWidget {
  const OrganizerReviewsTab({super.key, required this.organizerId});

  final String organizerId;

  @override
  State<OrganizerReviewsTab> createState() => _OrganizerReviewsTabState();
}

class _OrganizerReviewsTabState extends State<OrganizerReviewsTab> {
  @override
  void initState() {
    super.initState();
    context.read<OrganizerReviewsCubit>().load(organizerId: widget.organizerId);
  }

  @override
  Widget build(BuildContext context) {
    return OrganizerReviewsBlocBuilder(organizerId: widget.organizerId);
  }
}
