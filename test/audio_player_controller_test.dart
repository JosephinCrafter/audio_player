import 'package:audio_player/audio_player.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Controller tests',
    () {
      test(
        'Can play pause',
        () async {
          AudioPlayerController controller = AudioPlayerController();

          controller.load();
          controller.play();
          
          controller.pause();
          controller.stop();


        },
      );
    },
  );
}
