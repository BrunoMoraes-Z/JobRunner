import 'dart:io';

import 'package:ftpconnect/ftpconnect.dart';
import 'package:intl/intl.dart';

class SimpleLog {
  late File logFile, zipFile;

  SimpleLog(String currentDirectory) {
    logFile = File(
      '$currentDirectory/logs/log_${DateTime.now().millisecondsSinceEpoch}.txt',
    );
    zipFile = File(
      '$currentDirectory/logs/log_${DateTime.now().millisecondsSinceEpoch}.zip',
    );
    if (!logFile.existsSync()) {
      logFile.createSync(recursive: true);
    }
  }

  get timestamp => DateFormat('dd-MM-yyyy HH:mm:ss.sss').format(DateTime.now());

  void log(String message, {LogType type = LogType.info}) {
    if (message.endsWith('\n')) {
      message = message.replaceAll('\n', '');
    }
    var logMessage = '$timestamp ${type.name} $message';
    print(logMessage);
    logFile.writeAsStringSync('$logMessage\n', mode: FileMode.append);
  }

  Future<void> close() async {
    await FTPConnect.zipFiles([logFile.path], zipFile.path);
    await logFile.delete(recursive: true);
  }
}

enum LogType {
  error('[ERROR]'),
  warning('[AVISO]'),
  info('[INFO]');

  const LogType(this.name);
  final String name;
}
