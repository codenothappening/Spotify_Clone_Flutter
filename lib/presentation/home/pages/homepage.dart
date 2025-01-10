import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as image;
import 'package:flutter_svg/svg.dart';

import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/core/configs/assets/app_images.dart';
import 'package:spotify_clone/core/configs/assets/app_vectors.dart';
import 'package:spotify_clone/data/api/spotifyapi.dart';
import 'package:spotify_clone/presentation/home/widgets/artist_card.dart';

import 'package:spotify_clone/presentation/home/widgets/card.dart';
import 'package:spotify_clone/presentation/player/music_player.dart';

import '../../../core/configs/theme/app_color.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Map<String, String>>> _albumsFuture;

  late Future<List<Map<String, String>>> _topArtists;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _albumsFuture = Spotifyapi().fetchAlbums();
    // _topArtists = Spotifyapi().fetchTopArtists();
    _topArtists = Spotifyapi().fetchTopArtistsInNepal();
    // _topArtists = Spotifyapi().fetchNepaliArtists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 70),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        size: 35,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        height: 33,
                        AppVectors.logo,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert,
                        size: 35,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _homeTopCard(),
                        _tabs(),
                        SizedBox(
                          height: 300,
                          child: Row(
                            children: [
                              Expanded(
                                child: FutureBuilder<List<Map<String, String>>>(
                                  future: _albumsFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return const Center(
                                        child: Text(
                                          'Failed to load data',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      );
                                    } else if (snapshot.hasData &&
                                        snapshot.data!.isEmpty) {
                                      return const Center(
                                          child: Text('No data found.'));
                                    }

                                    final albums = snapshot.data!;
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: albums.length,
                                      itemBuilder: (context, index) {
                                        final album = albums[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 16.0,
                                          ),
                                          child: CardWidget(
                                            imageUrl: album['imageUrl']!,
                                            title: album['title']!,
                                            subtitle: album['subtitle']!,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MusicPlayer(
                                                    title: album['title'] ?? "",
                                                    subtitle:
                                                        album['subtitle'] ?? "",
                                                    imageUrl:
                                                        album['imageUrl'] ?? "",
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Top Artists",
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          height: 150,
                          child: FutureBuilder<List<Map<String, String>>>(
                              future: _topArtists,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return const Center(
                                    child: Text(
                                      'Failed to load data',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                } else if (snapshot.hasData &&
                                    snapshot.data!.isEmpty) {
                                  return const Center(
                                      child: Text('No data found.'));
                                }

                                final topArtists = snapshot.data!;
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: topArtists.length,
                                  itemBuilder: (context, index) {
                                    final topArtist = topArtists[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        right: 16.0,
                                      ),
                                      child: ArtistCard(
                                        artistImageUrl: topArtist['imageUrl'] ??
                                            "https://via.placeholder.com/100",
                                        title: topArtist['name'] ??
                                            "Unknown Artist",
                                        onTap: () {},
                                      ),
                                    );
                                  },
                                );
                              }),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Your Mood",
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _homeTopCard() {
    return Center(
      child: Container(
        height: 160, // Total height of the red container

        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Full height image

            // Content
            Container(
              height: 120,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New Album",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Happier Than Ever",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Billie Eilish",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: image.Image.asset(
                  AppImages.homePageTop,
                  fit: BoxFit.cover, // Make the image fill the space
                  // Set width for alignment
                  height: 188, // Match container height
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return TabBar(
      tabAlignment: TabAlignment.start,
      controller: _tabController,
      isScrollable: true,
      labelColor: context.isDarkMode ? Colors.white : Colors.black,
      indicatorColor: AppColor.primary,
      indicatorSize: TabBarIndicatorSize.label,
      padding: const EdgeInsets.symmetric(vertical: 40),
      dividerColor: Colors.transparent,
      tabs: const [
        Text(
          "New",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 19,
          ),
        ),
        Text(
          "Video",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 19,
          ),
        ),
        Text(
          "Artist",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 19,
          ),
        ),
        Text(
          "Podcast",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 19,
          ),
        ),
      ],
    );
  }
}
