import 'package:evetick/core/routing/app_router.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/app_theme.dart';
import 'package:evetick/features/localization/logic/locale_cubit.dart';
import 'package:evetick/features/localization/logic/locale_state.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EvetickApp extends StatelessWidget {
  final AppRouter appRouter;
  const EvetickApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'EveTick',
              theme: AppTheme.darkTheme,
              debugShowCheckedModeBanner: false,
              onGenerateRoute: appRouter.generateRoute,
              initialRoute: Routes.appStartScreen,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: state.locale,
            );
          },
        );
      },
    );
  }
}
