import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/logic/theme_cubit.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/features/profile/ui/widgets/theme_tile.dart';

class ThemeBottomSheet extends StatefulWidget {
  const ThemeBottomSheet({super.key});

  @override
  State<ThemeBottomSheet> createState() => _ThemeBottomSheetState();
}

class _ThemeBottomSheetState extends State<ThemeBottomSheet> {
  ThemeMode selectedTheme = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    selectedTheme = context.read<ThemeCubit>().state.themeMode;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.brightness_6, color: ColorsManager.orange),
                  horizontalSpace(8),
                  Text(AppLocalizations.of(context)!.profileTheme, style: TextStyles.font18WhiteBold(context)),
                ],
              ),
              verticalSpace(32),
              RadioTheme(
                data: RadioThemeData(
                  fillColor: WidgetStatePropertyAll(ColorsManager.orange),
                ),
                child: RadioGroup<ThemeMode>(
                  groupValue: selectedTheme,
                  onChanged: (value) {
                    setState(() {
                      selectedTheme = value!;
                    });
                  },
                  child: Column(
                    children: [
                      ThemeTile(
                        title: AppLocalizations.of(context)!.profileThemeSystem,
                        value: ThemeMode.system,
                      ),
                      verticalSpace(8),
                      ThemeTile(
                        title: AppLocalizations.of(context)!.profileThemeLight,
                        value: ThemeMode.light,
                      ),
                      verticalSpace(8),
                      ThemeTile(
                        title: AppLocalizations.of(context)!.profileThemeDark,
                        value: ThemeMode.dark,
                      ),
                    ],
                  ),
                ),
              ),
              verticalSpace(40),
              FilledAppTextButton(
                buttonText: AppLocalizations.of(context)!.settingsApplySelection,
                onPressed: () async {
                  await context.read<ThemeCubit>().changeTheme(selectedTheme);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
