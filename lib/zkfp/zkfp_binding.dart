import 'dart:ffi';
import 'package:ffi/ffi.dart';

typedef ZkInitC = Int32 Function();
typedef ZkInitDart = int Function();

typedef ZkTerminateC = Int32 Function();
typedef ZkTerminateDart = int Function();

typedef ZkGetDeviceCountC = Int32 Function();
typedef ZkGetDeviceCountDart = int Function();

typedef ZkOpenDeviceC = IntPtr Function(Int32 index);
typedef ZkOpenDeviceDart = int Function(int index);

typedef ZkCloseDeviceC = Int32 Function(IntPtr hDevice);
typedef ZkCloseDeviceDart = int Function(int hDevice);

typedef ZkAcquireFingerprintC =
    Int32 Function(
      IntPtr hDevice,
      Pointer<Uint8> fpImage,
      Uint32 cbFPImage,
      Pointer<Uint8> fpTemplate,
      Pointer<Uint32> cbTemplate,
    );
typedef ZkAcquireFingerprintDart =
    int Function(
      int hDevice,
      Pointer<Uint8> fpImage,
      int cbFPImage,
      Pointer<Uint8> fpTemplate,
      Pointer<Uint32> cbTemplate,
    );

// --- Parameters ---
typedef ZkSetParametersC =
    Int32 Function(
      IntPtr hDevice,
      Int32 nParamCode,
      Pointer<Uint8> paramValue,
      Uint32 cbParamValue,
    );
typedef ZkSetParametersDart =
    int Function(
      int hDevice,
      int nParamCode,
      Pointer<Uint8> paramValue,
      int cbParamValue,
    );

typedef ZkGetParametersC =
    Int32 Function(
      IntPtr hDevice,
      Int32 nParamCode,
      Pointer<Uint8> paramValue,
      Pointer<Uint32> cbParamValue,
    );
typedef ZkGetParametersDart =
    int Function(
      int hDevice,
      int nParamCode,
      Pointer<Uint8> paramValue,
      Pointer<Uint32> cbParamValue,
    );

// --- DB Cache ---
typedef ZkCreateDBCacheC = IntPtr Function();
typedef ZkCreateDBCacheDart = int Function();

typedef ZkCloseDBCacheC = Int32 Function(IntPtr hDBCache);
typedef ZkCloseDBCacheDart = int Function(int hDBCache);

typedef ZkDBAddC =
    Int32 Function(
      IntPtr hDBCache,
      Uint32 fid,
      Pointer<Uint8> fpTemplate,
      Uint32 cbTemplate,
    );
typedef ZkDBAddDart =
    int Function(
      int hDBCache,
      int fid,
      Pointer<Uint8> fpTemplate,
      int cbTemplate,
    );

typedef ZkDBDelC = Int32 Function(IntPtr hDBCache, Uint32 fid);
typedef ZkDBDelDart = int Function(int hDBCache, int fid);

typedef ZkDBCountC = Int32 Function(IntPtr hDBCache, Pointer<Uint32> fpCount);
typedef ZkDBCountDart = int Function(int hDBCache, Pointer<Uint32> fpCount);

// --- DB extra methods ---

typedef ZkDBSetParameterC =
    Int32 Function(IntPtr hDBCache, Int32 nParamCode, Int32 paramValue);
typedef ZkDBSetParameterDart =
    int Function(int hDBCache, int nParamCode, int paramValue);

typedef ZkDBGetParameterC =
    Int32 Function(
      IntPtr hDBCache,
      Int32 nParamCode,
      Pointer<Int32> paramValue,
    );
typedef ZkDBGetParameterDart =
    int Function(int hDBCache, int nParamCode, Pointer<Int32> paramValue);

typedef ZkGenRegTemplateC =
    Int32 Function(
      IntPtr hDBCache,
      Pointer<Uint8> temp1,
      Pointer<Uint8> temp2,
      Pointer<Uint8> temp3,
      Pointer<Uint8> regTemp,
      Pointer<Uint32> cbRegTemp,
    );
