import 'dart:math';

import 'package:clean_news_ai/domain/model/news_model.dart';
import 'package:clean_news_ai/ui/screens/top_news/top_news_presenter.dart';
import 'package:clean_news_ai/ui/ui_elements/list_element/news_card.dart';
import 'package:clean_news_ai/ui/ui_elements/list_element/news_card_presenter.dart';
import 'package:clean_news_ai/ui/widgets/news_sticky_header.dart';
import 'package:clean_news_ai/ui/widgets/title_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:osam/osam.dart';

import '../base_screen_presenter.dart';

class TopNewsScreen extends StatelessWidget {
  TopNewsScreen(key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = PresenterProvider.of<TopNewsPresenter>(context);
    return CustomScrollView(
      slivers: <Widget>[
        TitleAppBar(title: 'News'),
        CupertinoSliverRefreshControl(
          builder: buildSimpleRefreshIndicator,
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 2), () {
              PresenterProvider.of<BaseScreenPresenter>(context).tryDownloadAgain();
            });
          },
        ),
        SliverPadding(
          padding: EdgeInsets.only(top: 20),
        ),
        ...presenter.initialData.keys
            .map((theme) => StreamBuilder(
                  initialData: presenter.initialData[theme],
                  stream: presenter.stream.map((news) => news[theme]),
                  builder: (ctx, AsyncSnapshot<Map<String, NewsModel>> snapshot) => snapshot
                          .data.isNotEmpty
                      ? SliverStickyHeader(
                          header: NewsStickyHeader(title: theme),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (ctx, index) => PresenterProvider(
                                      key: ValueKey(snapshot.data.keys.toList()[index]),
                                      child: NewsCard(
                                        model: snapshot.data.values.toList()[index],
                                        key: ValueKey(snapshot.data.keys.toList()[index] + 'card'),
                                      ),
                                      presenter: NewsCardPresenter(),
                                    ),
                                childCount: snapshot.data.keys.length),
                          ),
                        )
                      : SliverToBoxAdapter(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              NewsStickyHeader(title: theme),
                              CupertinoActivityIndicator()
                            ],
                          ),
                        ),
                ))
            .toList(),
        SliverPadding(
          padding: EdgeInsets.only(top: 20),
        ),
      ],
    );
  }
}

Widget buildSimpleRefreshIndicator(
  BuildContext context,
  RefreshIndicatorMode refreshState,
  double pulledExtent,
  double refreshTriggerPullDistance,
  double refreshIndicatorExtent,
) {
  const Curve opacityCurve = Interval(0.4, 0.8, curve: Curves.easeInOut);
  return Container(
    padding: EdgeInsets.only(top: 8),
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: refreshState == RefreshIndicatorMode.drag
          ? Opacity(
              opacity: opacityCurve.transform(min(pulledExtent / refreshTriggerPullDistance, 1.0)),
              child: Icon(
                CupertinoIcons.down_arrow,
                color: CupertinoColors.white,
                size: 36.0,
              ),
            )
          : Opacity(
              opacity: opacityCurve.transform(min(pulledExtent / refreshIndicatorExtent, 1.0)),
              child: const CupertinoActivityIndicator(radius: 14.0),
            ),
    ),
  );
}
