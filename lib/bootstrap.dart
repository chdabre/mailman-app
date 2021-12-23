import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:get_it/get_it.dart';
import 'package:mailman/application.dart';
import 'package:mailman/bloc/auth/auth_event.dart';
import 'package:mailman/bloc/bloc_delegate.dart';
import 'package:mailman/bloc/credentials/bloc.dart';
import 'package:mailman/bloc/user_data/bloc.dart';
import 'package:mailman/repository/address_repository.dart';
import 'package:mailman/repository/auth_repository.dart';
import 'package:mailman/repository/credentials_repository.dart';
import 'package:mailman/repository/jobs_repository.dart';
import 'package:mailman/repository/rest/address_repository.dart';
import 'package:mailman/repository/rest/api_client.dart';
import 'package:mailman/repository/rest/auth_repository.dart';
import 'package:mailman/repository/rest/credentials_repository.dart';
import 'package:mailman/repository/rest/jobs_repository.dart';
import 'package:mailman/repository/rest/user_repository.dart';
import 'package:mailman/repository/user_repository.dart';
import 'package:mailman/secured_storage.dart';

import 'bloc/address/bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/jobs/bloc.dart';
import 'environment.dart';

final GetIt getIt = GetIt.instance;

Future<void> startApplication(Environment environment) async {
  var securedStorage = SecuredStorage();
  await securedStorage.initialize();
  Environment? persistedEnvironment = await securedStorage.getEnvironment();

  // Use the saved environment if it exists instead of the received one
  environment = persistedEnvironment ?? environment;

  // Configure Logger
  Logger.root.onRecord.listen((LogRecord rec) {
    // ignore: avoid_print
    print('${rec.level.name[0]}: ${rec.loggerName}: ${rec.time}: ${rec.message}');
    if (rec.error != null) {
      // ignore: avoid_print
      print(
          '${rec.level.name[0]}: ${rec.loggerName}: ${rec.time}: ${rec.error}');
    }
    if (rec.stackTrace != null) {
      // ignore: avoid_print
      print(
          '${rec.level.name[0]}: ${rec.loggerName}: ${rec.time}: ${rec.stackTrace}');
    }
  });

  // Initialize API Client
  var apiClient = ApiClient(
    baseUrl: environment.apiUrl,
  );
  await apiClient.initialize();

  // Initialize repositories
  var authRepository = AuthRestRepository(apiClient, securedStorage);
  var userRepository = UserRestRepository(apiClient);
  var credentialsRepository = CredentialsRestRepository(apiClient);
  var addressRepository = AddressRestRepository(apiClient);
  var jobsRepository = JobsRestRepository(apiClient);

  // Initialize authentication
  var authBloc = AuthenticationBloc(
    authRepository: authRepository,
  );

  var userDataBloc = UserDataBloc(userRepository);
  var credentialsBloc = CredentialsBloc(credentialsRepository);
  var addressBloc = AddressBloc(addressRepository);
  var jobsBloc = JobsBloc(jobsRepository);

  // TODO Prefs Bloc
  // var sharedPreferences = await SharedPreferences.getInstance();
  // var preferencesBloc = PreferencesBloc(sharedPreferences: sharedPreferences);


  var appLauncher = ApplicationLauncher(
      application: const MailmanApplication(),
      securedStorage: securedStorage,
      environment: environment,
      apiClient: apiClient,
      authRepository: authRepository,
      credentialsRepository: credentialsRepository,
      userRepository: userRepository,
      addressRepository: addressRepository,
      jobsRepository: jobsRepository,
      authBloc: authBloc,
      credentialsBloc: credentialsBloc,
      userDataBloc: userDataBloc,
      addressBloc: addressBloc,
      jobsBloc: jobsBloc,
  );

  BlocOverrides.runZoned(
        () => runApp(appLauncher),
        blocObserver: LoggingBlocDelegate(environment: environment),
  );
}

class ApplicationLauncher extends StatefulWidget {
  final Widget application;
  final SecuredStorage securedStorage;
  final Environment environment;
  final ApiClient apiClient;
  final AuthRepository authRepository;
  final CredentialsRepository credentialsRepository;
  final AddressRepository addressRepository;
  final UserRepository userRepository;
  final JobsRepository jobsRepository;
  final AuthenticationBloc authBloc;
  final CredentialsBloc credentialsBloc;
  final UserDataBloc userDataBloc;
  final AddressBloc addressBloc;
  final JobsBloc jobsBloc;

  const ApplicationLauncher({
    Key? key,
    required this.application,
    required this.securedStorage,
    required this.environment,
    required this.apiClient,
    required this.authRepository,
    required this.credentialsRepository,
    required this.userRepository,
    required this.addressRepository,
    required this.jobsRepository,
    required this.authBloc,
    required this.credentialsBloc,
    required this.userDataBloc,
    required this.addressBloc,
    required this.jobsBloc,
  }) : super(key: key);

  @override
  _ApplicationLauncherState createState() => _ApplicationLauncherState();
}

class _ApplicationLauncherState extends State<ApplicationLauncher> with WidgetsBindingObserver {
  final Logger _log = Logger('ApplicationLauncher');

  @override
  void initState() {
    super.initState();
    _log.info('Initializing application');

    WidgetsBinding.instance!.addObserver(this);

    getIt.registerSingleton(widget.environment);
    getIt.registerSingleton(widget.apiClient);
    getIt.registerSingleton(widget.securedStorage);

    getIt.registerSingleton(widget.authRepository);
    getIt.registerSingleton(widget.credentialsRepository);
    getIt.registerSingleton(widget.userRepository);
    getIt.registerSingleton(widget.addressRepository);
    getIt.registerSingleton(widget.jobsRepository);

    getIt.registerSingleton(widget.authBloc);
    getIt.registerSingleton(widget.credentialsBloc);
    getIt.registerSingleton(widget.userDataBloc);
    getIt.registerSingleton(widget.addressBloc);
    getIt.registerSingleton(widget.jobsBloc);

    _initAsync();
  }

  Future<void> _initAsync() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await widget.authRepository.init();

    widget.authBloc.add(AppStarted());
    widget.userDataBloc.add(RefreshUserData());
    widget.addressBloc.add(RefreshAddressList());
    widget.jobsBloc.add(RefreshJobsList());

    _logApplicationStarted();
  }

  Future<void> _logApplicationStarted() async {
    _log.info('Initialization completed.');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _log.info('Application lifecycle changed $state');

    if (state == AppLifecycleState.resumed) {
      _logApplicationStarted();
    }
    if (state == AppLifecycleState.detached) {
      _onApplicationDetached();
    }
  }

  void _onApplicationDetached() {
    _log.info('Application detached');
  }

  @override
  void dispose() {
    _log.info('Disposing application');

    WidgetsBinding.instance!.removeObserver(this);

    getIt.unregister(instance: widget.environment);

    getIt.unregister(instance: widget.credentialsRepository);
    getIt.unregister(instance: widget.userRepository);
    getIt.unregister(instance: widget.authRepository);
    getIt.unregister(instance: widget.addressRepository);
    getIt.unregister(instance: widget.jobsRepository);

    getIt.unregister(instance: widget.authBloc);
    getIt.unregister(instance: widget.credentialsBloc);
    getIt.unregister(instance: widget.userDataBloc);
    getIt.unregister(instance: widget.addressBloc);
    getIt.unregister(instance: widget.jobsBloc);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.application;
  }
}
