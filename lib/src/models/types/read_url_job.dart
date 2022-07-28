import 'dart:convert';

import 'package:job_runner/src/models/job.dart';
import 'package:job_runner/src/enums/job_type.dart';
import 'package:job_runner/src/services/fail_services.dart';
import 'package:job_runner/src/shared/constants.dart';
import 'package:requests/requests.dart';
import 'package:jmespath/jmespath.dart';

class ReadUrlJob extends Job {
  @override
  JobType get jobType => JobType.readJsonFromUrl;

  final String onFail;
  final String url;
  final String tag;
  final String itemPath;
  final String itemName;

  const ReadUrlJob({
    required this.onFail,
    required this.url,
    required this.tag,
    required this.itemPath,
    required this.itemName,
  });

  static ReadUrlJob parse(Map<String, dynamic> json) {
    return ReadUrlJob(
      onFail: json['onFail'],
      tag: json['tag'],
      url: json['url'],
      itemPath: json['item']['path'],
      itemName: json['item']['name'],
    );
  }

  @override
  Future<bool> run() async {
    final response = await Requests.get(url);
    if (response.statusCode == 200) {
      final body = response.json();
      final result = search(itemPath, body);
      constants.variableSerices.register(itemName, result);
      return true;
    } else {
      FailServices(action: onFail, message: '[GET] ($tag) ${response.statusCode} >> ${response.body}').notify();
    }
    return false;
  }
}
