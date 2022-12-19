// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:job_runner/src/enums/job_type.dart';
import 'package:job_runner/src/models/job.dart';
import 'package:job_runner/src/models/variable.dart';
import 'package:job_runner/src/shared/constants.dart';

class RunCommandJob extends Job {
  @override
  JobType get jobType => JobType.runCommand;

  final String onFail;
  final String tag;
  final String command;
  final String workdir;
  final List<Variable> variables;

  const RunCommandJob({
    required this.onFail,
    required this.tag,
    required this.command,
    required this.workdir,
    required this.variables,
  });

  static RunCommandJob parse(Map<String, dynamic> json) {
    return RunCommandJob(
      onFail: json['onFail'],
      tag: json['tag'],
      command: json['command'],
      workdir: (json['workdir'] as String).parseVariables(),
      variables: (json['variables'] as List)
          .map(
            (e) => Variable.of(e),
          )
          .toList(),
    );
  }

  @override
  Future<bool> run() async {
    
    var workingDir = workdir;

    if (Platform.isWindows && workdir.startsWith("/")) {
      workingDir = workdir.replaceFirst("/", "");
    }

    var exeCommand = command.parseVariables(variables: variables, includeAll: true);
    var process = await Process.run(
      exeCommand.split(" ")[0],
      exeCommand.split(" ")..removeAt(0),
      workingDirectory: workingDir.isNotEmpty ? workingDir : null,
    );
    List<String> log = [];
    process.stdout.toString().split("\r\n").forEach((element) {
      if (element.trim().isNotEmpty) {
        log.add(element);
      }
    });
    log.forEach((element) => constants.logger.log(element));
    return false;
  }
}
