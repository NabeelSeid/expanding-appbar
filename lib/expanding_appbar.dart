import 'package:expanding_appbar/exapnding_header_delegate.dart';
import 'package:flutter/material.dart';

class ExpandingAppBar extends StatefulWidget {
  const ExpandingAppBar({Key key}) : super(key: key);

  @override
  _ExpandingAppBarState createState() => _ExpandingAppBarState();
}

class _ExpandingAppBarState extends State<ExpandingAppBar> {
  ScrollController _scrollController;
  double previousOffset;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    Future.delayed(Duration.zero, () {
      previousOffset = _scrollController.offset;
      double minExtentSize =
          AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
      double maxExtentSize = MediaQuery.of(context).size.height * 0.4;

      _scrollController.addListener(() {
        double extentDifference = (maxExtentSize - minExtentSize);
        double offset = _scrollController.offset;

        /// checks if floord offset is less than floord shrinked appbar offset and
        /// equality of the previously recorded offset and shrinked appbar offset
        /// to stop continuous scroll from body to header of NestedScrollView
        /// -> used floor and used toStringAsFixex(5)
        /// -> to prevent value change made by second scrollView
        if (offset.floor() < extentDifference.floor() &&
            previousOffset.toStringAsFixed(5) ==
                extentDifference.toStringAsFixed(5)) {
          _scrollController.jumpTo(extentDifference - 0.1);
          previousOffset = 0.0;
        } else
          previousOffset = offset;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minExtentSize =
        AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
    final maxExtentSize = MediaQuery.of(context).size.height * 0.4;
    return Scaffold(
      body: Container(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                child: SliverPersistentHeader(
                  pinned: true,
                  delegate: ExpandingHeaderDelegate(
                      title: 'Expanding AppBar',
                      color: Colors.indigoAccent,
                      forceElevated: innerBoxIsScrolled,
                      minExtentSize: minExtentSize,
                      maxExtentSize: maxExtentSize,
                      actions: [
                        IconButton(
                          icon: Icon(Icons.help_outline),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () {},
                        ),
                      ]),
                ),
              ),
            ];
          },
          body: Builder(
            builder: (nestedContext) {
              return CustomScrollView(
                slivers: <Widget>[
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        nestedContext),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.indigoAccent.withOpacity(0.3),
                            child: Padding(
                              padding: EdgeInsets.all(50.0),
                              child: Text(index.toString()),
                            ),
                          ),
                        );
                      },
                      childCount: 10,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
