import 'package:flutter/material.dart';

class ExpandingHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final Color color;
  final bool forceElevated;
  final double maxExtentSize;
  final double minExtentSize;
  final List<Widget> actions;

  ColorTween colorTween;
  Tween<double> blurTween;
  Tween<double> reverseBlurTween;

  ExpandingHeaderDelegate({
    this.title,
    this.color,
    this.forceElevated,
    this.maxExtentSize,
    this.minExtentSize,
    this.actions,
  }) : super();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    colorTween = ColorTween(
        begin: this.color, end: Theme.of(context).scaffoldBackgroundColor);
    blurTween = Tween<double>(begin: 1.0, end: 0.0);
    reverseBlurTween = Tween<double>(begin: 0.0, end: 1.0);

    /// path from max extent to min extent. Full path
    /// The last minExtent height make offset jumps 1, reset it to 1.0
    /// gradient fade controller or for any other animation that needs
    /// ?full path
    double offset = (shrinkOffset / (maxExtent - minExtent));
    if (offset > 1) offset = 1.0;

    /// path from max extent to half extent
    /// after half extent offset jumps 1, reset it to 1.0
    /// ?HeadlineTitle fade controller
    double titleHeadlineOffset =
        (shrinkOffset / ((maxExtent - minExtent) * 0.5));
    if (titleHeadlineOffset > 1) titleHeadlineOffset = 1.0;

    /// path from half extent to 85% extent
    /// reset offset to 0 till half path and
    /// reset offset to 1 after 85% extent
    /// ?page title fade controller
    double titleBlurOffset = ((shrinkOffset - ((maxExtent - minExtent) * 0.5)) /
        ((maxExtent - minExtent) * 0.35));
    if (shrinkOffset < (maxExtent - minExtent) * 0.5) titleBlurOffset = 0;
    if (titleBlurOffset > 1) titleBlurOffset = 1.0;

    return LayoutBuilder(
      builder: (_, constraints) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: this.forceElevated
                ? [BoxShadow(blurRadius: 4.0, color: Colors.black45)]
                : null,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                this.colorTween.lerp(offset),
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Opacity(
                    opacity: this.blurTween.lerp(titleHeadlineOffset),
                    child: Center(
                      child: Text(
                        this.title,
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {},
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Opacity(
                        opacity: this.reverseBlurTween.lerp(titleBlurOffset),
                        child: Text(
                          this.title,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .title
                              .copyWith(color: Colors.black),
                        ),
                      ),
                    ),
                    ...?actions,
                    SizedBox(
                      width: 10.0,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => this.maxExtentSize ?? 250.0;

  @override
  double get minExtent => this.minExtentSize ?? 80.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
