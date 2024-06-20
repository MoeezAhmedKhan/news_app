import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/Modals/categoriesnews_modal.dart';
import 'package:newsapp/Routing/routes_name.dart';
import 'package:newsapp/View_Modal/news_view_modals.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModals newsViewModals = NewsViewModals();
  final format = DateFormat("dd MMMM, yyyy");
  String defaultCategoryName = "general";
  List<String> categoryList = [
    "General",
    "Entertainment",
    "Health",
    "Sports",
    "Business",
    "Technology"
  ];
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * 0.010),
        child: Column(
          children: [
            SizedBox(
              height: mediaQuery.height * 0.07,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      defaultCategoryName = categoryList[index];
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.4),
                            spreadRadius: 1,
                            blurRadius: 7,
                          ),
                        ],
                        color: defaultCategoryName == categoryList[index]
                            ? Colors.blue
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            categoryList[index].toString(),
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: mediaQuery.height * 0.010,
            ),
            Expanded(
              child: FutureBuilder<CategoriesnewsModal>(
                future: newsViewModals.fetchNewsCategories(defaultCategoryName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: SpinKitPianoWave(
                      color: const Color(0xffbd1524),
                      size: mediaQuery.height * 0.04, /*4% of the screen */
                    ));
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutesName.NewsDetailsScreen,
                                arguments: {
                                  "newsTitle": snapshot
                                      .data!.articles![index].title
                                      .toString(),
                                  "newsImage": snapshot
                                      .data!.articles![index].urlToImage
                                      .toString(),
                                  "newsDate": format.format(dateTime),
                                  "author": snapshot
                                      .data!.articles![index].author
                                      .toString(),
                                  "description": snapshot
                                      .data!.articles![index].description
                                      .toString(),
                                  "content": snapshot
                                      .data!.articles![index].content
                                      .toString(),
                                  "source": snapshot
                                      .data!.articles![index].source
                                      .toString(),
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      height: mediaQuery.height * 0.18,
                                      width: mediaQuery.width * 0.3,
                                      placeholder: (context, url) => Container(
                                            child: Center(
                                              child: SpinKitPianoWave(
                                                color: const Color(0xffbd1524),
                                                size: mediaQuery.height *
                                                    0.04, /*4% of the screen */
                                              ),
                                            ),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                            "image/null.png",
                                          ),
                                      imageUrl: snapshot
                                              .data!.articles![index].urlToImage
                                              .toString() ??
                                          ''),
                                ),
                                Expanded(
                                  child: Container(
                                    height: mediaQuery.height * 0.18,
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                          maxLines: 3,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              (snapshot
                                                          .data!
                                                          .articles![index]
                                                          .source!
                                                          .name!
                                                          .length >
                                                      10)
                                                  ? snapshot
                                                          .data!
                                                          .articles![index]
                                                          .source!
                                                          .name!
                                                          .substring(0, 10) +
                                                      '...'
                                                  : snapshot
                                                      .data!
                                                      .articles![index]
                                                      .source!
                                                      .name!,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300),
                                              maxLines: 3,
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300),
                                              maxLines: 3,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
