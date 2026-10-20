import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/features/reviews/data/models/reviews_args_model.dart';
import 'package:evetick/features/reviews/data/models/reviews_data_model.dart';
import 'package:evetick/features/reviews/logic/reviews_cubit/reviews_cubit.dart';
import 'package:evetick/features/reviews/logic/reviews_cubit/reviews_state.dart';
import 'package:evetick/features/reviews/ui/widgets/reviews_content.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key, required this.args});

  final ReviewsArgs args;

  Future<void> _refresh(BuildContext context, {bool silent = true}) {
    return context.read<ReviewsCubit>().emitReviewsStates(
          eventId: args.eventId,
          silent: silent,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: context.colors.white),
        title: Text(
          l10n.reviewsTitle,
          style: TextStyles.font18WhiteBold(context),
        ),
      ),
      body: BlocBuilder<ReviewsCubit, ReviewsState<ReviewsData>>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error) => AppErrorView(
              message: error,
              onRetry: () => _refresh(context, silent: false),
            ),
            success: (data) => ReviewsContent(
              data: data,
              eventId: args.eventId,
              onRefresh: () => _refresh(context),
            ),
          );
        },
      ),
    );
  }
}
