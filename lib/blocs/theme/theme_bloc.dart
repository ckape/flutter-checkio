import 'package:bloc/bloc.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/theme/theme_event.dart';
import 'package:timefly/blocs/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(ThemeState(AppTheme.appTheme.createTheme(AppThemeMode.Light,
            AppThemeColorMode.Blue, AppFontMode.MaShanZheng)));

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ThemeChangeEvent) {
      yield ThemeState(AppTheme.appTheme
          .createTheme(event.themeMode, event.themeColorMode, event.fontMode));
    }
  }
}