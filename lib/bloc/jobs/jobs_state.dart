import 'package:equatable/equatable.dart';
import 'package:mailman/model/postcard.dart';
import 'package:meta/meta.dart';

@immutable
class JobsState extends Equatable {
  final bool loading;
  final bool fetched;

  final List<Postcard> jobsList;

  const JobsState({
    this.loading = false,
    this.fetched = false,
    this.jobsList = const [],
  });

  JobsState copyWith({
    bool? loading,
    bool? fetched,
    List<Postcard>? jobsList,
  }) {
    return JobsState(
      loading: loading ?? this.loading,
      fetched: fetched ?? this.fetched,
      jobsList: jobsList ?? this.jobsList,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    fetched,
    jobsList,
  ];

  @override
  String toString() => 'JobsState loading:$loading, fetched:$fetched, jobs: ${jobsList.length}';
}
