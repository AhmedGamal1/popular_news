import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:osam/osam.dart';
import 'package:osam/presentation/store_provider.dart';

import 'navigation_presenter.dart';

class NavigationAppBar extends StatelessWidget {
  const NavigationAppBar({Key key, this.controller}) : super(key: key);
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    final presenter = PresenterProvider.of<NavigationPresenter>(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: OsamBuilder(
            stream: presenter.stream,
            builder: (context, AsyncSnapshot<int> snapshot) {
              Future.delayed(Duration.zero, () {
                controller.animateTo(snapshot.data);
              });
              return SafeArea(
                top: false,
                bottom: true,
                left: false,
                right: false,
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  controller: controller,
                  tabs: <Widget>[
                    GestureDetector(
                      onTap: () {
                        presenter.routeTo(0);
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(CupertinoIcons.time),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          presenter.routeTo(1);
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(CupertinoIcons.book),
                        )),
                    GestureDetector(
                        onTap: () {
                          presenter.routeTo(2);
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(CupertinoIcons.settings),
                        )),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
