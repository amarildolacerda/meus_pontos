// @dart=2.12
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ImageUtils {
  static Future<Uint8List?> capturePngFromContext(BuildContext context,
      {double pixelRatio = 1.0}) async {
    final RenderRepaintBoundary boundary =
        context.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    return pngBytes;
  }

  static imageToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  static Uint8List base64ToImage(String base64) {
    return base64Decode(base64);
  }
}
