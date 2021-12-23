import 'package:equatable/equatable.dart';

abstract class JobsEvent extends Equatable {
  const JobsEvent();
}

class RefreshJobsList extends JobsEvent {
  @override
  List<Object> get props => [];
}

class ClearJobsList extends JobsEvent {
  @override
  List<Object> get props => [];
}
