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
      workdir: json['workdir'],
    );
  }

  @override
  Future<bool> run() async {
    if (!await Directory(workdir).exists()) {
      FailServices(
        action: onFail,
        message: '[UNZIP] Pasta ($workdir) nao encontrado.',
      ).notify();
      return false;
    }

    if (!await File('$workdir/$targetFile').exists()) {
      FailServices(
        action: onFail,
        message: '[UNZIP] Arquivo ($targetFile) nao encontrado.',
      ).notify();
      return false;
    }

    await FTPConnect.unZipFile(File('$workdir/$targetFile'), workdir);

    return false;
  }
}
