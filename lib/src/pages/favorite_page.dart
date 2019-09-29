import 'package:flutter/material.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/lyric.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/detail_page.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/utils.dart';

class FavoritePage extends StatefulWidget {
  final List<Lyric> lyrics;

  FavoritePage(this.lyrics);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lirik Favorit'),
      ),
      body: widget.lyrics.length != 0 && widget.lyrics != null ? ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            itemCount: widget.lyrics != null && widget.lyrics.length > 0 ? widget.lyrics.length : 0,
            itemBuilder: (BuildContext context, int index) {
              return _buildListItem(widget.lyrics[index]);
            },
          )
        : Center(
            child: Text('Belum ada daftar favorite'),
          )
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
}