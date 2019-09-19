import 'package:flutter/material.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/data_holder.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/lyric.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/about_page.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/detail_page.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/privacy_policy_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Lyric> _lyrics;

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

  void _storeFavorite(String id) {
    SharedPreferences.getInstance().then((spref) {
      if (spref.getStringList('favs').isEmpty) {
        List<String> currentFavs = [];
        currentFavs.add(id);
        spref.setStringList('favs', currentFavs);
      } else {
        List<String> currentFavs = spref.getStringList('favs');
        currentFavs.add(id);
        spref.setStringList('favs', currentFavs);
      }
    });
  }

  void _removeFavorite(String id) {
    SharedPreferences.getInstance().then((spref) {
      List<String> currentFavs = spref.getStringList('favs');
      currentFavs.removeWhere((sprefId) => sprefId == id);
      spref.setStringList('favs', currentFavs);
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _lyrics = DataHolder.dataLyrics;
    // DataHolder.dataLyrics.where((lyric) => lyric.isFavored == true).forEach((lyric) {
    //   _lyricFavs.add(lyric);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lirik Lagu Nasional'),
      ),
      drawer: _buildDrawerWidget(),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _buildLirikLaguWidget(_lyrics),
          FutureBuilder<List<Lyric>>(
            future: this._getDataFavorite(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Lyric>> snapshot) {
              return snapshot.hasData
                  ? _buildFavoriteWidget(snapshot.data)
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            },
          )
        ],
      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).primaryColor,
        child: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.list,
              ),
              text: 'Daftar Lirik',
            ),
            Tab(
              icon: Icon(
                Icons.favorite,
              ),
              text: 'Favorite',
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLirikLaguWidget(List<Lyric> lyrics) {
    return lyrics.length != 0 && lyrics != null
        ? ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            itemCount: lyrics != null && lyrics.length > 0 ? lyrics.length : 0,
            itemBuilder: (BuildContext context, int index) =>
                _buildListItem(lyrics[index]),
          )
        : Center(
            child: Text('Tidak ada data, pastikan terhubung ke internet'),
          );
  }

  Widget _buildFavoriteWidget(List<Lyric> lyrics) {
    return lyrics.length != 0 && lyrics != null
        ? ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            itemCount: lyrics != null && lyrics.length > 0 ? lyrics.length : 0,
            itemBuilder: (BuildContext context, int index) {
              return _buildListItem(lyrics[index]);
            },
          )
        : Center(
            child: Text('Belum ada daftar favorite'),
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
                    _removeFavorite(lyric.id);
                  }
                : () {
                    setState(() {
                      lyric.isFavored = true;
                    });
                    _storeFavorite(lyric.id);
                  },
          ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => DetailPage(lyric: lyric)
              ));
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
                leading: Icon(Icons.lock_outline),
                title: Text('Privacy Policy'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => PrivacyPolicyPage()
                  ));
                },
              ),
              ListTile(
                leading: Icon(Icons.apps),
                title: Text('Aplikasi Lainnya'),
                onTap: () async {
                  const url = 'https://play.google.com/store/apps/developer?id=RasyidCODE';
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
                    builder: (BuildContext context) => AboutPage()
                  ));
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
