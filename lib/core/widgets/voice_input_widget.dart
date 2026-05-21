import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Voice capture + optional on-device dictation. When [onTranscript] is set,
/// the primary control runs speech-to-text (tap to start, tap again to stop).
class VoiceInputWidget extends StatefulWidget {
  final void Function(String filePath)? onRecorded;
  final void Function(String transcript)? onTranscript;
  final bool alignTrailing;
  final bool overlayInField;

  const VoiceInputWidget({
    super.key,
    this.onRecorded,
    this.onTranscript,
    this.alignTrailing = false,
    this.overlayInField = false,
  });

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget> {
  final _recorder = AudioRecorder();
  final _player = AudioPlayer();
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordedPath;
  int _elapsedSeconds = 0;
  Timer? _timer;
  bool _isListening = false;
  String _dictationText = '';

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggleDictation() async {
    if (widget.onTranscript == null) return;

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      final t = _dictationText.trim();
      if (t.isNotEmpty) widget.onTranscript!(t);
      _dictationText = '';
      return;
    }

    final mic = await Permission.microphone.request();
    if (!mic.isGranted) {
      Get.snackbar('Permission Required', 'Microphone permission required', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final ok = await _speech.initialize(
      onError: (e) => debugPrint('stt error $e'),
      onStatus: (s) => debugPrint('stt status $s'),
    );
    if (!ok) {
      Get.snackbar('Voice', 'Speech recognition is not available on this device.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    _dictationText = '';
    setState(() => _isListening = true);
    await _speech.listen(
      onResult: (r) {
        _dictationText = r.recognizedWords;
        if (r.finalResult && r.recognizedWords.isNotEmpty) {
          setState(() {});
        }
      },
      listenOptions: stt.SpeechListenOptions(cancelOnError: true, partialResults: true),
    );
  }

  Future<void> _startRecording() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      Get.snackbar('Permission Required', 'Microphone permission required', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final path = '${Directory.systemTemp.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: path);

    setState(() {
      _isRecording = true;
      _elapsedSeconds = 0;
      _recordedPath = null;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsedSeconds++);
    });
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    final path = await _recorder.stop();
    setState(() {
      _isRecording = false;
      _recordedPath = path;
    });
    if (path != null && widget.onRecorded != null) {
      widget.onRecorded!(path);
    }
  }

  Future<void> _playRecording() async {
    if (_recordedPath == null) return;
    setState(() => _isPlaying = true);
    await _player.setFilePath(_recordedPath!);
    await _player.play();
    await _player.playerStateStream.firstWhere((s) => s.processingState == ProcessingState.completed);
    setState(() => _isPlaying = false);
  }

  String _formatSeconds(int s) => '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  Widget _buildMicButton({
    required VoidCallback onTap,
    required bool active,
    required IconData icon,
    Color? activeColor,
  }) {
    return Material(
      color: active ? (activeColor ?? AppColors.reportOrange) : AppColors.primary,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: 40, height: 40, child: Icon(icon, color: Colors.white, size: 20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.overlayInField) {
      return Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (_isListening)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('Listening…', style: AppTextStyles.caption.copyWith(color: AppColors.reportOrange)),
                ),
              if (_recordedPath != null && widget.onRecorded != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('Voice saved', style: AppTextStyles.caption.copyWith(color: AppColors.appreciateGreen)),
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.onRecorded != null) ...[
                    _buildMicButton(
                      onTap: _isRecording ? _stopRecording : _startRecording,
                      active: _isRecording,
                      icon: _isRecording ? Icons.stop_rounded : Icons.graphic_eq_rounded,
                    ),
                    if (widget.onTranscript != null) const SizedBox(width: 8),
                  ],
                  if (widget.onTranscript != null)
                    _buildMicButton(
                      onTap: _toggleDictation,
                      active: _isListening,
                      icon: _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (widget.alignTrailing && widget.onTranscript != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: _isListening ? AppColors.reportOrange : AppColors.primary,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _toggleDictation,
              child: SizedBox(
                width: 48,
                height: 48,
                child: Icon(_isListening ? Icons.stop_rounded : Icons.mic_rounded, color: Colors.white, size: 24),
              ),
            ),
          ),
          if (_isListening) ...[
            const SizedBox(height: 4),
            Text('Listening…', style: AppTextStyles.caption.copyWith(color: AppColors.reportOrange)),
          ],
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _isRecording || _isListening ? AppColors.reportOrange.withValues(alpha: 0.08) : AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _isRecording || _isListening ? AppColors.reportOrange : AppColors.grey300),
      ),
      child: Row(
        children: [
          if (widget.onTranscript != null)
            GestureDetector(
              onTap: _toggleDictation,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _isListening ? AppColors.reportOrange : AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(_isListening ? Icons.stop_rounded : Icons.mic_rounded, color: Colors.white, size: 20),
              ),
            )
          else
            GestureDetector(
              onTap: _isRecording ? _stopRecording : _startRecording,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _isRecording ? AppColors.reportOrange : AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(_isRecording ? Icons.stop_rounded : Icons.mic_rounded, color: Colors.white, size: 20),
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: _isListening
                ? Text(
                    _dictationText.isEmpty ? 'Speak now…' : _dictationText,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.reportOrange),
                    maxLines: 3,
                  )
                : _isRecording
                ? Text(
                    'Recording… ${_formatSeconds(_elapsedSeconds)}',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.reportOrange),
                  )
                : _recordedPath != null
                ? Text('Recording saved', style: AppTextStyles.bodySmall.copyWith(color: AppColors.appreciateGreen))
                : Text(
                    widget.onTranscript != null ? 'Voice to text' : 'Record a voice message...',
                    style: AppTextStyles.bodySmall,
                  ),
          ),
          if (_recordedPath != null && !_isRecording && widget.onTranscript == null)
            GestureDetector(
              onTap: _isPlaying ? null : _playRecording,
              child: Icon(
                _isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                color: AppColors.primary,
                size: 28,
              ),
            ),
        ],
      ),
    );
  }
}
