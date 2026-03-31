import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/voice_controller.dart';

void showVoiceRecorderDialog({required Function(String) onDone}) {

  FocusManager.instance.primaryFocus?.unfocus();
  final VoiceController controller = Get.put(VoiceController());
  controller.startListening();

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Speak Now",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 20),

              /// Animated Mic
              /// Animated Mic with Professional Waves
              SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (controller.isListening.value) ...[
                      _Wave(delay: 0),
                      _Wave(delay: 0.3),
                      _Wave(delay: 0.6),
                    ],

                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: controller.isListening.value ? 96 : 72,
                      height: controller.isListening.value ? 96 : 72,
                      decoration: BoxDecoration(
                        color:
                            controller.isListening.value
                                ? Colors.redAccent
                                : Colors.grey.shade300,
                        shape: BoxShape.circle,
                        boxShadow:
                            controller.isListening.value
                                ? [
                                  BoxShadow(
                                    color: Colors.redAccent.withOpacity(0.35),
                                    blurRadius: 20,
                                    spreadRadius: 6,
                                  ),
                                ]
                                : [],
                      ),
                      child: IconButton(
                        icon: Icon(
                          controller.isListening.value
                              ? Icons.mic
                              : Icons.mic_none,
                          color: Colors.white,
                          size: 34,
                        ),
                        onPressed:
                            controller.isListening.value
                                ? controller.stopListening
                                : controller.startListening,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// Converted Text Display
              if (controller.recognizedText.value.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    controller.recognizedText.value,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 20),

              /// Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      controller.stopListening();
                      controller.reset();
                      Get.back();
                      Get.delete<VoiceController>();
                    },
                    child: const Text("Close", style: TextStyle(color: Colors.black),),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed:
                        controller.recognizedText.value.isEmpty
                            ? null
                            : () {
                              final text = controller.recognizedText.value;

                              controller.stopListening();
                              controller.reset();
                              Get.back();
                              Get.delete<VoiceController>();

                              onDone(text); // ✅ Send result
                            },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color(0xFFEB5525), // button color
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Done", style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    ),
    barrierDismissible: true,
  );
}

class _Wave extends StatefulWidget {
  final double delay;
  const _Wave({required this.delay});

  @override
  State<_Wave> createState() => _WaveState();
}

class _WaveState extends State<_Wave> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    Future.delayed(
      Duration(milliseconds: (widget.delay * 1000).toInt()),
      () => _controller.repeat(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final value = _controller.value;
        return Container(
          width: 100 + (value * 80),
          height: 100 + (value * 80),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.redAccent.withOpacity(0.4 * (1 - value)),
              width: 2,
            ),
          ),
        );
      },
    );
  }
}
