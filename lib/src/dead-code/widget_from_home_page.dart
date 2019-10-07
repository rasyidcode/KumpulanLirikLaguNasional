//  Widget _buildListItem(Lyric lyric) {
//     return Card(
//       elevation: 1.0,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListTile(
//           leading: IconButton(
//               icon: lyric.isFavored
//                   ? Icon(
//                       Icons.favorite,
//                       color: Colors.red,
//                     )
//                   : Icon(Icons.favorite_border),
//               onPressed: lyric.isFavored
//                   ? () {
//                       setState(() {
//                         lyric.isFavored = false;
//                       });
//                       SprefUtil.removeFavorite(lyric.id);
//                     }
//                   : () {
//                       setState(() {
//                         lyric.isFavored = true;
//                       });
//                       SprefUtil.storeFavorite(lyric.id);
//                     }),
//           trailing: IconButton(
//             icon: Icon(Icons.arrow_forward_ios),
//             onPressed: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                   builder: (BuildContext context) => DetailPage(lyric: lyric)));
//             },
//           ),
//           title: Text(
//             lyric.title,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           subtitle: Text('Oleh : ${lyric.maker}'),
//         ),
//       ),
//     );
//   }

// Future<List<Lyric>> _getDataFavorite() async {
//     List<Lyric> _lyricFav = [];

//     await SharedPreferences.getInstance().then((spref) {
//       List<String> currentFavs = spref.getStringList('favs');
//       if (currentFavs.isNotEmpty) {
//         currentFavs.forEach((id) {
//           setState(() {
//             _lyricFav.add(_lyrics.singleWhere((lyric) => lyric.id == id));
//           });
//         });
//       }
//     });

//     return _lyricFav;
//   }
