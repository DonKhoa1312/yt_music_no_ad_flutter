import 'dart:math';
import 'package:music_app/model/Songmodel.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Ytservice {
  static final YoutubeExplode youtubeExplode = YoutubeExplode();

  Future<Songmodel> explore_from_id(String id) async {
    try {
      // Chạy song song việc lấy video và manifest
      List<Future> futures = [
        youtubeExplode.videos.get(id),
        youtubeExplode.videos.streams.getManifest(id)
      ];
      var datas = await Future.wait(futures);

      // Lấy video và manifest
      var video = datas[0] as Video;
      var manifest = datas[1] as StreamManifest;

      return Songmodel(
        id: id,
        title: video.title,
        audio_url: manifest.audioOnly.withHighestBitrate().url.toString(),
        thumb: video.thumbnails.standardResUrl,
        duration: video.duration?.inSeconds.toDouble() ?? 0.0,
      );
    } catch (e) {
      print("Lỗi khi lấy thông tin video: $e");
      rethrow;
    }
  }

  Future<String> recomandsong(String id) async {
    try {
      // Lấy video và gợi ý
      var video = await youtubeExplode.videos.get(id);
      var recomands = await youtubeExplode.videos.getRelatedVideos(video);

      // Chọn ngẫu nhiên một video từ danh sách gợi ý
      if (recomands!.isNotEmpty) {
        print("Số lượng video gợi ý: ${recomands.length}");
        var randomIndex = Random().nextInt(recomands.length);
        return recomands[2].id.toString();
      }
      return "";
    } catch (e) {
      print("Lỗi khi lấy video gợi ý: $e");
      return "";
    }
  }
}



void main() async{
  Ytservice object =Ytservice();
  var  a =await object.explore_from_id("4qbpuDM9crY");
  print(a.thumb);
}