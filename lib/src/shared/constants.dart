import 'dart:io';

import 'package:job_runner/src/services/env_services.dart';
import 'package:job_runner/src/services/variable_services.dart';

final Constants constants = Constants();

class Constants {
  static Directory get currentDir => File(Platform.script.path).parent;
  final EnvService envService = EnvService();
  late VariableSerices variableSerices;
  late bool _stop = false;

  Constants() {
    variableSerices = VariableSerices(
      envService: envService,
    );
  }

  void stop() {
    _stop = true;
  }

  bool get isStopped => _stop;

}
