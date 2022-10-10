import 'dart:io';

import 'package:job_runner/src/shared/constants.dart';

class LogCleaner {
  Future<void> run() async {
    var logsDir =
        Directory.fromUri(Uri.parse('${Constants.currentDir.path}/logs'));

    if (await logsDir.exists()) {
      var files = logsDir.listSync();

      if (files.isNotEmpty) {
        var baseDate = DateTime.now().subtract(Duration(days: 30));
        for (var file in files) {
          var info = await file.stat();
          if (info.modified.isBefore(baseDate)) {
            await file.delete(recursive: true);
          }
        }
      }

      files = logsDir.listSync();
      if (files.isEmpty) {
        await logsDir.delete();
      }
    }
  }
}
