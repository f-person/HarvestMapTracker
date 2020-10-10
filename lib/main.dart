import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_notification.dart';
import 'app_storage.dart';
import 'harvest_tracker_app.dart';
import 'provider.dart';
import 'schedule_task.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var isReg = await AppStorage.isRegisteredNotification();
  setupNotification();
  if (!isReg) {
    workManagerInitialize();
    AppStorage.setRegisteredNotification();
  }

  runApp(Provider(
    create: (_) => HarvestTrackerProvider(),
    child: HarvestTrackerApp(),
  ));
}
