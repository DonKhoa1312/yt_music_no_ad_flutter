class Songmodel {
  const Songmodel(
      {required this.title,
      required this.id,
      required this.audio_url,
      required this.thumb,
      required this.duration});
  final String title, audio_url, thumb,id;
  final double duration;
   @override
  String toString() {
    return 'Songmodel(title: $title, audio_url: $audio_url, thumb: $thumb, duration: $duration)';
  }
}
