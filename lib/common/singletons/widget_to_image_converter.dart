import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:screenshot/screenshot.dart';

class WidgetToImageConverter {
  ScreenshotController screenshotController = ScreenshotController();

  Future<File?> createWidgetImage(
    BuildContext context,
    Widget widget, {
    required bool highQuality,
  }) async {
    final pngData = await getWidgetBytes(widget, highQuality: highQuality);
    if (pngData == null) {
      return null;
    }

    return await saveImageAsFile(pngData);
  }

  Future<File?> saveImageAsFile(Uint8List? pngData) async {
    if (pngData == null) {
      return null;
    }

    // final dir = (await getApplicationDocumentsDirectory()).path;
    final dir = (await getApplicationCacheDirectory()).path;
    final file = File("$dir/${DateTime.now().millisecondsSinceEpoch}_img.png");
    // final file = File("$dir/${DateTime.now().fileNameDateTime}_img.png");
    await file.writeAsBytes(pngData);

    return file;
  }

  Future<String?> getWidgetImageBase64(
    Widget widget, {
    required bool highQuality,
  }) async {
    final bytes = await getWidgetBytes(widget, highQuality: highQuality);
    if (bytes == null) return null;
    return base64Encode(bytes);
  }

  Future<Uint8List?> getWidgetBytes(
    Widget widget, {
    required bool highQuality,
  }) async {
    // if (1 == 1) return await widgetToImageByBase(widget);
    try {
      final context = App.context;
      double? pixelRatio;
      if (highQuality) {
        if (App.isMobileDevice) {
          pixelRatio = 2;
        } else {
          pixelRatio = 3;
        }
      }

      return await screenshotController.captureFromWidget(
        InheritedTheme.captureAll(
          context,
          Material(color: Colors.black, child: widget),
        ),
        delay: const Duration(milliseconds: 200),
        pixelRatio: pixelRatio,
      );
    } catch (e) {
      return null;
    }
  }

  Future<Uint8List?> getWidgetBytesForPrint(
    Widget widget, {
    required bool highQuality,
  }) async {
    // if (1 == 1) return await widgetToImageByBase(widget);
    try {
      return await screenshotController.captureFromWidget(
        widget,
        delay: const Duration(milliseconds: 100),
        pixelRatio: 2,
      );
    } catch (e) {
      return null;
    }
  }

  Future<Uint8List?> widgetToImageByBase(
    Widget widget, {
    double pixelRatio = 3.0,
  }) async {
    try {
      final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

      final RenderView renderView = RenderView(
        view: ui.window,
        child: RenderPositionedBox(
          alignment: Alignment.center,
          child: repaintBoundary,
        ),
        configuration: ViewConfiguration(
          // size: ui.window.physicalSize / ui.window.devicePixelRatio,
          devicePixelRatio: pixelRatio,
        ),
      );

      final PipelineOwner pipelineOwner = PipelineOwner();
      final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());

      final RenderObjectToWidgetElement<RenderBox> rootElement =
          RenderObjectToWidgetAdapter<RenderBox>(
            container: repaintBoundary,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: widget,
            ),
          ).attachToRenderTree(buildOwner);

      pipelineOwner.rootNode = renderView;
      renderView.prepareInitialFrame();

      buildOwner.buildScope(rootElement);
      buildOwner.finalizeTree();
      pipelineOwner.flushLayout();
      pipelineOwner.flushCompositingBits();
      pipelineOwner.flushPaint();
      await Future.delayed(const Duration(milliseconds: 100));

      final ui.Image image = await repaintBoundary.toImage(
        pixelRatio: pixelRatio,
      );
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      return byteData!.buffer.asUint8List();
    } catch (e, s) {
      (e, s).toString().developerLog();
      return null;
    }
  }
}
