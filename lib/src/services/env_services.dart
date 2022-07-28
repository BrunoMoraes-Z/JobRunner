import 'dart:io';

class EnvService {
  final Map<String, dynamic> _map = {};

  EnvService() {
    _init();
  }

  _init() {
    final file = File('.env');
    final rawContent = file.readAsStringSync();
    final lines = rawContent.split('\n');
    for (var line in lines) {
      _map[line.split('=')[0]] = line.split('=').sublist(1).join('=').trim();
    }
  }

  String? operator [](String key) {
    return _map[key] ?? Platform.environment[key];
  }
}
