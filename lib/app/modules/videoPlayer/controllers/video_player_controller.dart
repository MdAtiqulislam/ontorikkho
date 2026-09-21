import 'package:get/get.dart';
import '../../media/models/video_gellary_model.dart';

class VideoPlayerController extends GetxController {
  var isLoading = false.obs;
  var videoURL = "".obs;
  var video = SingleVideo().obs;


  void getVideoUrl() {
    video.value.videoType == "youtube_link"
        ? videoURL.value = video.value.youtubeLink ?? ""
        : videoURL.value = video.value.videoFile ?? "";
  }
}