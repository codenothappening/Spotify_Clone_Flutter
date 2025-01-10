import 'package:spotify/spotify.dart';
import 'package:spotify_clone/data/api/customstrings.dart';

class Spotifyapi {
  final SpotifyApi spotify;

  Spotifyapi()
      : spotify = SpotifyApi(
          SpotifyApiCredentials(
            CustomStrings.clientId,
            CustomStrings.clientSecretKey,
            scopes: [
              'playlist-read-private',
              'playlist-read-collaborative',
              'user-read-private',
              'user-library-read',
              'user-top-read',
            ],
          ),
        );

  Future<List<Map<String, String>>> fetchAlbums() async {
    try {
      print('Fetching new releases...');
      final newReleases = await spotify.browse.newReleases().all();

      // Convert the albums to a list of maps
      final List<Map<String, String>> albums = newReleases.map((album) {
        final albumImages = album.images ?? [];
        final albumImageUrl =
            albumImages.isNotEmpty ? albumImages.first.url : '';

        return {
          'imageUrl': albumImageUrl ?? '', // Default to an empty string
          'title': album.name ?? 'Unknown Title', // Default to 'Unknown Title'
          'subtitle': album.artists != null && album.artists!.isNotEmpty
              ? album.artists!.first.name ?? 'Unknown Artist'
              : 'Unknown Artist', // Default to 'Unknown Artist'
        };
      }).toList();

      return albums;
    } on SpotifyException catch (e) {
      print('Spotify API Exception: ${e.message}');
      return [];
    } catch (e) {
      print('Unexpected Error: $e');
      return [];
    }
  }

  // Future<List<Map<String, String>>> fetchTopArtists() async {
  //   try {
  //     print("Fetching top artists...");
  //     final artists = await spotify.artists.list([
  //       '3TVXtAsR1Inumwj472S9r4',
  //       '1dfeR4HaWDbWqFHLkxsg1d'
  //     ]); // Replace with artist IDs
  //     final List<Map<String, String>> topArtists = artists.map((artist) {
  //       return {
  //         'name': artist.name ?? "Unknown Artist",
  //         'id': artist.id ?? "",
  //         'imageUrl': artist.images != null && artist.images!.isNotEmpty
  //             ? artist.images!.first.url ?? 'https://via.placeholder.com/100'
  //             : 'https://via.placeholder.com/100',
  //       };
  //     }).toList();

  //     return topArtists;
  //   } on SpotifyException catch (e) {
  //     print('Spotify API Exception: ${e.message}');
  //     return [];
  //   } catch (e) {
  //     print('Unexpected Error: $e');
  //     return [];
  //   }
  // }
  Future<List<Map<String, String>>> fetchTopArtistsInNepal() async {
    try {
      print("Fetching top artists in Nepal...");
      // Fetch new releases in Nepal
      final newReleases =
          await spotify.browse.newReleases(country: Market.IN).all();
      print("New Releases: ${newReleases.length}");

      // Extract artist information from the albums
      final List<Map<String, String>> topArtists = newReleases
          .where((album) => album.artists != null && album.artists!.isNotEmpty)
          .map((album) {
            final artist = album.artists!.first;
            return {
              'name': artist.name ?? "Unknown Artist",
              'id': artist.id ?? "",
              'imageUrl': album.images != null && album.images!.isNotEmpty
                  ? album.images!.first.url ?? 'https://via.placeholder.com/100'
                  : 'https://via.placeholder.com/100',
            };
          })
          .toSet() // Remove duplicates
          .toList();

      return topArtists;
    } on SpotifyException catch (e) {
      print('Spotify API Exception: ${e.message}');
      return [];
    } catch (e) {
      print('Unexpected Error: $e');
      return [];
    }
  }
}
