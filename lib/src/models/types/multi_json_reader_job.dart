// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:jmespath/jmespath.dart';
import 'package:job_runner/src/enums/job_type.dart';
import 'package:job_runner/src/models/job.dart';
import 'package:job_runner/src/services/fail_services.dart';
import 'package:job_runner/src/shared/constants.dart';
import 'package:requests/requests.dart';

class MultiJsonReaderJob extends Job {
  @override
  JobType get jobType => JobType.multiReadJson;

  final String onFail;
  final String tag;
  final String url;
  final List<ItemPath> paths;

  const MultiJsonReaderJob({
    required this.onFail,
    required this.tag,
    required this.url,
    required this.paths,
  });

  static MultiJsonReaderJob parse(Map<String, dynamic> json) {
    return MultiJsonReaderJob(
      onFail: json['onFail'],
      tag: json['tag'],
      url: json['url'],
      paths: _parsePaths(json['paths'] as List),
    );
  }

  @override
  Future<bool> run() async {
    final response = await Requests.get(url, timeoutSeconds: 100);
    if (response.statusCode == 200) {
      final body = response.json();
      for (ItemPath item in paths) {
        Map<String, dynamic> result = search(item.searchOn, body) ?? {};
        if (result.isNotEmpty) {
          List<String> keys = [];
          switch (item.operator.toLowerCase()) {
            case 'startwith':
              keys = result.keys
                  .where((element) => element.startsWith(item.path))
                  .toList();
              break;
            case 'endwith':
              keys = result.keys
                  .where((element) => element.endsWith(item.path))
                  .toList();
              break;
            case 'contains':
              keys = result.keys
                  .where((element) => element.contains(item.path))
                  .toList();
              break;
            case 'equals':
              keys =
                  result.keys.where((element) => element == item.path).toList();
              break;
            default:
          }

          if (keys.isNotEmpty) {
            var subResult = {};
            keys.forEach((element) =>
                subResult[element.replaceAll(item.path, '')] =
                  result[element],
            );
            var finalresult = [];

            switch (item.valueTarget) {
              case 'key':
                finalresult = subResult.keys.toList();
                break;
              case 'value':
                finalresult = subResult.values.toList();
                break;
              default:
            }

            constants.variableSerices.register(
              item.name,
              finalresult.isEmpty ? subResult : finalresult,
            );
          } else {
            FailServices(
              action: 'warn',
              message:
                  '[GET] ($tag) >> Nenhum item encontrado para as configurações preenchidos',
            ).notify();
          }
        } else {
            FailServices(
              action: 'warn',
              message:
                  '[GET] ($tag) >> Nenhum item encontrado para as configurações preenchidos',
            ).notify();
          }
      }

      return true;
    } else {
      FailServices(
        action: onFail,
        message: '[GET] ($tag) ${response.statusCode} >> ${response.body}',
      ).notify();
    }
    return false;
  }
}

_parsePaths(List itens) {
  List<ItemPath> paths = [];

  for (Map<String, dynamic> i in itens) {
    paths.add(
      ItemPath(
        searchOn: i['searchOn'],
        path: i['path'],
        operator: i['operator'],
        type: i['type'],
        valueTarget: i['valueTarget'],
        name: i['name'],
      ),
    );
  }

  return paths;
}

class ItemPath {
  final String searchOn;
  final String path;
  final String operator;
  final String type;
  final String valueTarget;
  final String name;

  const ItemPath({
    required this.searchOn,
    required this.path,
    required this.operator,
    required this.type,
    required this.valueTarget,
    required this.name,
  });
}
