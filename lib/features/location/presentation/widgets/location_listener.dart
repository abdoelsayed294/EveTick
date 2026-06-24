import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/features/location/logic/cubit/location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationListener extends StatelessWidget {
  const LocationListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationCubit, LocationState>(
      listener: (context, state) {
        state.whenOrNull(
          loading: () {
            showDialog(
              context: context,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );
          },

          saved: () {
            context.pop();
            context.pushReplacedNamed(Routes.homeScreen);
          },
          loaded: (location) {
            context.pop();

            context.read<LocationCubit>().saveLocation();
          },
          error: (message) {
            context.pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          },
        );
      },
      child: SizedBox.shrink(),
    );
  }
}
