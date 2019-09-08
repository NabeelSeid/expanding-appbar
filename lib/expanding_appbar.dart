import 'package:expanding_appbar/exapnding_header_delegate.dart';
import 'package:flutter/material.dart';

class ExpandingAppBar extends StatelessWidget {
  const ExpandingAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minExtentSize =
        AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
    final maxExtentSize = MediaQuery.of(context).size.height * 0.4;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
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
          builder: (context) {
            return CustomScrollView(
              slivers: <Widget>[
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, int index) {
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(50.0),
                          child: Text(index.toString()),
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
    );
  }
}
