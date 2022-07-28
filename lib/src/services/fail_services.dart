import 'package:job_runner/src/shared/constants.dart';

class FailServices {
  
  final String action;
  final String message;

  const FailServices({
    required this.action,
    required this.message,
  });

  notify() {
    switch (action.toLowerCase()) {
      case 'warn':
        print('[AVISO] >> $message');
        break;
      case 'stop':
        print('[ERRO] >> $message');
        constants.stop();
        break;
      default:
        print('[?] >> $message');
    }
    print(' ');
  }

}