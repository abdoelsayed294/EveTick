import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/core/widgets/outline_app_text_button.dart';
import 'package:evetick/features/location/logic/cubit/location_cubit.dart';
import 'package:evetick/features/location/presentation/widgets/location_listener.dart';
import 'package:evetick/features/location/presentation/widgets/manual_location_bottom_sheet.dart';
import 'package:evetick/features/location/presentation/widgets/where_are_you.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetLocation extends StatefulWidget {
  const SetLocation({super.key});

  @override
  State<SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
  @override
  void initState() {
    context.read<LocationCubit>().loadGovernorates();
    super.initState();
  }

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
                onPressed: () async {
                  await context.read<LocationCubit>().skipLocation();
                },
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
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (bottomSheetContext) {
                  return BlocProvider.value(
                    value: context.read<LocationCubit>(),
                    child: const ManualLocationBottomSheet(),
                  );
                },
              );
            },
            buttonHeight: 45.h,
          ),
          LocationListener(),
        ],
      ),
    );
  }
}
