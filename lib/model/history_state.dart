part of 'history_cubit.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<Map<String, dynamic>> predictions;
  HistoryLoaded(this.predictions);
}

class HistoryError extends HistoryState {
  final String error;
  HistoryError(this.error);
}
