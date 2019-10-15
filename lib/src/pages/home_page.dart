import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/data/repository.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/entity/lyric_entity.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/about_page.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/detail_page.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/favorite_page.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/privacy_policy_page.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/ui/lyric_list_item.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/ui/custom_appbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final PublishSubject<String> _subject = PublishSubject<String>();
  bool _isLoading = false;
  List<LyricEntity> _lyrics = <LyricEntity>[];

  void _textChanged(String value) {
    setState(() {
      _isLoading = true;
    });
    _clearList();

    Repository.get().getLyrics(value).then((data) {
      setState(() {
        _isLoading = false;
        _lyrics = data;
      });
    });
  }

  void _clearList() {
    setState(() {
      _lyrics.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    AdsUtil.initialize();
    AdsUtil.showBannerAd();

    _subject.stream
        .debounce((String _) => TimerStream(true, Duration(milliseconds: 600)))
        .listen(_textChanged);

    _isLoading = true;

    Repository.get().getLyrics('').then((data) {
      setState(() {
        _lyrics = data;
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    AdsUtil.hideBannerAd();
    _subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawerWidget(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: CustomAppbar(body: _buildLirikLaguWidget()),
          ),
          Container(
            height: AdSize.banner.height.toDouble(),
            width: double.infinity,
            color: Colors.transparent,
          )
        ],
      ),
    );
  }

  Widget _buildLirikLaguWidget() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 20.0,
          ),
          child: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26.0),
                  borderSide: BorderSide(width: 1.0)),
              hintText: 'Cari Lirik Lagu',
              hintStyle: TextStyle(fontSize: 16.0),
            ),
            onChanged: (String value) => (_subject.add(value)),
          ),
        ),
        !_isLoading
            ? Column(
                children: _lyrics.map((lyric) {
                  return LyricListItem(
                    onCardPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => DetailPage(
                            lyric: lyric,
                          ),
                        ),
                      );
                    },
                    icon: lyric.isFavored
                        ? Icon(
                            Icons.favorite,
                            color: Colors.pink,
                          )
                        : Icon(Icons.favorite_border),
                    lyric: lyric,
                    onFavoriteButtonPressed: lyric.isFavored
                        ? () {
                            setState(() {
                              lyric.isFavored = false;
                            });
                            Repository.get().removeItAsFavorite(lyric.id);
                            // SprefUtil.adsCounter();
                          }
                        : () {
                            setState(() {
                              lyric.isFavored = true;
                            });
                            Repository.get().makeItFavorite(lyric.id);
                            // SprefUtil.adsCounter();
                          },
                  );
                }).toList(),
              )
            : Center(child: CircularProgressIndicator())
      ],
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
