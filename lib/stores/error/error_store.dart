import 'package:mobx/mobx.dart';

part 'error_store.g.dart';

class ErrorStore = _ErrorStore with _$ErrorStore;

abstract class _ErrorStore with Store {
  // disposers
  List<ReactionDisposer> _disposers;

  // constructor:---------------------------------------------------------------
  _ErrorStore() {
    _disposers = [
      reaction((_) => errorMessage, reset, delay: 200),
    ];
  }

  // store variables:-----------------------------------------------------------
  @observable
  String errorMessage = '';
  @observable
  int statusCode;

  // actions:-------------------------------------------------------------------
  @action
  void setStatusCode(int code) {
    this.statusCode = code;
  }

  // actions:-------------------------------------------------------------------
  @action
  void setErrorMessage(String message) {
    this.errorMessage = message;
  }

  @action
  void reset(String value) {
    errorMessage = '';
  }

  // dispose:-------------------------------------------------------------------
  @action
  dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
