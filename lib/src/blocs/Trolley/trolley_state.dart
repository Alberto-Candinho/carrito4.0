part of 'trolley_bloc.dart';

@immutable
abstract class TrolleyState extends Equatable {
  const TrolleyState();

  @override
  List<Object> get props => [];
}

class TrolleyLoading extends TrolleyState {
  final Trolley trolley;

  const TrolleyLoading(this.trolley);

  @override
  List<Object> get props => [trolley];
}

class CurrentTrolleyContent extends TrolleyState {
  final Trolley trolley;

  const CurrentTrolleyContent(this.trolley);

  @override
  List<Object> get props => [trolley];
}

// class CurrentTrolleyContentWithError extends TrolleyState {
//   final Trolley trolley;
//   final String error;

//   const CurrentTrolleyContentWithError(this.trolley, this.error);

//   @override
//   List<Object> get props => [trolley, error];
// }

class Unconnected extends TrolleyState {}
