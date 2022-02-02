import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mailman/bloc/credentials/bloc.dart';
import 'package:mailman/repository/credentials_repository.dart';
import 'package:mailman/services/postcard_auth_service.dart';

final GetIt getIt = GetIt.instance;

class GetCredentialsScreen extends StatefulWidget {
  final void Function() onCredentialsReceived;

  const GetCredentialsScreen({
    Key? key,
    required this.onCredentialsReceived,
  }) : super(key: key);

  @override
  _GetCredentialsScreenState createState() => _GetCredentialsScreenState();
}

class _GetCredentialsScreenState extends State<GetCredentialsScreen> {
  final _credentialsBloc = getIt<CredentialsBloc>();

  void _startPostAuthFlow() async {
    var authService = PostcardAuthService.instance;
    var credentialsRepository = getIt<CredentialsRepository>();

    var credentials = await authService.doLoginAction();
    if (credentials != null) {
      await credentialsRepository.create(credentials);
      _credentialsBloc.add(RefreshCredentials());
    }
  }

  void _credentialsListener(BuildContext context, CredentialsState state) {
    if (state.fetched && state.hasCredentials()) {
      widget.onCredentialsReceived.call();
    }
  }

  @override
  void initState() {
    _credentialsBloc.add(RefreshCredentials());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredentialsBloc, CredentialsState>(
      bloc: _credentialsBloc,
      listener: _credentialsListener,
      builder: (_, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(AppLocalizations.of(context)!.credentialsTitle,
                          style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16,),
                      Text(AppLocalizations.of(context)!.credentialsDescription,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 24,),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: _startPostAuthFlow,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    elevation: 0,
                  ),
                  child: Text(AppLocalizations.of(context)!.credentialsAuthorizeButton.toUpperCase())
              ),
            ],
          ),
        );
      },
    );
  }
}