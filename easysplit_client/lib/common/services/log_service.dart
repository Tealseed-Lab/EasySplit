import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class LogService {
  static late Logger logger;

  static Future<void> init() async {
    await _initializeLoggger();
  }

  static Future<void> _initializeLoggger() async {
    final prettyPrinter = PrettyPrinter(printTime: true);
    final simplePrinter = SimplePrinter(printTime: true);
    logger = Logger(
      filter: ProductionFilter(),
      printer: HybridPrinter(
        simplePrinter,
        error: prettyPrinter,
      ),
      output: MultiOutput(
        [ConsoleOutput(), FileOutput(file: File(await filePath()))],
      ),
    );

    rollFiles();
  }

  static Future<void> rollFiles() async {
    final directory = await getLogDirectory();
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));

    try {
      List<FileSystemEntity> files = directory.listSync(recursive: false);

      for (var file in files) {
        if (isEZLogFile(file)) {
          var fileStat = await file.stat();
          var modifiedTime = fileStat.modified;
          if (modifiedTime.isBefore(oneWeekAgo)) {
            LogService.w(
                'logfile $file last modified at $modifiedTime, expired, delete it.');
            await file.delete();
          }
        }
      }
    } catch (e) {
      LogService.e('Error while rolling files: $e');
    }
  }

  static isEZLogFile(FileSystemEntity file) {
    var fileName = path.basename(file.path);
    return file is File &&
        ((fileName.startsWith("ezlog_") && fileName.endsWith(".txt")) ||
            fileName == 'log.txt');
  }

  static Future<Directory> getLogDirectory() async {
    return getApplicationDocumentsDirectory();
  }

  static Future<String?> packetLogFiles() async {
    try {
      final directory = await getLogDirectory();
      final zipFilePath =
          path.join((await getTemporaryDirectory()).path, 'ezlog.zip');
      var encoder = ZipFileEncoder();
      encoder.create(zipFilePath);

      List<FileSystemEntity> files = directory.listSync(recursive: false);
      for (var file in files) {
        if (file is File) {
          var fileName = path.basename(file.path);
          if (isEZLogFile(file)) {
            encoder.addFile(file, fileName);
          }
        }
      }

      encoder.close();

      return zipFilePath;
    } catch (e) {
      LogService.e('Error while packing log files: $e');
      return null;
    }
  }

  static Future<String> filePath() async {
    final directory = await getLogDirectory();
    final now = DateTime.now();
    final dateTime =
        '${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_${now.second}';
    final filePath = path.join(directory.path, 'ezlog_$dateTime.txt');
    return filePath;
  }

  static Future<int> fileSize() async {
    try {
      int length = 0;
      final directory = await getLogDirectory();
      List<FileSystemEntity> files = directory.listSync(recursive: false);
      for (var file in files) {
        if (file is File) {
          if (isEZLogFile(file)) {
            length += await file.length();
          }
        }
      }

      return length;
    } catch (e) {
      LogService.e('Error while packing log files: $e');
      return 0;
    }
  }

  static Future<void> clean() async {
    logger.close();
    final directory = await getLogDirectory();
    List<FileSystemEntity> files = directory.listSync(recursive: false);
    for (var file in files) {
      if (isEZLogFile(file)) {
        await file.delete();
      }
    }
    _initializeLoggger();
  }

  static void t(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!logger.isClosed()) {
      logger.t(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  static void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!logger.isClosed()) {
      logger.d(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  static void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!logger.isClosed()) {
      logger.i(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  static void w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!logger.isClosed()) {
      logger.w(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  static void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!logger.isClosed()) {
      logger.e(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  static void f(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!logger.isClosed()) {
      logger.f(message, time: time, error: error, stackTrace: stackTrace);
    }
  }
}