typedef ZkGenRegTemplateDart =
    int Function(
      int hDBCache,
      Pointer<Uint8> temp1,
      Pointer<Uint8> temp2,
      Pointer<Uint8> temp3,
      Pointer<Uint8> regTemp,
      Pointer<Uint32> cbRegTemp,
    );

typedef ZkDBClearC = Int32 Function(IntPtr hDBCache);
typedef ZkDBClearDart = int Function(int hDBCache);

// --- Identify & Match ---
typedef ZkIdentifyC =
    Int32 Function(
      IntPtr hDBCache,
      Pointer<Uint8> fpTemplate,
      Uint32 cbTemplate,
      Pointer<Uint32> FID,
      Pointer<Uint32> score,
    );
typedef ZkIdentifyDart =
    int Function(
      int hDBCache,
      Pointer<Uint8> fpTemplate,
      int cbTemplate,
      Pointer<Uint32> FID,
      Pointer<Uint32> score,
    );

typedef ZkMatchFingerC =
    Int32 Function(
      IntPtr hDBCache,
      Pointer<Uint8> template1,
      Uint32 cbTemplate1,
      Pointer<Uint8> template2,
      Uint32 cbTemplate2,
    );
typedef ZkMatchFingerDart =
    int Function(
      int hDBCache,
      Pointer<Uint8> template1,
      int cbTemplate1,
      Pointer<Uint8> template2,
      int cbTemplate2,
    );

// --- Base64 ---
typedef ZkBase64ToBlobC =
    Int32 Function(Pointer<Utf8> src, Pointer<Uint8> blob, Uint32 cbBlob);
typedef ZkBase64ToBlobDart =
    int Function(Pointer<Utf8> src, Pointer<Uint8> blob, int cbBlob);

typedef ZkBlobToBase64C =
    Int32 Function(
      Pointer<Uint8> src,
      Uint32 cbSrc,
      Pointer<Utf8> base64Str,
      Uint32 cbBase64Str,
    );
typedef ZkBlobToBase64Dart =
    int Function(
      Pointer<Uint8> src,
      int cbSrc,
      Pointer<Utf8> base64Str,
      int cbBase64Str,
    );
// --- Original ones ---
typedef AcquireFingerprintImageC =
    Int32 Function(IntPtr hDevice, Pointer<Uint8> fpImage, Uint32 cbFPImage);

typedef AcquireFingerprintImageDart =
    int Function(int hDevice, Pointer<Uint8> fpImage, int cbFPImage);

typedef AcquireFingerprintC =
    Int32 Function(
      IntPtr hDevice,
      Pointer<Uint8> fpImage,
      Uint32 cbFPImage,
      Pointer<Uint8> fpTemplate,
      Pointer<Uint32> cbTemplate,
    );

typedef AcquireFingerprintDart =
    int Function(
      int hDevice,
      Pointer<Uint8> fpImage,
      int cbFPImage,
      Pointer<Uint8> fpTemplate,
      Pointer<Uint32> cbTemplate,
    );

class ZKFingerLib {
  late DynamicLibrary _lib;

  late ZkInitDart init;
  late ZkTerminateDart terminate;
  late ZkGetDeviceCountDart getDeviceCount;
  late ZkOpenDeviceDart openDevice;
  late ZkCloseDeviceDart closeDevice;
  late ZkAcquireFingerprintDart acquireFingerprint;

  late ZkSetParametersDart setParameters;
  late ZkGetParametersDart getParameters;
  late ZkCreateDBCacheDart createDBCache;
  late ZkCloseDBCacheDart closeDBCache;
  late ZkDBAddDart dbAdd;
  late ZkDBDelDart dbDel;
  late ZkDBCountDart dbCount;
  late ZkIdentifyDart identify;
  late ZkMatchFingerDart matchFinger;
  late ZkBase64ToBlobDart base64ToBlob;
  late ZkBlobToBase64Dart blobToBase64;

