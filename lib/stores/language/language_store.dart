import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/language/Language.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';
part 'language_store.g.dart';

class LanguageStore = _LanguageStore with _$LanguageStore;

abstract class _LanguageStore with Store {
  static const String TAG = "LanguageStore";
  final Repository _repository;
  final ErrorStore errorStore = ErrorStore();

  // supported languages
  List<Language> supportedLanguages = [
    Language(code: 'US', locale: 'en', language: 'English'),
    Language(code: 'DK', locale: 'da', language: 'Danish'),
    Language(code: 'ES', locale: 'es', language: 'España'),
    Language(code: 'FA', locale: 'fa', language: 'Farsi'),
  ];

  // constructor:---------------------------------------------------------------
  _LanguageStore(Repository repository) : this._repository = repository {
    init();
  }

  // store variables:-----------------------------------------------------------
  @observable
  String _locale = "fa";

  @computed
  String get locale => _locale;

  // actions:-------------------------------------------------------------------
  @action
  void changeLanguage(String value) {
    _locale = value;
    _repository.changeLanguage(value).then((_) {
      // write additional logic here
    });
  }

  @action
  String getCode() {
    var code;

    if (_locale == 'en') {
      code = "US";
    } else if (_locale == 'da') {
      code = "DK";
    } else if (_locale == 'es') {
      code = "ES";
    } else if (_locale == 'fa') {
      code = "FA";
    }

    return code;
  }

  @action
  String getLanguage() {
    return supportedLanguages[supportedLanguages
            .indexWhere((language) => language.locale == _locale)]
        .language;
  }

  // general:-------------------------------------------------------------------
  void init() async {
    // getting current language from shared preference
    _repository?.currentLanguage?.then((locale) {
      if (locale != null) {
        _locale = 'fa';
      }
    });
  }

  // dispose:-------------------------------------------------------------------
  @override
  dispose() {}
}
