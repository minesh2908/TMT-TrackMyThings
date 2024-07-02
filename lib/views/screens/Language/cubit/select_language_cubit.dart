import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:track_my_things/service/shared_prefrence.dart';

part 'select_language_state.dart';

class SelectLanguageCubit extends Cubit<String> {
  SelectLanguageCubit() : super(AppPrefHelper.getLanguage());

  Future<void> updateAppLanguage(String local) async {
    await AppPrefHelper.setLanguage(language: local);
    final currentLanguage = AppPrefHelper.getLanguage();
    emit(currentLanguage);
  }
}
