import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:mailman/firebase_options.dart';

import 'bootstrap.dart';
import 'environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var env = Environment.create(
    flavor: development,
    flavors: flavors,
  );

  Logger.root.level = Level.FINEST;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await startApplication(env);
}
