import 'package:job_runner/src/services/env_services.dart';

class VariableSerices {
  final EnvService envService;

  final Map<String, dynamic> _map = {};

  VariableSerices({
    required this.envService,
  });

  void register(String key, dynamic value) {
    _map[key] = value;
  }

  String? get(String key, String origin) {
    switch (origin.toLowerCase()) {
      case 'system':
        return _map[key];
      case 'env':
        return envService[key.toUpperCase()];
      default:
        return origin;
    }
  }
}
