// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class _GridPaperPainter extends CustomPainter {
  const _GridPaperPainter({
    required this.color,
    required this.interval,
    required this.divisions,
    required this.subdivisions,
    this.width,
    this.height,
  });

  final Color color;
  final double interval;
  final int divisions;
  final int subdivisions;
  final double? width;
  final double? height;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()..color = color;
    final double allDivisions = (divisions * subdivisions).toDouble();
    double fx = size.width / (width ?? size.width);
    if (fx == 0) fx = 1;
    int xi = 0;
    for (double x = 0.0;
        x <= (size.width);
        x += fx * (interval / allDivisions)) {
      xi++;
      linePaint.strokeWidth = (xi % allDivisions == 0.0)
          ? lnDivisions
          : (xi % (divisions) == 0.0)
              ? lnSubdivisons
              : lnOrdinary;

      canvas.drawLine(Offset(x, 0.0), Offset(x, size.height), linePaint);
    }
    double fy = size.height / (height ?? size.height);
    if (fy == 0) fy = 1;
    int yi = 0;
    for (double y = 0.0;
        y <= (size.height);
        y += fy * interval / allDivisions) {
      yi++;
      linePaint.strokeWidth = ((yi) % allDivisions == 0)
          ? lnDivisions
          : (yi % divisions == 0)
              ? lnSubdivisons
              : lnOrdinary;
      canvas.drawLine(Offset(0.0, y), Offset(size.width, y), linePaint);
    }
  }

  get lnDivisions => 1.0;
  get lnSubdivisons => 0.5;
  get lnOrdinary => 0.20;

  @override
  bool shouldRepaint(_GridPaperPainter oldPainter) {
    return oldPainter.color != color ||
        oldPainter.interval != interval ||
        oldPainter.divisions != divisions ||
        oldPainter.subdivisions != subdivisions;
  }

  @override
  bool hitTest(Offset position) => false;
}

/// A widget that draws a rectilinear grid of lines one pixel wide.
///
/// Useful with a [Stack] for visualizing your layout along a grid.
///
/// The grid's origin (where the first primary horizontal line and the first
/// primary vertical line intersect) is at the top left of the widget.
///
/// The grid is drawn over the [child] widget.
class GridImagePaper extends StatelessWidget {
  /// Creates a widget that draws a rectilinear grid of 1-pixel-wide lines.
  final double? width;
  final double? height;
  const GridImagePaper({
    Key? key,
    this.color = const Color(0x7FC3E8F3),
    this.interval = 100.0,
    this.divisions = 2,
    this.subdivisions = 5,
    this.child,
    this.width,
    this.height,
  })  : assert(divisions > 0,
            'The "divisions" property must be greater than zero. If there were no divisions, the grid paper would not paint anything.'),
        assert(subdivisions > 0,
            'The "subdivisions" property must be greater than zero. If there were no subdivisions, the grid paper would not paint anything.'),
        super(key: key);

  /// The color to draw the lines in the grid.
  ///
  /// Defaults to a light blue commonly seen on traditional grid paper.
  final Color color;

  /// The distance between the primary lines in the grid, in logical pixels.
  ///
  /// Each primary line is one logical pixel wide.
  final double interval;

  /// The number of major divisions within each primary grid cell.
  ///
  /// This is the number of major divisions per [interval], including the
  /// primary grid's line.
  ///
  /// The lines after the first are half a logical pixel wide.
  ///
  /// If this is set to 2 (the default), then for each [interval] there will be
  /// a 1-pixel line on the left, a half-pixel line in the middle, and a 1-pixel
  /// line on the right (the latter being the 1-pixel line on the left of the
  /// next [interval]).
  final int divisions;

  /// The number of minor divisions within each major division, including the
  /// major division itself.
  ///
  /// If [subdivisions] is 5 (the default), it means that there will be four
  /// lines between each major ([divisions]) line.
  ///
  /// The subdivision lines after the first are a quarter of a logical pixel wide.
  final int subdivisions;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _GridPaperPainter(
        color: color,
        interval: interval,
        divisions: divisions,
        subdivisions: subdivisions,
        width: width,
        height: height,
      ),
      child: child,
    );
  }
}
