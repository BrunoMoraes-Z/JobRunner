import 'dart:io';

import 'package:ftpconnect/ftpconnect.dart';
import 'package:job_runner/src/enums/job_type.dart';
import 'package:job_runner/src/models/job.dart';
import 'package:job_runner/src/services/fail_services.dart';

class UnzipJob extends Job {
  @override
  JobType get jobType => JobType.unzip;

  final String onFail;
  final String targetFile;
  final String workdir;

  const UnzipJob({
    required this.onFail,
    required this.targetFile,
    required this.workdir,
  });

  static UnzipJob parse(Map<String, dynamic> json) {
    return UnzipJob(
      onFail: json['onFail'],
      targetFile: json['targetFile'],
      workdir: (json['workdir'] as String).parseVariables(),
    );
  }

  @override
  Future<bool> run() async {
    
    var workingDir = workdir;

    if (Platform.isWindows && workdir.startsWith("/")) {
      workingDir = workdir.replaceFirst("/", "");
    }
    
    if (!await Directory(workingDir).exists()) {
      FailServices(
        action: onFail,
        message: '[UNZIP] Pasta ($workingDir) nao encontrado.',
      ).notify();
      return false;
    }

    if (!await File('$workingDir/$targetFile').exists()) {
      FailServices(
        action: onFail,
        message: '[UNZIP] Arquivo ($targetFile) nao encontrado.',
      ).notify();
      return false;
    }

    await FTPConnect.unZipFile(File('$workingDir/$targetFile'), workingDir);
    print('Arquivo $targetFile descompactado com sucesso.');

    return false;
  }
}
