import 'package:newsapp/Functions/news_functions.dart';
import 'package:newsapp/Modals/categoriesnews_modal.dart';
import 'package:newsapp/Modals/headlines_modal.dart';

class NewsViewModals {
  final _repo = NewsFunctions();
  Future<HeadlinesModal> fetchNewsHeadlines(String channelName) async {
    final response = await _repo.fetchNewsHeadlines(channelName);
    return response;
  }
    Future<CategoriesnewsModal> fetchNewsCategories(String channelName) async {
    final response = await _repo.fetchNewsCategories(channelName);
    return response;
  }
}
