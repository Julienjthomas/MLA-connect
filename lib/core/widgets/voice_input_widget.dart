import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class VoiceInputWidget extends StatefulWidget {
  final void Function(String filePath)? onRecorded;

  const VoiceInputWidget({super.key, this.onRecorded});

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget> {
  final _recorder = AudioRecorder();
  final _player = AudioPlayer();

  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordedPath;
  int _elapsedSeconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      Get.snackbar('Permission Required', 'Microphone permission required',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final path =
        '${Directory.systemTemp.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

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
    await _player.playerStateStream.firstWhere(
        (s) => s.processingState == ProcessingState.completed);
    setState(() => _isPlaying = false);
  }

  String _formatSeconds(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _isRecording
            ? AppColors.reportOrange.withValues(alpha: 0.08)
            : AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isRecording ? AppColors.reportOrange : AppColors.grey300,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _isRecording ? _stopRecording : _startRecording,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _isRecording ? AppColors.reportOrange : AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _isRecording
                ? Text(
                    'Recording… ${_formatSeconds(_elapsedSeconds)}',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.reportOrange),
                  )
                : _recordedPath != null
                    ? Text('Recording saved',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.appreciateGreen))
                    : const Text('Add Voice Message'),
          ),
          if (_recordedPath != null && !_isRecording)
            GestureDetector(
              onTap: _isPlaying ? null : _playRecording,
              child: Icon(
                _isPlaying
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                color: AppColors.primary,
                size: 28,
              ),
            ),
          if (!_isRecording && _recordedPath == null)
            const Text('Optional'),
        ],
      ),
    );
  }
}
