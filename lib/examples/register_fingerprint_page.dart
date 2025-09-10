import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fingerprint_flutter/zkfp/zkfinger_service.dart';

class RegisterFingerprintPage extends StatefulWidget {
  const RegisterFingerprintPage({super.key});

  @override
  State<RegisterFingerprintPage> createState() =>
      _RegisterFingerprintPageState();
}

class _RegisterFingerprintPageState extends State<RegisterFingerprintPage> {
  late ZKFingerService _service;
  final List<Uint8List> _collectedTemplates = [];
  Uint8List? _lastCapturedImage;
  Uint8List? _finalTemplate;

  String registerInfoMessage = "";
  String successMessage = "";

  @override
  void initState() {
    super.initState();
    initDevice();
  }

  void initDevice() async {
    _service =
        ZKFingerService("windows/runner/libzkfp.dll")
          ..init()
          ..openDevice();

    // ✅ Create DB cache on page open
    _service.createDBCache();

    captureFirst();
  }

  captureFirst() async {
    await Future.delayed(Duration(milliseconds: 300)).then((_) {
      _captureFingerprint();
    });
  }

  @override
  void dispose() {
    _service.closeDevice();
    super.dispose();
  }

  Future<void> _captureFingerprint() async {
    // Prevent multiple parallel loops
    if (_collectedTemplates.length >= 3) return;

    setState(() {
      registerInfoMessage = "Starting continuous capture...";
    });

    // Loop until we capture 3 valid fingerprints
    while (_collectedTemplates.length < 3 && mounted) {
      final result = _service.captureFingerprintTemplate();

      if (result != null) {
        setState(() {
          _lastCapturedImage = result.image;
          _collectedTemplates.add(result.template);
          registerInfoMessage =
              "Captured ${_collectedTemplates.length}/3. Place finger again.";
        });
      } else {
        setState(() {
          registerInfoMessage =
              "Captured ${_collectedTemplates.length}/3. Place finger again. Waiting...";
          // registerInfoMessage = "Capture failed, trying again...";
        });
      }

      // Add a small delay to avoid hammering the device
      await Future.delayed(const Duration(milliseconds: 800));
    }

    // Auto-generate final template once 3 samples are collected
    if (_collectedTemplates.length == 3) {
      final regTemplate = _service.generateRegTemplate(
        _collectedTemplates[0],
        _collectedTemplates[1],
        _collectedTemplates[2],
      );

      if (regTemplate != null) {
        setState(() {
          _finalTemplate = regTemplate;
          registerInfoMessage = "";
          successMessage = "Fingerprint registered successfully!";
        });
        // if (mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       content: Text("Fingerprint registered successfully!"),
        //     ),
        //   );
        // }
      } else {
        setState(() {
          registerInfoMessage =
              "Enrollment failed . Register with the same finger.";
        });
        // if (mounted) {
        //   ScaffoldMessenger.of(
        //     context,
        //   ).showSnackBar(const SnackBar(content: Text("Enrollment failed")));
        // }
      }
    }
  }

  void _saveFingerprint() {
    if (_finalTemplate == null) {
      setState(() {
        registerInfoMessage = "No valid fingerprint. Capture 3 samples first.";
      });

      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            insetPadding: const EdgeInsets.all(20),
            elevation: 10,
            child: Image.memory(_lastCapturedImage!),
          ),
    );
    // ✅ Here you would send _finalTemplate to your backend API
    debugPrint("✅ Final fingerprint ready, size: ${_finalTemplate!.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close),
        ),
        title: const Text("Register Fingerprint"),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                _collectedTemplates.clear();
                _lastCapturedImage = null;
                _finalTemplate = null;
                registerInfoMessage = "";
                successMessage = "";
              });
              initDevice();
            },
            icon: Icon(Icons.refresh),
            tooltip: "Reset Registration",
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 20,
          children: [
            Text(
              "Capture fingerprint 3 times with the same finger!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),

            Text(
              registerInfoMessage,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
            Text(
              successMessage,
              style: TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (_lastCapturedImage != null)
              Expanded(
                child: Image.memory(
                  _lastCapturedImage!,
                  width: 300,
                  height: 300,
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                ElevatedButton(
                  onPressed:
                      _collectedTemplates.length < 3
                          ? _captureFingerprint
                          : null, // disable after 3 captures
                  child: Text(
                    _collectedTemplates.length < 3
                        ? "Capture Fingerprint (${_collectedTemplates.length}/3)"
                        // "Start Capture (Auto 3x)"
                        : "Captured All",
                  ),
                ),

                ElevatedButton(
                  onPressed: _finalTemplate != null ? _saveFingerprint : null,
                  child: const Text("Save Fingerprint"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
