import 'package:job_runner/src/shared/constants.dart';

class Variable {
  final String name;
  final String origin;

  const Variable({required this.name, required this.origin});

  static Variable of(Map<String, dynamic> json) {
    return Variable(
      name: json['name'],
      origin: json['origin'],
    );
  }

  String? get value => constants.variableSerices.get(name, origin);
}
