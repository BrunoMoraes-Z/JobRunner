import 'package:job_runner/src/shared/constants.dart';

import '../../models/variable.dart';

extension RegexExtensiopn on RegExpMatch {

  String get value => input.substring(start, end);

}

extension StringExtension on String {

  String parseVariables({List<Variable> variables = const [], bool includeAll = false}) {
    List<Variable> vars = List.from(variables, growable: true);
    if (vars.isEmpty || includeAll) {
      vars.addAll(constants.variableSerices.getAll());
    }
    if (RegExp(pattern).hasMatch(this)) {
      var finalItem = this;
      var matchs = RegExp(pattern).allMatches(this);
      for (var match in matchs) {
        List<Variable> variable = vars.where((element) => element.name.toUpperCase() == match.value.replaceAll("{", "").replaceAll("}", "").toUpperCase()).toList();
        if (variable.isNotEmpty) {
          for (var element in variable) { 
            var value = constants.variableSerices.get(element.name, element.origin);
            if (value != null) {
              finalItem = finalItem.replaceAll(match.value, value.parseVariables());
            }
          }
          
        }
      }
      return finalItem;
    } else {
      return this;
    }
  }

}