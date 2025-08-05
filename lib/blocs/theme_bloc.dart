import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pgagi_assign/services/storage_service.dart';

// Theme Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class LoadTheme extends ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final bool isDarkMode;

  const ThemeLoaded(this.isDarkMode);

  @override
  List<Object> get props => [isDarkMode];
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final StorageService _storageService;

  ThemeBloc(this._storageService) : super(ThemeInitial()) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    try {
      final isDarkMode = _storageService.isDarkMode();
      emit(ThemeLoaded(isDarkMode));
    } catch (e) {
      emit(const ThemeLoaded(false)); // Default to light mode
    }
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    if (state is ThemeLoaded) {
      final currentState = state as ThemeLoaded;
      final newDarkMode = !currentState.isDarkMode;

      await _storageService.saveDarkMode(newDarkMode);
      emit(ThemeLoaded(newDarkMode));
    }
  }
}
