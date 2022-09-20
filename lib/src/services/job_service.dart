import 'dart:convert';
import 'dart:io';

import 'package:job_runner/src/enums/job_type.dart';
import 'package:job_runner/src/models/job.dart';
import 'package:job_runner/src/models/types/delete_folder_job.dart';
import 'package:job_runner/src/models/types/download_auth_token_job.dart';
import 'package:job_runner/src/models/types/read_url_job.dart';
import 'package:job_runner/src/models/types/run_command_job.dart';
import 'package:job_runner/src/models/types/unzip_job.dart';

class JobService {
  Future<List<Job>> readJobs() async {
    final file = File('${Directory.fromUri(Platform.script).parent.path}/jobs.json');
    final rawContent = jsonDecode(
      await file.readAsString(),
    ) as List<dynamic>;
    final List<Job> jobs = [];
    for (final item in rawContent) {
      final type = JobType.fromString(item['type']);
      if (type == null) {
        print('Ouve um erro ao tentar ler o job\n${jsonEncode(item)}');
      } else {
        switch (type) {
          case JobType.readJsonFromUrl:
            jobs.add(ReadUrlJob.parse(item));
            break;
          case JobType.downloadAuthToken:
            jobs.add(DownloadAuthTokenJob.parse(item));
            break;
          case JobType.unzip:
            jobs.add(UnzipJob.parse(item));
            break;
          case JobType.deleteFolder:
            jobs.add(DeleteFolderJob.parse(item));
            break;
          case JobType.runCommand:
            jobs.add(RunCommandJob.parse(item));
            break;
          default:
        }
      }
    }
    return jobs;
  }
}
