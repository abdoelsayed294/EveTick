import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/search/logic/search_data.dart';
import 'package:evetick/features/search/ui/widgets/search_idle_view.dart';
import 'package:evetick/features/search/ui/widgets/search_results_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchContent extends StatelessWidget {
  const SearchContent({
    super.key,
    required this.data,
    required this.onEventTap,
    required this.onQuerySelected,
  });

  final SearchData data;
  final ValueChanged<HomeEvent> onEventTap;
  final ValueChanged<String> onQuerySelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(bottom: 24.h),
      child: data.showResults
          ? SearchResultsView(data: data, onEventTap: onEventTap)
          : SearchIdleView(data: data, onQuerySelected: onQuerySelected),
    );
  }
}
