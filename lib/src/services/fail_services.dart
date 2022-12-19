import 'package:job_runner/src/shared/constants.dart';
import 'package:job_runner/src/shared/simple_log.dart';

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
        constants.logger.log(message, type: LogType.warning);
        // print('[AVISO] >> $message');
        break;
      case 'stop':
        constants.logger.log(message, type: LogType.error);
        // print('[ERRO] >> $message');
        constants.stop();
        break;
      default:
        constants.logger.log(message, type: LogType.warning);
        // print('[?] >> $message');
    }
    print(' ');
  }

}