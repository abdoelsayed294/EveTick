import 'package:evetick/features/help_support/logic/help_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpCubit extends Cubit<HelpState> {
  HelpCubit() : super(const HelpState());

  void search(String query) {
    emit(HelpState(query: query, expandedIndex: 0));
  }

  void toggleFaq(int index) {
    emit(
      HelpState(
        query: state.query,
        expandedIndex: state.expandedIndex == index ? null : index,
      ),
    );
  }
}
