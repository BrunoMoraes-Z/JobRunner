import 'package:job_runner/src/services/job_service.dart';
import 'package:job_runner/src/shared/constants.dart';

class JobRunner {

  Future<void> run(List<String> args) async {
    
    final jobs = await JobService().readJobs();
    await jobs.first.run();
    print(constants.variableSerices.get('TOKEN', 'system'));
    print('a');
  }

}