  late ZkDBSetParameterDart dbSetParameter;
  late ZkDBGetParameterDart dbGetParameter;
  late ZkGenRegTemplateDart genRegTemplate;
  late ZkDBClearDart dbClear;

  // Load from DLL
  late AcquireFingerprintImageDart acquireFingerprintImage;

  ZKFingerLib(String? dllPath) {
    _lib = DynamicLibrary.open(dllPath ?? r"C:\Windows\System32\libzkfp.dll");

    init = _lib.lookupFunction<ZkInitC, ZkInitDart>('ZKFPM_Init');
    terminate = _lib.lookupFunction<ZkTerminateC, ZkTerminateDart>(
      'ZKFPM_Terminate',
    );
    getDeviceCount = _lib
        .lookupFunction<ZkGetDeviceCountC, ZkGetDeviceCountDart>(
          'ZKFPM_GetDeviceCount',
        );
    openDevice = _lib.lookupFunction<ZkOpenDeviceC, ZkOpenDeviceDart>(
      'ZKFPM_OpenDevice',
    );
    closeDevice = _lib.lookupFunction<ZkCloseDeviceC, ZkCloseDeviceDart>(
      'ZKFPM_CloseDevice',
    );
    acquireFingerprint = _lib
        .lookupFunction<ZkAcquireFingerprintC, ZkAcquireFingerprintDart>(
          'ZKFPM_AcquireFingerprint',
        );
    acquireFingerprintImage = _lib
        .lookupFunction<AcquireFingerprintImageC, AcquireFingerprintImageDart>(
          'ZKFPM_AcquireFingerprintImage',
        );

    setParameters = _lib.lookupFunction<ZkSetParametersC, ZkSetParametersDart>(
      'ZKFPM_SetParameters',
    );
    getParameters = _lib.lookupFunction<ZkGetParametersC, ZkGetParametersDart>(
      'ZKFPM_GetParameters',
    );
    createDBCache = _lib.lookupFunction<ZkCreateDBCacheC, ZkCreateDBCacheDart>(
      'ZKFPM_CreateDBCache',
    );
    closeDBCache = _lib.lookupFunction<ZkCloseDBCacheC, ZkCloseDBCacheDart>(
      'ZKFPM_CloseDBCache',
    );
    dbAdd = _lib.lookupFunction<ZkDBAddC, ZkDBAddDart>('ZKFPM_DBAdd');
    dbDel = _lib.lookupFunction<ZkDBDelC, ZkDBDelDart>('ZKFPM_DBDel');
    dbCount = _lib.lookupFunction<ZkDBCountC, ZkDBCountDart>('ZKFPM_DBCount');

    dbSetParameter = _lib
        .lookupFunction<ZkDBSetParameterC, ZkDBSetParameterDart>(
          'ZKFPM_DBSetParameter',
        );
    dbGetParameter = _lib
        .lookupFunction<ZkDBGetParameterC, ZkDBGetParameterDart>(
          'ZKFPM_DBGetParameter',
        );
    genRegTemplate = _lib
        .lookupFunction<ZkGenRegTemplateC, ZkGenRegTemplateDart>(
          'ZKFPM_GenRegTemplate',
        );
    dbClear = _lib.lookupFunction<ZkDBClearC, ZkDBClearDart>('ZKFPM_DBClear');

    identify = _lib.lookupFunction<ZkIdentifyC, ZkIdentifyDart>(
      'ZKFPM_Identify',
    );
    matchFinger = _lib.lookupFunction<ZkMatchFingerC, ZkMatchFingerDart>(
      'ZKFPM_MatchFinger',
    );
    base64ToBlob = _lib.lookupFunction<ZkBase64ToBlobC, ZkBase64ToBlobDart>(
      'ZKFPM_Base64ToBlob',
    );
    blobToBase64 = _lib.lookupFunction<ZkBlobToBase64C, ZkBlobToBase64Dart>(
      'ZKFPM_BlobToBase64',
    );
  }
}
