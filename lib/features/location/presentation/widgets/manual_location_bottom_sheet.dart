import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/features/location/logic/cubit/location_cubit.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManualLocationBottomSheet extends StatefulWidget {
  const ManualLocationBottomSheet({super.key});

  @override
  State<ManualLocationBottomSheet> createState() =>
      _ManualLocationBottomSheetState();
}

class _ManualLocationBottomSheetState extends State<ManualLocationBottomSheet> {
  String? selectedGovernorate;

  @override
  Widget build(BuildContext context) {
    final governorates = context.read<LocationCubit>().governorates;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: const BoxDecoration(
        color: ColorsManager.darkBlue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context)!.locationSelectGovernorate, style: TextStyles.font18WhiteBold(context)),

          verticalSpace(24),

          DropdownButtonFormField<String>(
            style: TextStyles.font16WhiteRegular(context),
            value: selectedGovernorate,
            dropdownColor: ColorsManager.darkBlue,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade900,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            hint: Text(
              AppLocalizations.of(context)!.locationSelectGovernorate,
              style: TextStyles.font16LightGrayRegular(context),
            ),
            items: governorates.map((governorate) {
              return DropdownMenuItem(
                value: governorate,
                child: Text(governorate),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedGovernorate = value;
              });
            },
          ),

          verticalSpace(24),

          FilledAppTextButton(
            buttonText: AppLocalizations.of(context)!.commonSave,
            onPressed: () {
              if (selectedGovernorate == null) return;

              context.read<LocationCubit>().selectGovernorate(
                selectedGovernorate!,
              );

              context.read<LocationCubit>().saveLocation();
            },
          ),

          verticalSpace(24),
        ],
      ),
    );
  }
}
