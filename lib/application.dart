import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:mailman/routes/create_postcard/create_postcard.dart';
import 'package:mailman/routes/environment_changer.dart';
import 'package:mailman/routes/home/home.dart';
import 'package:mailman/theme/mailman_theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'bloc/address/bloc.dart';
import 'bloc/auth/bloc.dart';
import 'bloc/jobs/bloc.dart';
import 'bloc/user_data/bloc.dart';

final GetIt getIt = GetIt.instance;

class MailmanApplication extends StatelessWidget {
  const MailmanApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String initialRouteName = HomeRoute.routeName;

    void _authListener(BuildContext context, AuthenticationState state) {
      if (state is Authenticated) {
        getIt<UserDataBloc>().add(RefreshUserData());
        getIt<AddressBloc>().add(RefreshAddressList());
        getIt<JobsBloc>().add(RefreshJobsList());
      }

      if (state is Unauthenticated) {
        getIt<UserDataBloc>().add(ClearUserData());
        getIt<AddressBloc>().add(ClearAddressList());
        getIt<JobsBloc>().add(ClearJobsList());
      }
    }

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      bloc: getIt<AuthenticationBloc>(),
      listener: _authListener,
      builder: (context, state) {
        return MaterialApp(
          title: 'Mailman',
          debugShowCheckedModeBanner: false,
          theme: mailmanTheme,
          localizationsDelegates: const [
            ...AppLocalizations.localizationsDelegates,
            RefreshLocalizations.delegate
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: initialRouteName,
          routes: {
            HomeRoute.routeName: (context) => const HomeRoute(),
            CreatePostcardRoute.routeName: (context) => const CreatePostcardRoute(),
            EnvironmentChangerRoute.routeName: (context) => const EnvironmentChangerRoute()
          }
        );
      }
    );
  }
}
