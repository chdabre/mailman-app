import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'bootstrap.dart';
import 'environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var env = Environment.create(
    flavor: development,
    flavors: flavors,
  );

  Logger.root.level = Level.FINEST;

  await startApplication(env);
}
