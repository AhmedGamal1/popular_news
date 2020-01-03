import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:clean_news_ai/data/dto/answer.dart';
import 'package:clean_news_ai/data/dto/article.dart';
import 'package:clean_news_ai/data/network_data_repository.dart';

class DomainRepository {
  static Future<List<Article>> getTopArticles(String theme) async {
    final jsonData = await NetworkDataRepository.newsAPI().getTopArticles(category: theme);
    final answer = Answer.fromMap(json.decode(jsonData));
    return answer.articles;
  }
}
