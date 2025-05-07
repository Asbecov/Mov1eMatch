part of 'bloc.dart';

class CreateState extends Equatable {
  const CreateState({required this.selection});

  const CreateState.empty() : selection = const <Film>[];

  final List<Film> selection;

  CreateState copyWith({List<Film>? selection}) =>
      CreateState(selection: selection ?? this.selection);

  @override
  List<Object?> get props => [...selection, selection.length];
}

class CreateErrorState extends CreateState {
  CreateErrorState.fromState({
    required CreateState state,
    this.error,
    this.stackTrace,
  }) : super(selection: state.selection);

  final Object? error;
  final StackTrace? stackTrace;
}
