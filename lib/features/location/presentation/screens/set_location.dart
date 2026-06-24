import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/core/widgets/outline_app_text_button.dart';
import 'package:evetick/features/location/logic/cubit/location_cubit.dart';
import 'package:evetick/features/location/presentation/widgets/location_listener.dart';
import 'package:evetick/features/location/presentation/widgets/where_are_you.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetLocation extends StatelessWidget {
  const SetLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.darkBlue,
      body: Column(
        children: [
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: SafeArea(
              child: TextButton(
                onPressed: () {},
                child: Text('skip', style: TextStyles.font16LightGrayRegular),
              ),
            ),
          ),
          verticalSpace(120),
          WhereAreYou(),
          verticalSpace(98),
          FilledAppTextButton(
            buttonText: 'Use Current Location',
            onPressed: () {
              context.read<LocationCubit>().getCurrentLocation();
            },
            buttonHeight: 45.h,
          ),
          verticalSpace(16),
          OutlineAppTextButton(
            buttonText: 'Select Manually',
            onPressed: () {},
            buttonHeight: 45.h,
          ),
          LocationListener(),
        ],
      ),
    );
  }
}
