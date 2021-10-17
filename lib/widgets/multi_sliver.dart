import 'package:flutter/material.dart';

class MultiSliver extends StatelessWidget {
  const MultiSliver({
    Key? key,
    this.direction = Axis.vertical,
    this.padding,
    this.sliverAppBar,
    this.slivers,
    this.width,
    this.height,
    this.backgroundColor,
    this.shrinkWrap = false,
    this.constraints,
    this.children,
  }) : super(key: key);
  final List<Widget>? children;
  final List<Widget>? slivers;
  final EdgeInsets? padding;
  final SliverAppBar? sliverAppBar;
  final Axis direction;
  final bool shrinkWrap;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BoxConstraints? constraints;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: backgroundColor,
      constraints: constraints,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(8.0),
        child: CustomScrollView(
          scrollDirection: direction,
          shrinkWrap: shrinkWrap,
          slivers: [
            if (sliverAppBar != null) sliverAppBar!,
            if (children != null)
              for (var item in children!) SliverToBoxAdapter(child: item),
            if (slivers != null)
              for (var item in slivers!) item,
          ],
        ),
      ),
    );
  }
}
