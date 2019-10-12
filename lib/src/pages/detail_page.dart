import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/models/entity/lyric_entity.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/ui/control_audio_button.dart';
import 'package:kumpulan_lirik_lagu_kebangsaan/src/utils.dart';
import 'package:url_launcher/url_launcher.dart';

enum PlayerState { stopped, playing, paused }

class DetailPage extends StatefulWidget {
  final LyricEntity lyric;

  DetailPage({@required this.lyric});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;
  PlayerMode _mode;

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubs;
  StreamSubscription _positionSubs;
  StreamSubscription _playerCompleteSubs;
  StreamSubscription _playerErrorSubs;
  StreamSubscription _playerStateSubs;

  get _isPlaying => _playerState == PlayerState.playing;
  get _isPaused => _playerState == PlayerState.paused;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  LyricEntity lyric;

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: _mode);

    _durationSubs = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _positionSubs = _audioPlayer.onAudioPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });

    _playerCompleteSubs = _audioPlayer.onPlayerCompletion.listen((event) {
      _onCompleted();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubs = _audioPlayer.onPlayerError.listen((msg) {
      print('audio player : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });
  }

  void _onCompleted() {
    setState(() {
      _playerState = PlayerState.stopped;
    });

    print('song ended.');
    AdsUtil.showInterstitialAd();
  }

  Future<int> _play(String url) async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(url, position: playPosition);
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.playing;
      });
    }

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);

    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    lyric = widget.lyric;
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _durationSubs?.cancel();
    _positionSubs?.cancel();
    _playerCompleteSubs?.cancel();
    _playerErrorSubs?.cancel();
    _playerStateSubs?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size querySize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(lyric.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Image.network(
                lyric.coverImageUrl,
                fit: BoxFit.cover,
                height: querySize.height * .3,
                width: double.infinity,
              ),
              Container(
                height: querySize.height * .3,
                width: double.infinity,
                color: Colors.black54,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ControlAudioButton(
                            icon: Icons.play_arrow,
                            color: _isPlaying ? Colors.white70 : Colors.white,
                            onPressed:
                                _isPlaying ? null : () => _play(lyric.audioUrl),
                          ),
                          ControlAudioButton(
                            icon: Icons.pause,
                            color: _isPaused ? Colors.white70 : Colors.white,
                            onPressed: _isPlaying ? () => _pause() : null,
                          ),
                          ControlAudioButton(
                            icon: Icons.stop,
                            color: !_isPlaying && !_isPaused
                                ? Colors.white70
                                : Colors.white,
                            onPressed:
                                _isPlaying || _isPaused ? () => _stop() : null,
                          ),
                        ],
                      ),
                      Slider(
                        onChanged: (v) {
                          final position = v * _duration.inMilliseconds;
                          _audioPlayer
                              .seek(Duration(milliseconds: position.round()));
                        },
                        value: (_position != null &&
                                _duration != null &&
                                _position.inMilliseconds > 0 &&
                                _position.inMilliseconds <
                                    _duration.inMilliseconds)
                            ? _position.inMilliseconds /
                                _duration.inMilliseconds
                            : 0.0,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white54,
                      ),
                      Text(
                        _position != null
                            ? '${_positionText ?? ''} / ${_durationText ?? ''}'
                            : _duration != null ? _durationText : '',
                        style: TextStyle(fontSize: 24.0, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
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
                      SelectableText(
                        lyric.lyrics.replaceAll('\\n', '\n'),
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 20.0),
                      Divider(),
                      Text(
                        'Credit : ',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Text(
                            'Image Source : ',
                            style: TextStyle(
                                color: Colors.black87,
                                fontStyle: FontStyle.italic,
                                fontSize: 12.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: GestureDetector(
                              onTap: () async {
                                String url = lyric.coverImageSource;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Text(
                                'link',
                                style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12.0),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Audio Source : ',
                            style: TextStyle(
                                color: Colors.black87,
                                fontStyle: FontStyle.italic,
                                fontSize: 12.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: GestureDetector(
                              onTap: () async {
                                String url =
                                    'https://www.youtube.com/watch?v=${lyric.videoId}';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Text(
                                'link',
                                style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12.0),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 50.0,
            width: double.infinity,
            color: Colors.transparent,
          )
        ],
      ),
    );
  }
}
