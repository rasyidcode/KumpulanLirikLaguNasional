import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/data/repository.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/entity/lyric_entity.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/detail_page.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/utils.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  void onFavoritePressed(LyricEntity lyric) async {
    Repository.get().removeItAsFavorite(lyric.id);
    setState(() {
      lyric.isFavored = false;
    });
  }

  @override
  void initState() {
    super.initState();

    AdsUtil.hideBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lirik Favorit',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      body: FutureBuilder(
        future: Repository.get().getFavoriteLyrics(),
        builder:
            (BuildContext context, AsyncSnapshot<List<LyricEntity>> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text('somethin worng occured'),
            );
          }

          return snapshot.hasData
              ? snapshot.data.length != 0
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      itemCount:
                          snapshot.data != null && snapshot.data.length > 0
                              ? snapshot.data.length
                              : 0,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildCardWidget(snapshot.data[index]);
                      },
                    )
                  : Center(
                      child: Text('Data favorit belum ada.'),
                    )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  Widget _buildCardWidget(LyricEntity lyric) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => DetailPage(lyric: lyric),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 1.0,
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: lyric.coverImageUrl,
              placeholder: (_, __) => CircularProgressIndicator(
                value: 5,
                strokeWidth: 2,
              ),
              errorWidget: (_, __, ___) => Icon(Icons.error),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Column(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 8.0),
                  width: double.infinity,
                  color: Colors.black54,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              lyric.title,
                              style: Theme.of(context).textTheme.title.copyWith(
                                  fontSize: 14.0, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              lyric.maker,
                              style: Theme.of(context).textTheme.body1.copyWith(
                                  color: Colors.white70, fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30.0),
                          onTap: () => onFavoritePressed(lyric),
                          child: Container(
                            height: 30.0,
                            width: 30.0,
                            child: Icon(
                              Icons.favorite,
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
