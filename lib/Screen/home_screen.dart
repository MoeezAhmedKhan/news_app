import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/Modals/categoriesnews_modal.dart';
import 'package:newsapp/Modals/headlines_modal.dart';
import 'package:newsapp/Routing/routes_name.dart';
import 'package:newsapp/Screen/home_screen.dart';
import 'package:newsapp/View_Modal/news_view_modals.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum filterList {
  bbcNews,
  aryNews,
  associatedPress,
  bloomBerg,
  businessInsider,
  cbsNews,
  bbcSport
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModals newsViewModals = NewsViewModals();
  final format = DateFormat("dd MMMM, yyyy");
  filterList? selected;
  String defaultListName = "bbc-news";
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, RoutesName.CategoriesScreen),
            icon: Image.asset(
              "image/category_icon.png",
              width: mediaQuery.width * 0.07,
            )),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "News",
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          PopupMenuButton(
            initialValue: selected,
            onSelected: (filterList list) {
              if (filterList.bbcNews.name == list.name) {
                defaultListName = "bbc-news";
              }
              if (filterList.aryNews.name == list.name) {
                defaultListName = "ary-news";
              }
              if (filterList.associatedPress.name == list.name) {
                defaultListName = "associated-press";
              }
              if (filterList.bbcSport.name == list.name) {
                defaultListName = "bbc-sport";
              }
              if (filterList.businessInsider.name == list.name) {
                defaultListName = "business-insider";
              }
              if (filterList.cbsNews.name == list.name) {
                defaultListName = "cbs-news";
              }

              setState(() {
                selected = list;
              });
            },
            icon: const Icon(
              Icons.more_vert_outlined,
              color: Colors.black,
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: filterList.bbcNews,
                child: Text("BBC News"),
              ),
              const PopupMenuItem(
                value: filterList.aryNews,
                child: Text("ARY News"),
              ),
              const PopupMenuItem(
                value: filterList.associatedPress,
                child: Text("Associated Press"),
              ),
              const PopupMenuItem(
                value: filterList.bbcSport,
                child: Text("BBC Sport"),
              ),
              const PopupMenuItem(
                value: filterList.businessInsider,
                child: Text("Business Insider"),
              ),
              const PopupMenuItem(
                value: filterList.cbsNews,
                child: Text("CBS News"),
              ),
            ],
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: mediaQuery.height * 0.5,
            /*50% of the screen*/
            width: mediaQuery.width,
            child: FutureBuilder<HeadlinesModal>(
              future: newsViewModals.fetchNewsHeadlines(defaultListName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 190, 81, 90),
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: mediaQuery.width * 0.8,
                          height: mediaQuery.height * 0.5,
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  // Handle error state
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      return InkWell(
                        onTap: () => Navigator.pushNamed(
                            context, RoutesName.NewsDetailsScreen,
                            arguments: {
                              "newsTitle": snapshot.data!.articles![index].title
                                  .toString(),
                              "newsImage": snapshot
                                  .data!.articles![index].urlToImage
                                  .toString(),
                              "newsDate": format.format(dateTime),
                              "author": snapshot.data!.articles![index].author
                                  .toString(),
                              "description": snapshot
                                  .data!.articles![index].description
                                  .toString(),
                              "content": snapshot.data!.articles![index].content
                                  .toString(),
                              "source": snapshot.data!.articles![index].source
                                  .toString(),
                            }),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: mediaQuery.height * 0.5,
                              width: mediaQuery.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: mediaQuery.width * 0.02),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    errorWidget: (context, url, error) => Image.asset("image/null.png"),
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString() ?? ''),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    color: Colors.white,
                                    alignment: Alignment.bottomCenter,
                                    height: mediaQuery.height * 0.22,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          width: mediaQuery.width * 0.8,
                                          child: Text(
                                            snapshot
                                                .data!.articles![index].title
                                                .toString(),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          color: Colors.white,
                                          width: mediaQuery.width * 0.8,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.articles![index]
                                                    .source!.id
                                                    .toString()
                                                    .toUpperCase(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                format.format(dateTime),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: FutureBuilder<CategoriesnewsModal>(
              future: newsViewModals.fetchNewsCategories("general"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 190, 81, 90),
                        highlightColor: Colors.grey.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  color: Colors.white,
                                  height: mediaQuery.height * 0.18,
                                  width: mediaQuery.width * 0.3,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: mediaQuery.height * 0.18,
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        height: mediaQuery.height * 0.06,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            color: Colors.white,
                                            height: mediaQuery.height * 0.03,
                                            width: mediaQuery.width * 0.20,
                                          ),
                                          Container(
                                            color: Colors.white,
                                            height: mediaQuery.height * 0.03,
                                            width: mediaQuery.width * 0.20,
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
                } else if (snapshot.hasError) {
                  // Handle error state
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                                "author": snapshot.data!.articles![index].author
                                    .toString(),
                                "description": snapshot
                                    .data!.articles![index].description
                                    .toString(),
                                "content": snapshot
                                    .data!.articles![index].content
                                    .toString(),
                                "source": snapshot.data!.articles![index].source
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            (snapshot.data!.articles![index]
                                                        .source!.name!.length >
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
    );
  }
}
