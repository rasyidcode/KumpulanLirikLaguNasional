import 'package:flutter/material.dart';

class LyricListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        child: Row(
          children: <Widget>[
            Image.asset(
              'assets/indo_flag.jpg',
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
                      'Judul Lagu Adalah Something That You will never noticed',
                      style: TextStyle(fontSize: 14.0, color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      'Wr. Supratman',
                      style: TextStyle(color: Colors.black54, fontSize: 12.0),
                    )
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                print('favs');
              },
              icon: Icon(Icons.favorite_border),
            )
          ],
        ),
      ),
    );
  }
}
