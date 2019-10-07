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
import 'package:kumpulan_lirik_lagu_kebangsaan/src/personal/admob.dart'
    show APP_ID;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Lyric> _lyrics;

  @override
  void initState() {
    super.initState();
    _lyrics = DataHolder.dataLyrics;
    AdsUtil.initialize();
    AdsUtil.showBannerAd();
  }

  @override
  void dispose() {
    AdsUtil.hideBannerAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawerWidget(),
      body: Column(
        children: <Widget>[
          Expanded(child: CustomAppbar(_buildLirikLaguWidget(_lyrics))),
          Container(
            height: 50.0,
            width: double.infinity,
            color: Colors.transparent,
          )
        ],
      ),
    );
  }

  Widget _buildLirikLaguWidget(List<Lyric> lyrics) {
    return lyrics.length != 0 && lyrics != null
        ? ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            itemCount: lyrics != null && lyrics.length > 0 ? lyrics.length : 0,
            itemBuilder: (BuildContext context, int index) => LyricListItem(
              onCardPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => DetailPage(
                      lyric: lyrics[index],
                    ),
                  ),
                );
              },
              icon: lyrics[index].isFavored
                  ? Icon(
                      Icons.favorite,
                      color: Colors.pink,
                    )
                  : Icon(Icons.favorite_border),
              lyric: lyrics[index],
              onFavoriteButtonPressed: lyrics[index].isFavored
                  ? () {
                      setState(() {
                        lyrics[index].isFavored = false;
                      });
                      SprefUtil.removeFavorite(lyrics[index].id);
                      SprefUtil.adsCounter();
                    }
                  : () {
                      setState(() {
                        lyrics[index].isFavored = true;
                      });
                      SprefUtil.storeFavorite(lyrics[index].id);
                      SprefUtil.adsCounter();
                    },
            ),
          )
        : Center(
            child: Text('Tidak ada data, pastikan terhubung ke internet'),
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
                leading: Icon(
                  Icons.favorite,
                  color: Colors.pink,
                ),
                title: Text('Lirik Favorit'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (BuildContext context) => FavoritePage()))
                      .then((value) {
                    AdsUtil.showBannerAd();
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.lock_outline, color: Colors.black),
                title: Text('Privacy Policy'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              PrivacyPolicyPage()))
                      .then((value) {
                    AdsUtil.showBannerAd();
                  });
                  ;
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.apps,
                  color: Colors.green,
                ),
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
                leading: Icon(
                  Icons.info,
                  color: Colors.blue,
                ),
                title: Text('About'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (BuildContext context) => AboutPage()))
                      .then((value) {
                    AdsUtil.showBannerAd();
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
