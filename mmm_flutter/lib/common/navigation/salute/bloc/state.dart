part of "bloc.dart";

class SaluteNavigationState extends Equatable {
  const SaluteNavigationState({this.command});

  final BaseCommand? command;

  const SaluteNavigationState.empty() : command = null;

  SaluteNavigationState _copyWith({BaseCommand? command}) =>
      SaluteNavigationState(command: command ?? this.command);

  @override
  List<Object?> get props => [command];
}
