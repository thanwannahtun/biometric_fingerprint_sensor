import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fingerprint_flutter/zkfp/zkfinger_service.dart';
import 'package:path_provider/path_provider.dart';

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
  Uint8List? _lastCapturedTemplate;
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
          _lastCapturedTemplate = result.template;
          _collectedTemplates.add(result.template);
          registerInfoMessage =
              "Captured ${_collectedTemplates.length}/3. Place finger again.";
        });

        // save the single captured image and template immediately
        _saveLastFingerprintData(result.template, result.image);
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

  void _saveLastFingerprintData(Uint8List template, Uint8List image) async {
    try {
      final base64Template = base64.encode(template);
      print("🟢 Base64 Template (last capture): $base64Template");

      // ✅ Use app's document directory (safe across platforms)
      final dir = await getApplicationSupportDirectory();
      final fingerprintDir = Directory(
        '${dir.path}${Platform.pathSeparator}fingerprints',
      );

      // Ensure directory exists
      if (!await fingerprintDir.exists()) {
        await fingerprintDir.create(recursive: true);
      }

      // Save last fingerprint image
      final imageFile = File(
        '${fingerprintDir.path}${Platform.pathSeparator}last_captured_fingerprint_${DateTime.now().microsecondsSinceEpoch}.png',
      );
      await imageFile.writeAsBytes(image);

      // Save last fingerprint template
      final templateFile = File(
        '${fingerprintDir.path}${Platform.pathSeparator}last_captured_template_${DateTime.now().microsecondsSinceEpoch}.txt',
      );
      await templateFile.writeAsString(base64Template);

      // 2️⃣ Save template as raw bytes (.dat)
      final datFile = File(
        '${fingerprintDir.path}${Platform.pathSeparator}last_captured_template_${DateTime.now().microsecondsSinceEpoch}.dat',
      );
      await datFile.writeAsBytes(template);

      print("✅ Last captured fingerprint image saved: ${imageFile.path}");
      print("✅ Last captured fingerprint template saved: ${templateFile.path}");
    } catch (e, st) {
      print("❌ Error saving last captured fingerprint files: $e");
      print("StackTrace: $st");
    }
  }

  void _saveFingerprint() async {
    if (_finalTemplate == null) {
      setState(() {
        registerInfoMessage = "No valid fingerprint. Capture 3 samples first.";
      });
      return;
    }

    final base64Template = base64.encode(_finalTemplate!);
    print("🟢 Base64 Template: $base64Template");
    final decoded = base64.decode(base64Template);
    print("🔵 Decoded Template: $decoded");

    // Todo: save the last captured image and final template files in a project folder

    try {
      // ✅ Use app's document directory (safe across platforms)
      // final dir = await getApplicationDocumentsDirectory();
      final dir = await getApplicationSupportDirectory();
      final fingerprintDir = Directory(
        '${dir.path}${Platform.pathSeparator}fingerprints',
      );

      // Ensure directory exists
      if (!await fingerprintDir.exists()) {
        await fingerprintDir.create(recursive: true);
      }

      // Save fingerprint image
      final imageFile = File(
        '${fingerprintDir.path}${Platform.pathSeparator}last_fingerprint.png',
      );
      await imageFile.writeAsBytes(_lastCapturedImage!);

      // Save fingerprint template
      final templateFile = File(
        '${fingerprintDir.path}${Platform.pathSeparator}final_template.txt',
      );
      await templateFile.writeAsString(base64Template);

      // 2️⃣ Save template as raw bytes (.dat)
      final datFile = File(
        '${fingerprintDir.path}${Platform.pathSeparator}final_template.dat',
      );
      await datFile.writeAsBytes(_finalTemplate!);

      // -------------------------------
      // 3. Save raw BMP (from device SDK)
      // -------------------------------
      if (_lastCapturedImage != null) {
        // <-- new field from your SDK capture
        final bmpFile = File(
          '${fingerprintDir.path}${Platform.pathSeparator}last_fingerprint.bmp',
        );
        await bmpFile.writeAsBytes(_lastCapturedImage!);
        print("✅ BMP fingerprint saved: ${bmpFile.path}");
      } else {
        print("⚠ No raw BMP data available from device.");
      }

      print("✅ Fingerprint image saved: ${imageFile.path}");
      print("✅ Fingerprint template saved: ${templateFile.path}");
    } catch (e, st) {
      print("❌ Error saving fingerprint files: $e");
      print("StackTrace: $st");
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
