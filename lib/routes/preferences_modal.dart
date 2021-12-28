import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mailman/bloc/address/address_bloc.dart';
import 'package:mailman/bloc/address/address_event.dart';
import 'package:mailman/bloc/auth/bloc.dart';
import 'package:mailman/bloc/jobs/bloc.dart';
import 'package:mailman/bloc/user_data/bloc.dart';
import 'package:mailman/model/user.dart';
import 'package:mailman/routes/environment_changer.dart';
import 'package:mailman/routes/onboarding/sign_up_modal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final GetIt getIt = GetIt.instance;

class PreferencesModal {
  static PreferencesModal? _instance;

  PreferencesModal._();

  static PreferencesModal get instance => _instance ??= PreferencesModal._();

  void showPreferencesModal({
    required BuildContext context,
  }) {

    showCupertinoModalBottomSheet(
        expand: true,
        context: context,
        builder: (context) => const Material(
          child: Scaffold(
            body: SafeArea(
              child: PreferencesView(),
            ),
          ),
        )
    );
  }
}

class PreferencesUserHeader extends StatelessWidget {
  const PreferencesUserHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      bloc: getIt<AuthenticationBloc>(),
      builder: (context, authState) {
        final authBloc = getIt<AuthenticationBloc>();

        return (authState is Authenticated) ?
            Column(
              children: [
                BlocBuilder<UserDataBloc, UserDataState>(
                  bloc: getIt<UserDataBloc>(),
                  builder: (context, userDataState) {
                    if (userDataState.fetched) {
                      var user = userDataState.user;
                      return UserListTile(user: user);
                    }
                    return const LinearProgressIndicator();
                  }
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () {
                    Navigator.pop(context);
                    authBloc.add(Logout());
                    getIt<AddressBloc>().add(ClearAddressList());
                    getIt<UserDataBloc>().add(ClearUserData());
                    getIt<JobsBloc>().add(ClearJobsList());
                  },
                )
              ],
            ) :
            Column(
              children: [
                const UserListTile(),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text("Login"),
                  onTap: () {
                    var signUpModal = SignUpModal.instance;
                    signUpModal.startSignUp(context: context);
                  },
                )
              ],
            );
      }
    );
  }
}

class UserListTile extends StatelessWidget {
  const UserListTile({
    Key? key,
    this.user,
  }) : super(key: key);

  final User? user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user?.username ?? "",
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subtitle: Text(user?.email ?? ""),
      leading: CircleAvatar(
        radius: 32,
        backgroundColor: user != null ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: Text(user?.getInitials() ?? "",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      contentPadding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 8),
    );
  }
}


class PreferencesView extends StatefulWidget {
  const PreferencesView({Key? key}) : super(key: key);

  @override
  _PreferencesViewState createState() => _PreferencesViewState();
}

class _PreferencesViewState extends State<PreferencesView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PreferencesUserHeader(),
        AboutListTile(
          icon: const Icon(Icons.info),
          applicationLegalese: "Created by Dario Breitenstein.\nPowered by open source software.\nThis App is in no way affiliated with Post CH AG or Postcard Creator. Use at your own discretion.",
          applicationIcon: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const Image(
                image: AssetImage("assets/image/app-icon.png"),
                width: 32,
            ),
          ),
        ),
        const Spacer(),
        const PreferencesFooter()
      ],
    );
  }
}

class PreferencesFooter extends StatelessWidget {
  const PreferencesFooter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text("1.0",
        //   style: Theme.of(context).textTheme.caption,
        // ),
        InkWell(
          onTap: () => Navigator.of(context).pushNamed(EnvironmentChangerRoute.routeName),
          child: Text("Made by Dario Breitenstein",
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    );
  }
}