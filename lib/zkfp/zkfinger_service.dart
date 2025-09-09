import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:fingerprint_flutter/zkfp/zkfp_binding.dart';
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img; // generated FFI bindings

class ZKFingerService {
  late ZKFingerLib _lib;
  int? _deviceHandle;
  int? _dbHandle;

  ZKFingerService(String dllPath) {
    _lib = ZKFingerLib(dllPath);
  }

  bool init() {
    final r = _lib.init();
    return r == 0;
  }

  void terminate() {
    _lib.terminate();
  }

  bool openDevice([int index = 0]) {
    final h = _lib.openDevice(index);
    if (h > 0) {
      _deviceHandle = h;
      _dbHandle = _lib.createDBCache();
      return true;
    }
    return false;
  }

  void closeDevice() {
    if (_deviceHandle != null) {
      _lib.closeDevice(_deviceHandle!);
      _deviceHandle = null;
    }
    if (_dbHandle != null) {
      _lib.closeDBCache(_dbHandle!);
      _dbHandle = null;
    }
  }

  /// DB Cache
  /// Create DB cache and return handle
  int? createDBCache() {
    final handle = _lib.createDBCache();
    if (handle >= 0) {
      _dbHandle = handle;
      return handle;
    }
    return null;
  }

  /// Close DB cache
  void closeDBCache() {
    if (_dbHandle != null) {
      _lib.closeDBCache(_dbHandle!);
      _dbHandle = null;
    }
  }

  /// Current DB handle (if any)
  int? get dbHandle => _dbHandle;

  /// Current Device handle (if any)

  int? get deviceHandle => _deviceHandle;

  /// DB: set parameter
  bool dbSetParameter(int code, int value) {
    if (_dbHandle == null) return false;
    final r = _lib.dbSetParameter(_dbHandle!, code, value);
    return r == 0;
  }

  /// DB: get parameter
  int? dbGetParameter(int code) {
    if (_dbHandle == null) return null;
    final valPtr = calloc<Int32>();
    final r = _lib.dbGetParameter(_dbHandle!, code, valPtr);
    if (r == 0) {
      final val = valPtr.value;
      calloc.free(valPtr);
      return val;
    }
    calloc.free(valPtr);
    return null;
  }

  /// DB: clear all fingerprints
  bool dbClear() {
    if (_dbHandle == null) return false;
    final r = _lib.dbClear(_dbHandle!);
    return r == 0;
  }

  /// DB: generate registration template from 3 captures
  Uint8List? generateRegTemplate(Uint8List t1, Uint8List t2, Uint8List t3) {
    if (_dbHandle == null) return null;

    final p1 = calloc<Uint8>(t1.length)..asTypedList(t1.length).setAll(0, t1);
    final p2 = calloc<Uint8>(t2.length)..asTypedList(t2.length).setAll(0, t2);
    final p3 = calloc<Uint8>(t3.length)..asTypedList(t3.length).setAll(0, t3);

    final regSize = calloc<Uint32>()..value = 2048;
    final regBuf = calloc<Uint8>(2048);

    final r = _lib.genRegTemplate(_dbHandle!, p1, p2, p3, regBuf, regSize);

    final result =
        (r == 0) ? Uint8List.fromList(regBuf.asTypedList(regSize.value)) : null;

    calloc.free(p1);
    calloc.free(p2);
    calloc.free(p3);
    calloc.free(regBuf);
    calloc.free(regSize);

    return result;
  }

