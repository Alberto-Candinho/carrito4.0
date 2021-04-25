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

class Unconnected extends TrolleyState {}