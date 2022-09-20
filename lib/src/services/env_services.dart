import 'dart:io';

class EnvService {
  final Map<String, dynamic> _map = {};

  EnvService() {
    _init();
  }

  Map<String, dynamic> get map => _map;

  _init() {
    final file = File('${Directory.fromUri(Platform.script).parent.path}/.env');
    final rawContent = file.readAsStringSync();
    final lines = rawContent.split('\n');
    for (var line in lines) {
      _map[line.split('=')[0].toUpperCase()] = line.split('=').sublist(1).join('=').trim();
    }
    _map['CURDIR'] = File(Platform.script.path).parent.path;
    if (_map['CURDIR'].toString().startsWith("/")) {
      _map['CURDIR'] = _map['CURDIR'].toString().replaceFirst('/', '');
    }
  }

  String? operator [](String key) {
    return Platform.environment[key] ??_map[key];
  }
}
