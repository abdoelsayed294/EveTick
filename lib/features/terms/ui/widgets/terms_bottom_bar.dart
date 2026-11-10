import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/features/terms/data/models/terms_mode.dart';
import 'package:evetick/features/terms/logic/terms_cubit.dart';
import 'package:evetick/features/terms/logic/terms_state.dart';
import 'package:evetick/features/terms/ui/widgets/terms_accepted_banner.dart';
import 'package:evetick/features/terms/ui/widgets/terms_action_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsBottomBar extends StatelessWidget {
  final TermsMode mode;

  const TermsBottomBar({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: ColorsManager.orange.withOpacity(0.5)),
        ),
      ),
      child: mode == TermsMode.signup
          ? TermsActionBar(
              onDecline: () => Navigator.of(context).pop(false),
              onAgree: () => Navigator.of(context).pop(true),
            )
          : BlocBuilder<TermsCubit, TermsState>(
              builder: (context, state) {
                return switch (state) {
                  TermsLoading() || TermsSaving() => Center(
                    child: CircularProgressIndicator(
                      color: ColorsManager.orange,
                    ),
                  ),
                  TermsLoaded(:final acceptance) when acceptance.isUpToDate =>
                    TermsAcceptedBanner(acceptedAt: acceptance.acceptedAt),
                  _ => TermsActionBar(
                    onDecline: mode == TermsMode.firstLogin
                        ? () async {
                            await context.read<TermsCubit>().declineTerms();
                            if (context.mounted) {
                              context.pushReplacedNamed(Routes.appStartScreen);
                            }
                          }
                        : context.pop,
                    onAgree: () => context.read<TermsCubit>().acceptTerms(),
                  ),
                };
              },
            ),
    );
  }
}
