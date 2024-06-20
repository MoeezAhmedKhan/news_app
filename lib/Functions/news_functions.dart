import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/Modals/categoriesnews_modal.dart';
import 'package:newsapp/Modals/headlines_modal.dart';

class NewsFunctions {
  Future<HeadlinesModal> fetchNewsHeadlines(String channelName) async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=$channelName&apiKey=aa1034920f8f4eb88ddcb88fe84fd022";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      return HeadlinesModal.fromJson(data);
    } else {
      throw Exception("Error while fecthing data");
    }
  }

  Future<CategoriesnewsModal> fetchNewsCategories(String channelName) async {
    String url =
        "https://newsapi.org/v2/everything?q=$channelName&apiKey=aa1034920f8f4eb88ddcb88fe84fd022";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      return CategoriesnewsModal.fromJson(data);
    } else {
      throw Exception("Error while fecthing data");
    }
  }
}
