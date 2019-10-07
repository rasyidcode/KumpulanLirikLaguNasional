// Stack(
//   children: <Widget>[
//     YoutubePlayer(
//       width: double.infinity,
//       context: context,
//       videoId: lyric.videoId,
//       flags: YoutubePlayerFlags(
//         autoPlay: false,
//         hideFullScreenButton: true,
//       ),
//     ),

//     Positioned(
//       bottom: 4.0,
//       right: 4.0,
//                     child: GestureDetector(
//         child: Text(
//           'Watch on Youtube',
//           style: TextStyle(
//               color: Colors.white70,
//               fontWeight: FontWeight.bold,
//               fontSize: 25.0),
//         ),
//         onTap: () async {
//           String url = 'https://www.youtube.com/watch?v=${lyric.videoId}';
//           if (await canLaunch(url)) {
//             await launch(url);
//           } else {
//             throw 'Connot launch url $url';
//           }
//         },
//       ),
//     )
//   ],
// ),

// Material(
//   shape: OutlineInputBorder(
//     borderSide: BorderSide(
//         color: _isPlaying
//             ? Colors.white70
//             : Colors.white,
//         width: 2.0),
//     borderRadius: BorderRadius.circular(50.0),
//   ),
//   color: Colors.transparent,
//   child: InkWell(
//     borderRadius: BorderRadius.circular(50.0),
//     onTap: _isPlaying
//         ? null
//         : () => _play(lyric.audioUrl),
//     child: Container(
//       width: 50.0,
//       height: 50.0,
//       child: Icon(
//         Icons.play_arrow,
//         size: 30.0,
//         color: _isPlaying
//             ? Colors.white70
//             : Colors.white,
//       ),
//     ),
//   ),
// ),
// Material(
//   shape: OutlineInputBorder(
//     borderSide: BorderSide(
//         color:
//             _isPaused ? Colors.white70 : Colors.white,
//         width: 2.0),
//     borderRadius: BorderRadius.circular(50.0),
//   ),
//   color: Colors.transparent,
//   child: InkWell(
//     borderRadius: BorderRadius.circular(50.0),
//     onTap: _isPlaying ? () => _pause() : null,
//     child: Container(
//       width: 50.0,
//       height: 50.0,
//       child: Icon(
//         Icons.pause,
//         size: 30.0,
//         color:
//             _isPaused ? Colors.white70 : Colors.white,
//       ),
//     ),
//   ),
// ),
// Material(
//   shape: OutlineInputBorder(
//     borderSide: BorderSide(
//         color: !_isPlaying && !_isPaused
//             ? Colors.white70
//             : Colors.white,
//         width: 2.0),
//     borderRadius: BorderRadius.circular(50.0),
//   ),
//   color: Colors.transparent,
//   child: InkWell(
//     borderRadius: BorderRadius.circular(50.0),
//     onTap: _isPlaying || _isPaused
//         ? () => _stop()
//         : null,
//     child: Container(
//       width: 50.0,
//       height: 50.0,
//       child: Icon(
//         Icons.stop,
//         size: 30.0,
//         color: !_isPlaying && !_isPaused
//             ? Colors.white70
//             : Colors.white,
//       ),
//     ),
//   ),
// ),
