import 'package:bloc/bloc.dart';
import 'package:mailman/bloc/jobs/bloc.dart';
import 'package:mailman/repository/jobs_repository.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  final JobsRepository jobsRepository;

  JobsBloc(
      this.jobsRepository,
      ) : super(const JobsState()) {
    on<RefreshJobsList>((event, emit) async {
      JobsState loadingState = state.copyWith(loading: true);
      emit(loadingState);

      var jobsList = await jobsRepository.list();

      emit(loadingState.copyWith(
        loading: false,
        fetched: true,
        jobsList: jobsList,
      ));
    });

    on<ClearJobsList>((event, emit) async {
      emit(state.copyWith(
        fetched: false,
        jobsList: null,
      ));
    });
  }
}