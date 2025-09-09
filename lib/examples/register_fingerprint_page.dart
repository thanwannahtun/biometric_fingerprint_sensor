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

  @override
  void initState() {
    super.initState();
    _service =
        ZKFingerService("windows/runner/libzkfp.dll")
          ..init()
          ..openDevice();

    // ✅ Create DB cache on page open
    _service.createDBCache();
  }

  @override
  void dispose() {
    // ✅ Always close cache to avoid leaks
    // _service.closeDBCache();
    _service.closeDevice();
    super.dispose();
  }

  Future<void> _captureFingerprint() async {
    final result = _service.captureFingerprintTemplate();
    if (result == null) {
      setState(() {
        registerInfoMessage = "Capture failed, try again!";
      });
      return;
    }

    setState(() {
      _lastCapturedImage = result.image;
      _collectedTemplates.add(result.template);
    });

    if (_collectedTemplates.length < 3) {
      setState(() {
        registerInfoMessage =
            "Captured ${_collectedTemplates.length}/3. Place finger again in a slightly different position.";
      });
    } else if (_collectedTemplates.length == 3) {
      // ✅ Once 3 captures done, generate final registered template
      final regTemplate = _service.generateRegTemplate(
        _collectedTemplates[0],
        _collectedTemplates[1],
        _collectedTemplates[2],
      );

      if (regTemplate != null) {
        setState(() {
          _finalTemplate = regTemplate;
          registerInfoMessage = "";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fingerprint registered successfully!")),
        );
      } else {
        setState(() {
          registerInfoMessage = "Enrollment failed";
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Enrollment failed")));
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

    // ✅ Here you would send _finalTemplate to your backend API
    debugPrint("✅ Final fingerprint ready, size: ${_finalTemplate!.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Fingerprint"),
        actions: [
          IconButton(
            onPressed: () {
              _collectedTemplates.clear();
              setState(() {});
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 20,
          children: [
            Text("Capture fingerprint 3 times with the same finger!"),

            Text(
              registerInfoMessage,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            if (_lastCapturedImage != null)
              Image.memory(_lastCapturedImage!, width: 300, height: 300),
            ElevatedButton(
              onPressed:
                  _collectedTemplates.length < 3
                      ? _captureFingerprint
                      : null, // disable after 3 captures
              child: Text(
                _collectedTemplates.length < 3
                    ? "Capture Fingerprint (${_collectedTemplates.length}/3)"
                    : "Captured All",
              ),
            ),

            ElevatedButton(
              onPressed: _finalTemplate != null ? _saveFingerprint : null,
              child: const Text("Save Fingerprint"),
            ),
          ],
        ),
      ),
    );
  }
}
