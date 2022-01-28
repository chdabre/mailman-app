import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'bootstrap.dart';
import 'environment.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var env = Environment.create(
    flavor: production,
    flavors: flavors,
  );

  Logger.root.level = Level.FINEST;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: '.env');
  var sentryDSN = dotenv.env['SENTRY_DSN'];

  if (sentryDSN != null) {
    await SentryFlutter.init(
          (options) {
            options.dsn = sentryDSN;
            // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
            // We recommend adjusting this value in production.
            options.tracesSampleRate = 1.0;

            options.environment = env.flavor;
      },
      appRunner: () => startApplication(env),
    );
  } else {
    startApplication(env);
  }
}
