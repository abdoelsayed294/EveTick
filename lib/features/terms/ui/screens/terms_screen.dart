import 'package:evetick/features/terms/data/models/terms_mode.dart';
import 'package:evetick/features/terms/ui/widgets/terms_app_bar.dart';
import 'package:evetick/features/terms/ui/widgets/terms_bloc_listener.dart';
import 'package:evetick/features/terms/ui/widgets/terms_bottom_bar.dart';
import 'package:evetick/features/terms/ui/widgets/terms_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsScreen extends StatelessWidget {
  final TermsMode mode;

  const TermsScreen({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return TermsBlocListener(
      child: Scaffold(
        appBar: const TermsAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: const TermsContent(),
                ),
              ),
              TermsBottomBar(mode: mode),
            ],
          ),
        ),
      ),
    );
  }
}
