import 'package:clean_news_ai/domain/components/favorites/state/favorites_state.dart';
import 'package:clean_news_ai/domain/components/navigation/state/navigation_state.dart';
import 'package:clean_news_ai/domain/components/settings/state/settings_state.dart';
import 'package:clean_news_ai/domain/components/top_news/state/top_news_state.dart';
import 'package:hive/hive.dart';
import 'package:osam/domain/state/base_state.dart';

part 'app_state.g.dart';

@HiveType()
// ignore: must_be_immutable
class AppState extends BaseState<AppState> {
  @HiveField(0)
  var topNewsState = TopNewsState();
  @HiveField(1)
  var navigationState = NavigationState();
  @HiveField(2)
  var favoritesState = FavoritesState();
  @HiveField(3)
  var settingsState = SettingsState();
  @HiveField(4)
  var isFailure = false;

  void setIsFailure(bool value) => isFailure = value;

  @override
  List<Object> get props =>
      [topNewsState, navigationState, favoritesState, settingsState, isFailure];
}
