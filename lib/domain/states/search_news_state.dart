import 'package:clean_news_ai/domain/models/news_article.dart';
import 'package:equatable/equatable.dart';

import 'base_state.dart';

class SearchNewsState extends BaseState with EquatableMixin {
  final articles = <ArticleModel>[];

  @override
  List<Object> get props => [articles];
}
