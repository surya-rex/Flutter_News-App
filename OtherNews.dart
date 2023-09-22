import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(OtherNews());
}

class OtherNews extends StatelessWidget {
  const OtherNews({Key? key}) : super(key: key);

  Future<List<NewsArticle>> fetchData() async {
    final apiKey =
        '74a05b1775af4cafaaaffd23a3891d3c'; // Replace with your actual API key
    final url =
        'https://newsapi.org/v2/everything?q=apple&from=2023-09-21&to=2023-09-21&sortBy=popularity&apiKey=74a05b1775af4cafaaaffd23a3891d3c'; // Replace with the API endpoint you want to use

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $apiKey',
    });

    if (response.statusCode == 200) {
      // Parse the API response and return a list of NewsArticle objects.
      return parseNewsArticles(response.body);
    } else {
      // Handle errors
      print('API Request Failed');
      throw Exception('Failed to load data');
    }
  }

  List<NewsArticle> parseNewsArticles(String responseBody) {
    final Map<String, dynamic> parsed = json.decode(responseBody);
    final articles = parsed['articles'];

    return List<NewsArticle>.from(articles.map((article) {
      return NewsArticle(
        title: article['title'],
        imageUrl: article['urlToImage'],
        description: article['description'],
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder<List<NewsArticle>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No data available'),
              );
            } else {
              final articles = snapshot.data!;
              return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return Container(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          textAlign: TextAlign.center,
                          article.title,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 10),
                        article.imageUrl != null
                            ? Image.network(article.imageUrl!)
                            : Placeholder(),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            article.description ?? 'No description available',
                            style: TextStyle(height: 2),
                            textAlign: TextAlign
                                .center, // Center-align the description text
                          ),
                        ),
                        Divider(
                          height: 30,
                          thickness: 5,
                        )
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class NewsArticle {
  final String title;
  final String? imageUrl;
  final String? description;

  NewsArticle({
    required this.title,
    this.imageUrl,
    this.description,
  });
}
