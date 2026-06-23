import 'package:evetick/core/routing/app_router.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:flutter/material.dart';
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
        return MaterialApp(
          title: 'EveTick',
          theme: ThemeData(
            primaryColor: ColorsManager.darkBlue,
            scaffoldBackgroundColor: ColorsManager.darkBlue,
          ),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: appRouter.generateRoute,
          initialRoute: Routes.appStartScreen,
        );
      },
    );
  }
}
