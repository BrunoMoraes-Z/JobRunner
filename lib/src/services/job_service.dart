import 'dart:convert';
import 'dart:io';

import 'package:job_runner/src/enums/job_type.dart';
import 'package:job_runner/src/models/job.dart';
import 'package:job_runner/src/models/types/read_url_job.dart';

class JobService {
  Future<List<Job>> readJobs() async {
    final file = File('jobs.json');
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
            break;
          case JobType.unzip:
            break;
          case JobType.deleteFolder:
            break;
          case JobType.runCommand:
            break;
          default:
        }
      }
    }
    return jobs;
  }
}
