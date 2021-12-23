import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:mailman/environment.dart';

class LoggingBlocDelegate extends BlocObserver {
  final Logger log = Logger('LoggingBlocDelegate');

  final Environment? environment;

  LoggingBlocDelegate({this.environment});

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log.finer('Event: $event');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log.severe('Error for ${bloc.runtimeType}', error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log.finest('Transition: $transition');
  }
}
