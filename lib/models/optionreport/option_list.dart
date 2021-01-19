import 'package:boilerplate/models/optionreport/optionReport.dart';

class OptionList {
  final List<OptionReport> options;

  OptionList({
    this.options,
  });

  factory OptionList.fromJson(List<dynamic> json) {
    List<OptionReport> optionsReport = List<OptionReport>();
    optionsReport = json.map((item) => OptionReport.fromMap(item)).toList();

    return OptionList(
      options: optionsReport,
    );
  }
}
