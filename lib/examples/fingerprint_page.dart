import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../zkfp/zkfinger_service.dart';

class FingerprintPage extends StatefulWidget {
  const FingerprintPage({super.key});

  @override
  State<FingerprintPage> createState() => _FingerprintPageState();
}

class _FingerprintPageState extends State<FingerprintPage> {
  late ZKFingerService _service;
  Uint8List? _capturedTemplate;
  Uint8List? _capturedImage;

  String _status = "Idle";

  int poll = -1;

  @override
  void initState() {
    super.initState();
    _service = ZKFingerService("windows/runner/libzkfp.dll");
    _init();
  }

  @override
  void dispose() {
    _service.closeDevice();
    _service.terminate();
    super.dispose();
  }

  void _init() {
    final ok = _service.init();
    // setState(() => _status = ok ? "SDK Initialized" : "Init failed");
    if (ok) {
      _status = "SDK Initialized";
      _openDevice();
      _captureTemplate();
    } else {
      _status = "Init failed";
    }
  }

  void _terminate() {
    _service.terminate();
    setState(() => _status = "SDK Terminated");
  }

  void _openDevice() {
    final ok = _service.openDevice();
    setState(() => _status = ok ? "Device opened" : "Open device failed");
  }

  void _closeDevice() {
    _service.closeDevice();
    setState(() => _status = "Device closed");
  }

  void _captureTemplate() async {
    await Future.delayed(Duration(seconds: 1)).then((value) {
      while (poll < 3) {
        final result = _service.captureFingerprintTemplate();
        if (result != null) {
          setState(() {
            _capturedImage = result.image;
            debugPrint("result.image ${result.image}");
            poll++;
            Future.delayed(const Duration(milliseconds: 50));
          });
          debugPrint("Image    length: ${result.image.length}");
          debugPrint("Template length: ${result.template.length}");
          // TODO: send template to API for enroll/match
        }
      }
    });
  }

  void _enroll() {
    if (_capturedTemplate != null) {
      final ok = _service.enroll(1, _capturedTemplate!);
      setState(() => _status = ok ? "Enrolled FID=1" : "Enroll failed");
    }
  }

  void _verify() {
    if (_capturedTemplate != null) {
      final id = _service.identify(_capturedTemplate!);
      setState(() => _status = id != null ? "Verified ID=$id" : "Not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fingerprint Demo")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_status),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _init, child: const Text("Init")),
            ElevatedButton(
              onPressed: _terminate,
              child: const Text("Terminate"),
            ),
            ElevatedButton(
              onPressed: _openDevice,
              child: const Text("Open Device"),
            ),
            ElevatedButton(
              onPressed: _closeDevice,
              child: const Text("Close Device"),
            ),
            ElevatedButton(
              onPressed: _enroll,
              child: const Text("Enroll Fingerprint"),
            ),
            ElevatedButton(
              onPressed: _verify,
              child: const Text("Verify Fingerprint"),
            ),

            if (_capturedImage != null)
              Image.memory(
                _capturedImage!,
                width: 250,
                height: 300,
                fit: BoxFit.contain,
              ),

            ElevatedButton(
              onPressed: _captureTemplate,
              child: Text("Capture Template"),
            ),
          ],
        ),
      ),
    );
  }
}
