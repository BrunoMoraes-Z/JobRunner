// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:job_runner/src/models/job.dart';
import 'package:job_runner/src/services/fail_services.dart';
import 'package:job_runner/src/services/job_service.dart';
import 'package:job_runner/src/shared/constants.dart';

class JobRunner {
  Future<void> run(List<String> args) async {
    final jobs = await JobService().readJobs();

    await Future.forEach(jobs, (Job job) async {
      if (!constants.isStopped) {
        try {
          await job.run();
        } catch (e) {
          FailServices(
            action: 'stop',
            message: '[SYSTEM] [${job.jobType.name.toUpperCase()}] ${e.toString()}',
          ).notify();
        }
        await Future.delayed(Duration(milliseconds: 500));
      }
    });
  }
}
