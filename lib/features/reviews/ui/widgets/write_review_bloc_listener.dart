import 'package:evetick/features/auth/ui/widgets/error_banner.dart';
import 'package:evetick/features/reviews/logic/write_review_cubit/write_review_cubit.dart';
import 'package:evetick/features/reviews/logic/write_review_cubit/write_review_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Success: thank-you message and close the screen (returns `true` so the
/// reviews list refreshes). Error: banner above the form.
class WriteReviewBlocListener extends StatelessWidget {
  const WriteReviewBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WriteReviewCubit, WriteReviewState<String>>(
      listenWhen: (previous, current) => current is WriteReviewSuccess<String>,
      listener: (context, state) {
        state.whenOrNull(
          success: (data) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Thanks! Your review was posted'),
                  backgroundColor: Colors.green,
                ),
              );
            Navigator.of(context).pop(true);
          },
        );
      },
      builder: (context, state) {
        final errorMessage = state.whenOrNull(error: (error) => error);
        return ErrorBanner(message: errorMessage);
      },
    );
  }
}
