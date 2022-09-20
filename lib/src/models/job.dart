import 'package:job_runner/src/enums/job_type.dart';
export '../shared/extensions/string_utils.dart';

abstract class Job {
  
  JobType get jobType;
  Future<dynamic> run();

  const Job();

}