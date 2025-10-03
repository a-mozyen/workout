import 'package:flutter/material.dart';
import 'package:workout/services/device_detection_service.dart';

class DeviceDetectionScreen extends StatefulWidget {
  const DeviceDetectionScreen({super.key});

  @override
  State<DeviceDetectionScreen> createState() => _DeviceDetectionScreenState();
}

class _DeviceDetectionScreenState extends State<DeviceDetectionScreen> {
  DeviceInfo? _detected;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _runMockDetection();
  }

  Future<void> _runMockDetection() async {
    setState(() {
      _isDetecting = true;
    });
    // Simulate capture + inference
    await Future.delayed(const Duration(seconds: 1));
    final result = DeviceDetectionService().detectFromMockCapture();
    setState(() {
      _detected = result;
      _isDetecting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('AI Device Detection'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 3 / 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[700]!),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.photo_camera, size: 64),
              ),
            ),
            const SizedBox(height: 16),
            if (_isDetecting)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            if (_detected != null) ...[
              Text(
                _detected!.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(_detected!.description, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              const Text(
                'How to use:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._detected!.howToUse.map(
                (step) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(child: Text(step)),
                    ],
                  ),
                ),
              ),
            ] else ...[
              const Text(
                'Point your camera at a gym device and tap detect.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
