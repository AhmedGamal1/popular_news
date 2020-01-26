import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:osam/osam.dart';
import 'package:share/share.dart';

import 'news_card_presenter.dart';

class NewsCard extends StatefulWidget {
  final GlobalKey<SliverAnimatedListState> listKey;
  final int index;

  const NewsCard({
    Key key,
    this.listKey,
    this.index,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final presenter = PresenterProvider.of<NewsCardPresenter>(context);

    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.white10)),
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 4.0),
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  Expanded(
                      child: Text(presenter.model.source,
                          style: TextStyle(color: CupertinoColors.white))),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(CupertinoIcons.reply, color: Colors.white),
                        onPressed: () async {
                          Share.share(presenter.model.url);
                        },
                      ),
                      StreamBuilder(
                        initialData: presenter.initialData,
                        stream: presenter.stream,
                        builder: (ctx, AsyncSnapshot<bool> snapshot) {
                          return IconButton(
                            icon: Icon(
                                snapshot.data ? CupertinoIcons.book_solid : CupertinoIcons.book,
                                color: Colors.white),
                            onPressed: () async {
                              snapshot.data
                                  ? presenter.removeFromFavorites()
                                  : presenter.addToFavorites();
                              if (snapshot.data) {
                                widget.listKey.currentState.removeItem(
                                    widget.index,
                                    (ctx, animation) => AbsorbPointer(
                                          child: FadeTransition(
                                            opacity: animation,
                                            child: SizeTransition(
                                              sizeFactor: animation,
                                              child: PresenterProvider(
                                                key: ValueKey(this.widget.key),
                                                presenter: NewsCardPresenter(presenter.model),
                                                child: NewsCard(),
                                              ),
                                            ),
                                          ),
                                        ));
                              }
                            },
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(presenter.model.title,
                  style: TextStyle(color: CupertinoColors.white, fontSize: 20)),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.centerRight,
              child: Text(presenter.model.hoursAgo, style: TextStyle(color: CupertinoColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  } //  Animation animation;

}
