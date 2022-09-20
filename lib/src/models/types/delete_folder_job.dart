import 'dart:io';

import 'package:job_runner/src/enums/job_type.dart';
import 'package:job_runner/src/models/job.dart';
import 'package:job_runner/src/services/fail_services.dart';

class DeleteFolderJob extends Job {
  @override
  JobType get jobType => JobType.deleteFolder;

  final String onFail;
  final String targetFolder;

  const DeleteFolderJob({
    required this.onFail,
    required this.targetFolder,
  });

  static DeleteFolderJob parse(Map<String, dynamic> json) {
    return DeleteFolderJob(
      onFail: json['onFail'],
      targetFolder: (json['targetFolder'] as String).parseVariables(),
    );
  }

  @override
  Future<bool> run() async {
    
    var workingDir = targetFolder;

    if (Platform.isWindows && targetFolder.startsWith("/")) {
      workingDir = targetFolder.replaceFirst("/", "");
    }
    
    try {
      if (await Directory(workingDir).exists()) {
        await Directory(workingDir).delete(recursive: true);
      }
    } catch (e) {
      FailServices(
        action: onFail,
        message: '[SYSTEM] [DELETE_FOLDER] ouve um erro ao tentar deletar a pasta ($workingDir).',
      ).notify();
    }

    return false;
  }
}
