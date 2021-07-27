import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'AudioPlayerTask.dart';

class BGAudioPlayerScreen extends StatefulWidget {
  MediaItem item;
  BGAudioPlayerScreen(this.item);
  @override
  _BGAudioPlayerScreenState createState() => _BGAudioPlayerScreenState(item);
}

class _BGAudioPlayerScreenState extends State<BGAudioPlayerScreen> {
  final BehaviorSubject<double> _dragPositionSubject =
      BehaviorSubject.seeded(null);
  MediaItem item;
  _BGAudioPlayerScreenState(item) {
    _queue = <MediaItem>[item];
  }

  var _queue;
  // MediaItem(
  //   id: "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
  //   album: "Science Friday",
  //   title: "A Salute To Head-Scratching Science",
  //   artist: "Science Friday and WNYC Studios",
  //   duration: Duration(milliseconds: 5739820),
  //   artUri:
  //   "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
  // ),
  // MediaItem(
  //   id: "https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3",
  //   album: "Science Friday",
  //   title: "From Cat Rheology To Operatic Incompetence",
  //   artist: "Science Friday and WNYC Studios",
  //   duration: Duration(milliseconds: 2856950),
  //   artUri:
  //   "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
  // ),
  // ];

  bool _loading;
  // List<MediaItem> _queue;

  @override
  void initState() {
    // _queue = widget._queue;
    print(_queue);
    super.initState();
    _startAudioPlayerBtn();
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Audio Player'),
      // ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          color: Colors.white,
          child: StreamBuilder<AudioState>(
            stream: _audioStateStream,
            builder: (context, snapshot) {
              final audioState = snapshot.data;
              final queue = audioState?.queue;
              final mediaItem = audioState?.mediaItem;
              final playbackState = audioState?.playbackState;
              final processingState =
                  playbackState?.processingState ?? AudioProcessingState.none;
              final playing = playbackState?.playing ?? false;
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // if (processingState == AudioProcessingState.none)
                    //   ...[
                    //   _startAudioPlayerBtn(),
                    // ] else
                    //   ...[
                    //positionIndicator(mediaItem, playbackState),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x46000000),
                            offset: Offset(0, 20),
                            spreadRadius: 0,
                            blurRadius: 30,
                          ),
                          BoxShadow(
                            color: Color(0x11000000),
                            offset: Offset(0, 10),
                            spreadRadius: 0,
                            blurRadius: 30,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          image: NetworkImage(mediaItem?.artUri != null
                              ? mediaItem.artUri
                              : ''),
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.width * 0.7,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    if (mediaItem?.album != null)
                      Text(
                        mediaItem.album,
                        style: TextStyle(fontSize: 20),
                      ),
                    SizedBox(height: 10),
                    if (mediaItem?.title != null) Text(mediaItem.title),
                    SizedBox(height: 10),
                    if (mediaItem?.artist != null) Text(mediaItem.artist),
                    SizedBox(height: 10),
                    if (mediaItem?.id != null)
                      positionIndicator(mediaItem, playbackState),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios_sharp),
                          iconSize: 40.0,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        !playing
                            ? IconButton(
                                icon: Icon(Icons.play_arrow),
                                iconSize: 64.0,
                                onPressed: () async {
                                  print(processingState);
                                  if (processingState ==
                                      AudioProcessingState.none) {
                                    _startAudioPlayerBtn();
                                  }
                                  AudioService.play();
                                },
                              )
                            : IconButton(
                                icon: Icon(Icons.pause),
                                iconSize: 64.0,
                                onPressed: AudioService.pause,
                              ),
                        playing || processingState == AudioProcessingState.ready
                            ? IconButton(
                                icon: Icon(Icons.stop),
                                iconSize: 64.0,
                                onPressed: () async {
                                  print(processingState);
                                  await AudioService.stop();
                                },
                              )
                            : Container(),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     IconButton(
                        //       icon: Icon(Icons.skip_previous),
                        //       iconSize: 64,
                        //       onPressed: () {
                        //         if (mediaItem == queue.first) {
                        //           return;
                        //         }
                        //         AudioService.skipToPrevious();
                        //       },
                        //     ),
                        //     IconButton(
                        //       icon: Icon(Icons.skip_next),
                        //       iconSize: 64,
                        //       onPressed: () {
                        //         if (mediaItem == queue.last) {
                        //           return;
                        //         }
                        //         AudioService.skipToNext();
                        //       },
                        //     )
                        //   ],
                        // ),
                      ],
                    )
                    // ]
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _startAudioPlayerBtn() async {
    List<dynamic> list = List();
    for (int i = 0; i < _queue.length; i++) {
      var m = _queue[i].toJson();
      list.add(m);
    }
    var params = {"data": list};
    // return MaterialButton(
    //   child: Text(_loading ? "Loading..." : 'Start Audio Player'),
    //   onPressed: () async {
    //     setState(() {
    //       _loading = true;
    //     });
    //     await AudioService.connect();
    //     await AudioService.start(
    //       backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
    //       androidNotificationChannelName: 'Audio Player',
    //       androidNotificationColor: 0xFF2196f3,
    //       androidNotificationIcon: 'mipmap/ic_launcher',
    //       params: params,
    //     );
    //     setState(() {
    //       _loading = false;
    //     });
    //   },
    // );
    await AudioService.connect();
    await AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
      androidNotificationChannelName: 'Audio Player',
      androidNotificationColor: 0xFF2196f3,
      androidNotificationIcon: 'mipmap/ic_launcher',
      params: params,
    );
  }

  Widget positionIndicator(MediaItem mediaItem, PlaybackState state) {
    double seekPos;
    return StreamBuilder(
      stream: Rx.combineLatest2<double, double, double>(
          _dragPositionSubject.stream,
          Stream.periodic(Duration(milliseconds: 200)),
          (dragPosition, _) => dragPosition),
      builder: (context, snapshot) {
        double position =
            snapshot.data ?? state.currentPosition.inMilliseconds.toDouble();
        double duration = mediaItem?.duration?.inMilliseconds?.toDouble();
        return Column(
          children: [
            if (duration != null)
              Slider(
                activeColor: Colors.deepOrange,
                inactiveColor: Colors.orange,
                min: 0.0,
                max: duration,
                value: seekPos ?? max(0.0, min(position, duration)),
                onChanged: (value) {
                  _dragPositionSubject.add(value);
                },
                onChangeEnd: (value) {
                  AudioService.seekTo(Duration(milliseconds: value.toInt()));
                  // Due to a delay in platform channel communication, there is
                  // a brief moment after releasing the Slider thumb before the
                  // new position is broadcast from the platform side. This
                  // hack is to hold onto seekPos until the next state update
                  // comes through.
                  // TODO: Improve this code.
                  seekPos = value;
                  _dragPositionSubject.add(null);
                },
              ),
            Text(
              "${_printDuration(state.currentPosition)}",
              style: TextStyle(
                fontFamily: "Raleway",
              ),
            ),
          ],
        );
      },
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

Stream<AudioState> get _audioStateStream {
  return Rx.combineLatest3<List<MediaItem>, MediaItem, PlaybackState,
      AudioState>(
    AudioService.queueStream,
    AudioService.currentMediaItemStream,
    AudioService.playbackStateStream,
    (queue, mediaItem, playbackState) => AudioState(
      queue,
      mediaItem,
      playbackState,
    ),
  );
}

void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}
