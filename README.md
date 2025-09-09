# ZK4500 Fingerprint Integration for Flutter


#### Biometric Fingerprint Scanner Sensor

Flutter app ( Window ) that works with Fingerprint Sensor devices used dart ffi for native codes
integration !

---

This project demonstrates how to integrate the **ZK4500 Fingerprint Scanner** into a Flutter application using the native **C SDK**.  
It bridges the ZKFinger SDK (`libzkfp.dll`) with Dart via manual FFI bindings, without using `ffigen`.

---

## 📌 Features

- Works with **ZK4500 USB fingerprint sensor**
- Uses **ZKFinger C API** (`libzkfp.dll`) for device communication
- Manual FFI bindings (`dart:ffi`), no codegen tools
- Supports:
    - Device initialization & termination
    - Fingerprint capture (template + raw image bitmap)
    - Template merging & matching
    - DB cache operations (add, delete, identify, clear)
    - Conversion between **Base64 ↔ binary blob**

---

## 📂 Project Structure

```

lib/
windows/
├─ runner/
│ └─ libzkfp.dll # Native DLL from ZKFinger SDK

└─ libzkfp/include/
            └─ libzkfp.h # SDK header file (used for manual FFI bindings)
lib/
└─ zkfp/
    └─ zkfp/zkfinger_service.dart # Dart service wrapper class for binding
    └─ zkfp/zkfi_binding.dart # Dart binding class for FFI calls
.../others


```
---

## ⚙️ Requirements

- **Flutter 3.x+**
- **Windows** (x64 recommended)
- **ZK4500 Fingerprint Sensor**
- `libzkfp.dll` (comes from ZKFinger SDK, must be placed under `windows/runner/`)

> 📝 If you are not using ZK4500, make sure to replace the DLL and header file ( API binding reference file ) with the correct ones for your device.



---


## ⚒️ Other Languages
ZK provides wrappers for C#, Java, etc.
Those APIs are slightly different — this project binds the raw C API directly.

> See the official PDF guide usages 📑 come with the device