import 'package:job_runner/src/models/variable.dart';
import 'package:job_runner/src/services/env_services.dart';

class VariableSerices {
  final EnvService envService;

  final Map<String, dynamic> _map = {};

  VariableSerices({
    required this.envService,
  });

  void register(String key, dynamic value) {
    _map[key.toUpperCase()] = value;
  }

  List<Variable> getAll() {
    List<Variable> list = [];
    _map.forEach((key, value) => list.add(Variable(name: key, origin: 'system')));
    envService.map.forEach((key, value) => list.add(Variable(name: key, origin: 'env')));
    return list;
  }

  String? get(String key, String origin) {
    switch (origin.toLowerCase()) {
      case 'system':
        return _map[key.toUpperCase()];
      case 'env':
        return envService[key.toUpperCase()];
      default:
        return origin;
    }
  }
}
