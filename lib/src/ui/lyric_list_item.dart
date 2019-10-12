import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/entity/lyric_entity.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/pages/detail_page.dart';

class LyricListItem extends StatelessWidget {
  final LyricEntity lyric;
  final Function onFavoriteButtonPressed;
  final Function onCardPressed;
  final Icon icon;

  LyricListItem(
      {@required this.lyric,
      @required this.onFavoriteButtonPressed,
      @required this.icon,
      @required this.onCardPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardPressed,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          child: Row(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl:
                    lyric.coverImageUrl,
                placeholder: (_, __) => CircularProgressIndicator(value: 5, strokeWidth: 2,),
                errorWidget: (_, __, ___) => Icon(Icons.error),
                fit: BoxFit.cover,
                width: 80.0,
                height: 60.0,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        lyric.title,
                        style: TextStyle(fontSize: 14.0, color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        lyric.maker,
                        style: TextStyle(color: Colors.black54, fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ),
              IconButton(onPressed: onFavoriteButtonPressed, icon: icon)
            ],
          ),
        ),
      ),
    );
  }
}