  /// Capture both fingerprint image and template (for enrollment/match)
  CaptureResult? captureFingerprintTemplate() {
    if (_deviceHandle == null) return null;

    return using((Arena arena) {
      // 2. Get image dimensions
      final heightPtr = arena<Uint32>();
      final widthPtr = arena<Uint32>();
      _lib.getParameters(
        _deviceHandle!,
        2,
        heightPtr.cast(),
        arena<Uint32>()..value = 4,
      );
      _lib.getParameters(
        _deviceHandle!,
        1,
        widthPtr.cast(),
        arena<Uint32>()..value = 4,
      );

      final height = heightPtr.value;
      final width = widthPtr.value;
      print("🟢 Device image size: $width x $height ");

      // Allocate memory for the buffers inside the arena
      // FIX: Initialize tmplSize as a single Uint32 with the value 2048
      // Allocate memory for the buffers inside the arena
      final imageBuf = arena<Uint8>(width * height);
      final tmplBuf = arena<Uint8>(2048);

      final tmplSize = arena<Uint32>()..value = 2048;

      /// Retry / Poll Loop with delays
      int r = -1;
      int attempts = 0;

      while (attempts < 20) {
        r = _lib.acquireFingerprint(
          _deviceHandle!,
          imageBuf,
          width * height,
          tmplBuf,
          tmplSize,
        );
        if (r == 0) break; // success
        attempts++;
        Future.delayed(const Duration(milliseconds: 50)); // small wait
      }

      if (r == 0) {
        debugPrint("✅ Capture successful, tmpl size: ${tmplSize.value}");
        final tmpl = Uint8List.fromList(tmplBuf.asTypedList(tmplSize.value));
        final rawImg = imageBuf.asTypedList(width * height);

        // Convert raw grayscale to PNG for display
        final imgObj = img.Image.fromBytes(
          width: width,
          height: height,
          bytes: rawImg.buffer,
          numChannels: 1,
        );
        final pngBytes = Uint8List.fromList(img.encodePng(imgObj));

        return CaptureResult(tmpl, pngBytes);
      } else {
        print("❌ Capture template failed with code $r");
        return null;
      }
      // The arena and all its allocations are freed automatically here.
    });
  }

  /// Add template to DB (Register/Enroll)
  bool enroll(int fid, Uint8List tmpl) {
    if (_dbHandle == null) return false;

    final ptr = calloc<Uint8>(tmpl.length);
    ptr.asTypedList(tmpl.length).setAll(0, tmpl);

    final r = _lib.dbAdd(_dbHandle!, fid, ptr, tmpl.length);
    calloc.free(ptr);
    return r == 0;
  }

  /// Match 1:1
  bool match(Uint8List t1, Uint8List t2) {
    final p1 = calloc<Uint8>(t1.length);
    p1.asTypedList(t1.length).setAll(0, t1);
    final p2 = calloc<Uint8>(t2.length);
    p2.asTypedList(t2.length).setAll(0, t2);

    final r = _lib.matchFinger(_dbHandle!, p1, t1.length, p2, t2.length);

    calloc.free(p1);
    calloc.free(p2);

    return r > 0; // >0 means match score
  }

  /// Identify 1:N
  int? identify(Uint8List tmpl) {
    if (_dbHandle == null) return null;

    final ptr = calloc<Uint8>(tmpl.length);
    ptr.asTypedList(tmpl.length).setAll(0, tmpl);

    final fid = calloc<Uint32>();
    final score = calloc<Uint32>();

    final r = _lib.identify(_dbHandle!, ptr, tmpl.length, fid, score);
    calloc.free(ptr);

    if (r == 0) {
      final id = fid.value;
      calloc.free(fid);
      calloc.free(score);
      return id;
    } else {
      calloc.free(fid);
      calloc.free(score);
      return null;
    }
  }

  dbAdd(
    int i,
    int j,
    Uint8List collectedTemplat,
    Uint8List collectedTemplat2,
    Uint8List collectedTemplat3,
  ) {}

  void getParameters(
    int deviceHandle,
    int i,
    Pointer<NativeType> cast,
    Pointer<Uint32> pointer,
  ) {}
}

class FingerprintCapture {
  final Uint8List image; // raw fingerprint bitmap
  final Uint8List template; // fingerprint template

  FingerprintCapture({required this.image, required this.template});
}

class CaptureResult {
  final Uint8List template;
  final Uint8List image;

  CaptureResult(this.template, this.image);
}
