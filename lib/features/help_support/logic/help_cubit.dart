import 'package:evetick/features/help_support/logic/help_data.dart';
import 'package:evetick/features/help_support/logic/help_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpCubit extends Cubit<HelpState> {
  HelpCubit() : super(const HelpState.success(HelpData()));

  HelpData _data = const HelpData();

  void search(String query) {
    _data = HelpData(query: query, expandedIndex: 0);
    emit(HelpState.success(_data));
  }

  void toggleFaq(int index) {
    _data = HelpData(
      query: _data.query,
      expandedIndex: _data.expandedIndex == index ? null : index,
    );
    emit(HelpState.success(_data));
  }
}
