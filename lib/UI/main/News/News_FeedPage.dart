import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:screenshot/screenshot.dart';

import 'package:threekm/commenwidgets/commenwidget.dart';

import 'package:threekm/providers/localization_Provider/appLanguage_provider.dart';
import 'package:threekm/providers/main/NewsFeed_Provider.dart';

import 'package:threekm/widgets/NewCardUI/card_ui.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with AutomaticKeepAliveClientMixin {
  int postCount = 10;

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    Future.microtask(() => context.read<NewsFeedProvider>().getBottomFeed(
          languageCode: context.read<AppLanguage>().appLocal == Locale("mr")
              ? "mr"
              : context.read<AppLanguage>().appLocal == Locale("en")
                  ? "en"
                  : "hi",
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final newsFeedProvider = context.watch<NewsFeedProvider>();

    return newsFeedProvider.isLoading == true
        ? RefreshIndicator(
            onRefresh: () {
              return context.read<NewsFeedProvider>().getBottomFeed(
                    languageCode: context.read<AppLanguage>().appLocal ==
                            Locale("mr")
                        ? "mr"
                        : context.read<AppLanguage>().appLocal == Locale("en")
                            ? "en"
                            : "hi",
                  );
            },
            child: Container(child: FeedPostLoadingWidget()))
        : LazyLoadScrollView(
            onEndOfPage: () {
              setState(() {
                postCount = postCount + 10;
              });
            },
            child: RefreshIndicator(
              onRefresh: () {
                return context.read<NewsFeedProvider>().getBottomFeed(
                      languageCode: context.read<AppLanguage>().appLocal ==
                              Locale("mr")
                          ? "mr"
                          : context.read<AppLanguage>().appLocal == Locale("en")
                              ? "en"
                              : "hi",
                    );
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (newsFeedProvider.newsFeedBottomModel?.data?.result
                                ?.posts?.length !=
                            0 &&
                        newsFeedProvider
                                .newsFeedBottomModel?.data?.result?.posts !=
                            null) ...{
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        cacheExtent: 999,
                        primary: true,
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        //itemCount: newsFeedProvider
                        //    .newsFeedBottomModel!.data!.result!.posts!.length,
                        itemCount: postCount,
                        itemBuilder: (context, index) {
                          final newsData = newsFeedProvider
                              .newsFeedBottomModel!.data!.result!.posts![index];
                          return newsData != null
                              ? CardUI(
                                  providerType: 'NewsFeedProvider',
                                  data: newsData,
                                )
                              : SizedBox();
                        },
                      ),
                    }
                  ],
                ),
              ),
            ));
  }

  @override
  bool get wantKeepAlive => true;
}
