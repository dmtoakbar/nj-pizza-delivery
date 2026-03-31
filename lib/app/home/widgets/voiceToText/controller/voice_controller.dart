import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();

  RxBool isListening = false.obs;
  RxString recognizedText = ''.obs;

  Future<void> startListening() async {
    bool available = await _speech.initialize();

    if (!available) return;

    isListening.value = true;

    _speech.listen(
      listenMode: stt.ListenMode.dictation,
      onResult: (result) {
        recognizedText.value = result.recognizedWords;
      },
    );
  }

  void stopListening() {
    _speech.stop();
    isListening.value = false;
  }

  void reset() {
    recognizedText.value = '';
    isListening.value = false;
  }

  @override
  void onClose() {
    _speech.stop();
    super.onClose();
  }
}
