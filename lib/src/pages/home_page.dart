import 'package:flutter/material.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/data_holder.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/lyric.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/about_page.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/detail_page.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/favorite_page.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/privacy_policy_page.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/ui/lyric_list_item.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/ui/custom_appbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Lyric> _lyrics;
  List<Lyric> _favsLyrics;

  Future<List<Lyric>> _getDataFavorite() async {
    List<Lyric> _lyricFav = [];

    await SharedPreferences.getInstance().then((spref) {
      List<String> currentFavs = spref.getStringList('favs');
      if (currentFavs.isNotEmpty) {
        currentFavs.forEach((id) {
          setState(() {
            _lyricFav.add(_lyrics.singleWhere((lyric) => lyric.id == id));
          });
        });
      }
    });

    return _lyricFav;
  }

  @override
  void initState() {
    super.initState();
    _lyrics = DataHolder.dataLyrics;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawerWidget(),
      body: CustomAppbar(_buildLirikLaguWidget(_lyrics)),
    );
  }

  Widget _buildLirikLaguWidget(List<Lyric> lyrics) {
    return lyrics.length != 0 && lyrics != null
        ? ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            itemCount: lyrics != null && lyrics.length > 0 ? lyrics.length : 0,
            itemBuilder: (BuildContext context, int index) =>
                LyricListItem(),
          )
        : Center(
            child: Text('Tidak ada data, pastikan terhubung ke internet'),
          );
  }

  Widget _buildListItem(Lyric lyric) {
    return Card(
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: IconButton(
              icon: lyric.isFavored
                  ? Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : Icon(Icons.favorite_border),
              onPressed: lyric.isFavored
                  ? () {
                      setState(() {
                        lyric.isFavored = false;
                      });
                      SprefUtil.removeFavorite(lyric.id);
                    }
                  : () {
                      setState(() {
                        lyric.isFavored = true;
                      });
                      SprefUtil.storeFavorite(lyric.id);
                    }),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => DetailPage(lyric: lyric)));
            },
          ),
          title: Text(
            lyric.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text('Oleh : ${lyric.maker}'),
        ),
      ),
    );
  }

  Widget _buildDrawerWidget() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DrawerHeader(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  image: DecorationImage(
                      image: AssetImage('assets/indo_flag.jpg'),
                      fit: BoxFit.cover)),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      color: Colors.black54,
                      child: Text(
                        'Kumpulan lirik lagu nasional',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.favorite_border),
                title: Text('Lirik Favorit'),
                onTap: () async {
                  _favsLyrics = await this._getDataFavorite();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => FavoritePage(_favsLyrics)));
                },
              ),
              ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('Privacy Policy'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => PrivacyPolicyPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.apps),
                title: Text('Aplikasi Lainnya'),
                onTap: () async {
                  const url =
                      'https://play.google.com/store/apps/developer?id=RasyidCODE';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('Tentang Aplikasi'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AboutPage()));
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
