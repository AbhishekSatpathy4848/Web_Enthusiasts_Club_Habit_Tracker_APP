import 'package:cron/cron.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:habit_tracker/FirebaseRealtime/write.dart';

initialiseCronJob(String currentUID, BuildContext context) {
  final cron = Cron();
  cron.schedule(Schedule.parse("30 2 * * *"), () async {
    final result = await writeToDatabase(currentUID, context);
    if (kDebugMode) {
      if (result) {
        print("Successfully backed up to Firebase");
      } else {
        print("Error in backing up to Firebase");
      }
    }
  });
}
