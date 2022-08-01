import 'dart:convert';
import 'dart:io';

import 'package:job_runner/src/enums/job_type.dart';
import 'package:job_runner/src/models/job.dart';
import 'package:job_runner/src/models/variable.dart';
import 'package:job_runner/src/services/fail_services.dart';
import 'package:requests/requests.dart';

const pattern = r'{{[aA-zZ0-9]{1,}}}';

class DownloadAuthTokenJob extends Job {
  @override
  JobType get jobType => JobType.downloadAuthToken;

  final String onFail;
  final String tag;
  final String url;
  final String workdir;
  final String authType;
  final String tokenVariable;
  final List<Variable> variables;

  const DownloadAuthTokenJob({
    required this.onFail,
    required this.tag,
    required this.url,
    required this.workdir,
    required this.authType,
    required this.tokenVariable,
    required this.variables,
  });

  static DownloadAuthTokenJob parse(Map<String, dynamic> json) {
    return DownloadAuthTokenJob(
      onFail: json['onFail'],
      tag: json['tag'],
      url: json['url'],
      workdir: json['workdir'],
      authType: json['authType'],
      tokenVariable: json['tokenVariable'],
      variables: (json['variables'] as List)
          .map(
            (e) => Variable.of(e),
          )
          .toList(),
    );
  }

  @override
  Future<bool> run() async {
    var token =
        variables.where((element) => element.name == tokenVariable).first.value;
    if (authType.toLowerCase() == 'basic') {
      token = base64.encode(utf8.encode('$token:'));
    }

    var parsedUrl = url;

    if (RegExp(pattern).hasMatch(url)) {
      for (var element in variables) {
        if (url.contains('{{${element.name}}}') && element.value != null) {
          parsedUrl = url.replaceAll('{{${element.name}}}', element.value!);
        }
      }
    }

    final response = await Requests.get(
      parsedUrl,
      headers: {'Authorization': '$authType $token'},
    );
    if (response.statusCode == 200) {
      if (await Directory(workdir).exists()) {
        await Directory(workdir).delete(recursive: true);
      }
      await Directory(workdir).create(recursive: true);

      print(tag);

      final file =
          await File('$workdir/download.zip').writeAsBytes(response.bodyBytes);
      int size = (await file.length() / 1024).round();
      print(
        'Arquivo baixado com tamanho de ($size KB | ${(size / 1000).round()} MB).',
      );
    } else {
      FailServices(
        action: onFail,
        message: '[GET] ($tag) ${response.statusCode} >> ${response.body}',
      ).notify();
    }
    return false;
  }
}
