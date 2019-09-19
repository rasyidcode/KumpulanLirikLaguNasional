import 'package:flutter/material.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/lyric.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailPage extends StatefulWidget {
  final Lyric lyric;

  DetailPage({@required this.lyric});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Lyric lyric;

  @override
  void initState() {
    super.initState();
    lyric = widget.lyric;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lyric.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              YoutubePlayer(
                width: double.infinity,
                context: context,
                videoId: lyric.videoId,
                flags: YoutubePlayerFlags(
                  autoPlay: false,
                  hideFullScreenButton: true,
                ),
              ),
              Positioned(
                bottom: 4.0,
                right: 4.0,
                              child: GestureDetector(
                  child: Text(
                    'Watch on Youtube',
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0),
                  ),
                  onTap: () async {
                    String url = 'https://www.youtube.com/watch?v=${lyric.videoId}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Connot launch url $url';
                    }
                  },
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${lyric.title}',
                        style: TextStyle(
                            fontSize: 23.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87),
                      ),
                      Text(
                        'Oleh : ${lyric.maker}',
                        style: TextStyle(color: Colors.black54),
                      ),
                      Divider(),
                      Text(
                        'Lirik Lagu',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        lyric.lyrics.replaceAll('\\n', '\n'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
