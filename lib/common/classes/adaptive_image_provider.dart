// ignore_for_file: unused_element

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:ui' as ui show Codec, ImmutableBuffer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_billing/config/constants/assets.dart';

/// This provider used for
/// * [AssetImage]
/// * [NetworkImage] with storing cache feature.
/// * [base64] image data
/// ```
/// // Example
/// Image(
/// image: AdaptiveImageProvider(String path,{String? errorImage, double scale, bool isBase64 }),
///   fit: BoxFit.fill,
/// )
/// ```
class AdaptiveImageProvider extends ImageProvider<AdaptiveImageProvider> {
  final String? path;
  final String? errorImage;
  final double scale;
  final bool isBase64;

  const AdaptiveImageProvider(
    this.path, {
    this.errorImage,
    this.scale = 1,
    this.isBase64 = false,
  });

  @override
  ImageStreamCompleter loadImage(
    AdaptiveImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode: decode),
      scale: key.scale,
      debugLabel: key.path,
      informationCollector: () => <DiagnosticsNode>[
        ErrorDescription('Path: $path'),
      ],
    );
  }

  static const List<String> _imageExts = [
    // Raster formats
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'tiff',
    'tif',
    'webp',
    'heic',
    'heif',
    'jp2',
    'svg',

    // // Vector formats
    // 'eps',
    // 'ai',
    // 'pdf',

    // // Others
    // 'ico',
    // 'psd',
    // 'raw',
    // 'cr2',
    // 'nef',
    // 'arw',
  ];

  Future<ui.Codec> _loadAsync(
    AdaptiveImageProvider key, {
    required ImageDecoderCallback decode,
  }) async {
    Uint8List? bytes;
    final imagePath = path ?? "";

    if (isBase64) {
      bytes ??= Uint8List.fromList(base64.decode(path!));
    }

    final imgExt = imagePath.split(".").last.toLowerCase();

    if (_imageExts.contains(imgExt)) {
      if (isURL(imagePath)) {
        bytes ??= await _downloadImageFile(imagePath);
      } else if (isAssetPath(imagePath)) {
        bytes ??= await _loadAssetFile(imagePath);
      } else {
        bytes ??= await _readFile(imagePath);
      }
    }

    bytes ??= await _loadAssetFile(errorImage ?? Assets.imagesNoImageShort);

    return decode(
      await ui.ImmutableBuffer.fromUint8List(bytes ?? Uint8List(0)),
    );
  }

  static final bool _canCache =
      (!kIsWeb && (io.Platform.isAndroid || io.Platform.isIOS));

  @override
  Future<AdaptiveImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AdaptiveImageProvider>(this);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    bool res = other is AdaptiveImageProvider && other.path == path;
    return res;
  }

  @override
  int get hashCode => path.hashCode;

  @override
  String toString() =>
      '${objectRuntimeType(this, 'AdaptiveImageProvider')}("$path")';

  Future<Uint8List?> _loadAssetFile(String assetPath) async {
    try {
      Uint8List data = (await rootBundle.load(assetPath)).buffer.asUint8List();

      return data;
    } catch (e) {
      return null;
    }
  }

  static final Dio _dio = Dio();
  static Future<Uint8List?> _dioFileDownloader(
    String url, [
    String savePath = "",
  ]) async {
    if (!url.startsWith("http")) {
      return null;
    }

    final resp = await _dio.get(
      url,
      options: Options(
        method: "GET",
        receiveTimeout: const Duration(minutes: 2),
        validateStatus: (status) => true,
        responseType: ResponseType.bytes,
      ),
    );
    if (resp.statusCode == 200 && resp.data is List) {
      if (_canCache && savePath.isNotEmpty) {
        final f = io.File(savePath);

        await f.writeAsBytes(resp.data);
      }

      return Uint8List.fromList(resp.data);
    }
    return null;
  }

  static Future<Uint8List?> _downloadImageFile(String urlPath) async {
    try {
      String savePath = "";

      if (_canCache) {
        _cacheDir ??= (await getsetCacheDir());
        // final uri = Uri.decodeComponent(urlPath);

        savePath =
            "$_cacheDir/${Uri.decodeComponent((urlPath.split("/").last))}";

        if (await io.File(savePath).exists()) {
          return await _readFile(savePath);
        }
      }

      return await _dioFileDownloader(urlPath, savePath);
    } on DioException {
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<Uint8List?> _readFile(String path) async {
    if (!_canCache) return null;
    try {
      if (!(await io.File(path).exists())) return null;
      final bytes = await io.File(path).readAsBytes();
      return bytes.lengthInBytes == 0 ? null : bytes;
    } catch (e) {
      return null;
    }
  }

  static bool isURL(String path) =>
      (Uri.tryParse(path) ?? Uri()).host.isNotEmpty;
  static bool isAssetPath(String path) =>
      path.toLowerCase().startsWith("assets/");

  static Future<String> getsetCacheDir() async {
    // /AdaptiveImage
    final dir = io.Directory(
      "${(await getApplicationDocumentsDirectory()).path}/AdaptiveImage1",
    );
    if (await dir.exists()) {
      return dir.path;
    }
    await dir.create(recursive: true);
    return dir.path;
  }

  static String? _cacheDir;

  static final Map<String, Uint8List?> _cachedimage = {};

  static Future<Uint8List?> cacheImageAndGetBytes(String url) async {
    try {
      if (_cachedimage[url] != null) {
        return _cachedimage[url];
      }

      final resp = await _downloadImageFile(url);
      if (resp != null) {
        _cachedimage[url] = resp;
      }

      return resp;
    } catch (e) {
      return null;
    }
  }
}
