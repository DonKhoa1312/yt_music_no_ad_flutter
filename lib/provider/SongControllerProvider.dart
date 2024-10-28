import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/model/Songmodel.dart';
import 'package:music_app/service/YtService.dart';

class Songcontrollerprovider extends ChangeNotifier {
  Songmodel current_song = Songmodel(
      title: "no song is playing",
      audio_url: "",
      thumb: "",
      duration: 0.0,
      id: "");
  late int index_song = 0;
  late List<Songmodel> playlist = [];
  late bool playing = false;
 Duration currentPosition =Duration.zero;
  final AudioPlayer audioPlayer = AudioPlayer();
  final Ytservice ytservice = Ytservice();

  Songcontrollerprovider() {
    // Lắng nghe thời gian hiện tại của audio
    audioPlayer.positionStream.listen((position) {
      currentPosition = position;
      notifyListeners(); // Cập nhật UI khi thời gian hiện tại thay đổi
    });

    // Lắng nghe trạng thái phát của audio
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        // Khi bài hát đã phát xong, gọi nextsong
        nextsong();
      }
    });
  }
  void playsong(String videoid) async {
    playing = true;
    Songmodel firstSong = await ytservice.explore_from_id(videoid);
    playlist.add(firstSong);
    current_song =firstSong;
    audioPlayer.setUrl(firstSong.audio_url);
    audioPlayer.play();

    print("đang phát bài hát" + playlist[index_song].title);
    String nextid = await ytservice.recomandsong(videoid);

    playlist.add(await ytservice.explore_from_id(nextid));
    notifyListeners();
  }

  void pausesong() async {
    if (playing) {
      await audioPlayer.pause(); // Dừng lại nếu đang phát
      playing = false;
      print("Dừng bài hát");
    } else {
      await audioPlayer.play(); // Phát tiếp nếu đang dừng
      playing = true;
      print("Phát tiếp bài hát");
    }

    // Cập nhật trạng thái widget
    notifyListeners();
  }

void nextsong() async {
  // Kiểm tra nếu index_song không vượt quá số lượng bài hát trong playlist
  if (index_song < playlist.length - 1) {
    index_song += 1; // Tăng chỉ số bài hát
  } else {
    // Nếu đã đến bài cuối cùng, lấy bài hát mới từ gợi ý
    String nextid = await ytservice.recomandsong(playlist[index_song].id);
    
    // Tải bài hát mới từ ID
    Songmodel nextSong = await ytservice.explore_from_id(nextid);
    
    // Thêm bài hát mới vào playlist
    playlist.add(nextSong);
    index_song += 1; // Cập nhật chỉ số bài hát
  }

  // Dừng bài hát hiện tại trước khi chuyển sang bài tiếp theo
  await audioPlayer.stop();

  // Cập nhật current_song để phát bài hát mới
  current_song = playlist[index_song];
  
  // Thiết lập URL và phát bài hát mới
  await audioPlayer.setUrl(current_song.audio_url);
  await audioPlayer.play();

  // Cập nhật UI
  notifyListeners();
}

 void backsong() async {
  try {
    if (index_song > 0 && playlist.isNotEmpty) {
      index_song -= 1;
      current_song = playlist[index_song];

      // Dừng phát nhạc hiện tại trước khi chuyển bài
      if (audioPlayer.playing) {
        await audioPlayer.stop();
      }

      await audioPlayer.setUrl(playlist[index_song].audio_url);
      await audioPlayer.play();

      print("bài kế tiếp: ${playlist[index_song].toString()}");
      notifyListeners();
    }
  } catch (e) {
    print("Lỗi khi chuyển bài: $e");
  }
}

        void seekTo(Duration position)async {
  await  audioPlayer.seek(position);
  }
  
}
