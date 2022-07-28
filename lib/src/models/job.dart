import 'package:job_runner/src/enums/job_type.dart';

abstract class Job {
  
  JobType get jobType;
  Future<dynamic> run();

  const Job();

}