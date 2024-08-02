import 'dart:io';

import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareLogFile(BuildContext context, File logFile) async {
  final box = context.findRenderObject() as RenderBox?;
  await Share.shareXFiles(
    [XFile(logFile.path)],
    subject: shareLogsSubject,
    text: shareLogsText,
    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
  );
}

void showShareDialog(BuildContext context, File logFile) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(shareLogsTitle,
            style: TextStyle(fontWeight: FontWeight.w600)),
        content: const Text(shareLogsMessage,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: Text('Cancel',
                    style: TextStyle(
                        fontSize: 16, color: Theme.of(context).primaryColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Container(
                width: 1,
                height: 22,
                color: Theme.of(context).primaryColor,
              ),
              TextButton(
                child: Text('Share',
                    style: TextStyle(
                        fontSize: 16, color: Theme.of(context).primaryColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                  shareLogFile(context, logFile);
                },
              ),
            ],
          )
        ],
      );
    },
  );
}
