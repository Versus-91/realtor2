import 'package:boilerplate/models/optionreport/optionReport.dart';

class OptionList {
  final List<OptionReport> optionsReport;

  OptionList({
    this.optionsReport,
  });

  factory OptionList.fromJson(List<dynamic> json) {
    List<OptionReport> optionsReport = List<OptionReport>();
    optionsReport = json.map((item) => OptionReport.fromMap(item)).toList();

    return OptionList(
      optionsReport: optionsReport,
    );
  }
}
