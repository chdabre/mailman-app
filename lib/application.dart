import 'package:flutter/material.dart';
import 'package:mailman/routes/create_postcard/create_postcard.dart';
import 'package:mailman/routes/environment_changer.dart';
import 'package:mailman/routes/home/home.dart';
import 'package:mailman/theme/mailman_theme.dart';

class MailmanApplication extends StatelessWidget {
  const MailmanApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String initialRouteName = HomeRoute.routeName;

    return MaterialApp(
      title: 'Mailman',
      debugShowCheckedModeBanner: false,
      theme: mailmanTheme,
      initialRoute: initialRouteName,
      routes: {
        HomeRoute.routeName: (context) => const HomeRoute(),
        CreatePostcardRoute.routeName: (context) => const CreatePostcardRoute(),
        EnvironmentChangerRoute.routeName: (context) => EnvironmentChangerRoute()
      }
    );
  }
}
