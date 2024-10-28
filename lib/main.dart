import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/provider/SongControllerProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Songcontrollerprovider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Consumer<Songcontrollerprovider>(
            builder: (context, songController, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 120,
                    width: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                songController.current_song.thumb))),
                  ),
                  Text(
                    songController.current_song.title,
                    style: TextStyle(color: Colors.orange),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      songController.playsong("FN7ALfpGxiI");
                    },
                    child: Text("Play First Song"),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          songController.backsong();
                        },
                        icon: Icon(CupertinoIcons.arrow_left),
                      ),
                      IconButton(
                        onPressed: () {
                          songController.pausesong();
                        },
                        icon: Icon(songController.playing
                            ? CupertinoIcons.pause
                            : CupertinoIcons.play),
                      ),
                      IconButton(
                        onPressed: () {
                          songController.nextsong();
                        },
                        icon: Icon(CupertinoIcons.arrow_right),
                      ),
                    ],
                  ),
                 
                 Slider(
  value: songController.currentPosition.inSeconds.toDouble(),
  min: 0.0,
  max: songController.playlist.isNotEmpty ? 
       songController.playlist[songController.index_song].duration : 0.0, // Thời gian tối đa
  onChanged: (double value) {
    // Chuyển đổi giá trị về Duration và điều chỉnh phát
    Duration newDuration = Duration(seconds: value.toInt());
    songController.seekTo(newDuration); // Đưa audio player đến vị trí mới
  },
),

                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
