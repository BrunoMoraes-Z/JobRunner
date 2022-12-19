import 'dart:io';

import 'package:job_runner/src/services/env_services.dart';
import 'package:job_runner/src/services/variable_services.dart';
import 'package:job_runner/src/shared/simple_log.dart';
export 'extensions/string_utils.dart';

final Constants constants = Constants();

const pattern = r'{{[aA-zZ0-9]{1,}}}';

class Constants {
  static Directory get currentDir => File(Platform.script.path).parent;
  final EnvService envService = EnvService();
  late VariableSerices variableSerices;
  late bool _stop = false;
  late SimpleLog logger;

  Constants() {
    variableSerices = VariableSerices(
      envService: envService,
    );
    logger = SimpleLog(variableSerices.get("curdir", "env"));
  }

  void stop() {
    _stop = true;
  }

  bool get isStopped => _stop;
}
