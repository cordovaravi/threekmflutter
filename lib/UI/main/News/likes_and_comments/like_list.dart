// author: Prateek Aher
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threekm/Models/LikeListModel.dart';
import 'package:threekm/UI/main/News/Widgets/likes_Loading.dart';

import '../../../../providers/main/LikeList_Provider.dart';
import '../../Profile/AuthorProfile.dart';

class LikeList extends StatefulWidget {
  const LikeList({Key? key, required this.postId}) : super(key: key);
  final int postId;

  @override
  State<LikeList> createState() => _LikeListState();
}

class _LikeListState extends State<LikeList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LikeListProvider>(builder: (_, provider, __) {
      return DefaultTabController(
        length: 1 +
            (provider.likeCount != 0 ? 1 : 0) +
            (provider.loveCount != 0 ? 1 : 0) +
            (provider.careCount != 0 ? 1 : 0) +
            (provider.laughCount != 0 ? 1 : 0) +
            (provider.sadCount != 0 ? 1 : 0) +
            (provider.angryCount != 0 ? 1 : 0),
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            centerTitle: false,
            title: const Text(
              'Reactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: Column(
            children: [
              buildTabBar(provider),
              Expanded(
                  child: TabBarView(children: [
                provider.isLoading
                    ? LikesListLoading()
                    :
                    // ALL Likes
                    reactionList(
                        userList: provider.users,
                        anonymousCount:
                            provider.likeList?.data?.result?.anonymousCount),
                if (provider.likeCount != 0)
                  reactionList(userList: provider.likeUsers),
                if (provider.loveCount != 0)
                  reactionList(userList: provider.loveUsers),
                if (provider.careCount != 0)
                  reactionList(userList: provider.careUsers),
                if (provider.laughCount != 0)
                  reactionList(userList: provider.laughUsers),
                if (provider.sadCount != 0)
                  reactionList(userList: provider.sadUsers),
                if (provider.angryCount != 0)
                  reactionList(userList: provider.angryUsers),
              ])),
            ],
          ),
        ),
      );
    });
  }

  TabBar buildTabBar(LikeListProvider provider) {
    return TabBar(
        padding: const EdgeInsets.all(8),
        labelColor: Colors.blueAccent, //Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.black,
        indicatorColor: Colors.blueAccent, //Theme.of(context).primaryColor,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(0),
        labelPadding: const EdgeInsets.all(0),
        // isScrollable: true,
        tabs: [
          const Tab(
            child: Text(
              'All',
              style: TextStyle(fontSize: 16),
            ),
          ),
          if (provider.likeCount != 0)
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/reactions/like.png',
                    height: 16,
                    width: 16,
                  ),
                  SizedBox(width: 2),
                  Text(
                    '${provider.likeCount}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          if (provider.loveCount != 0)
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/reactions/love.png',
                    height: 16,
                    width: 16,
                  ),
                  Text(
                    '${provider.loveCount}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          if (provider.careCount != 0)
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/reactions/care.png',
                    height: 16,
                    width: 16,
                  ),
                  Text(
                    '${provider.careCount}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          if (provider.laughCount != 0)
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/reactions/laugh.png',
                    height: 16,
                    width: 16,
                  ),
                  Text(
                    '${provider.laughCount}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          if (provider.sadCount != 0)
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/reactions/sad.png',
                    height: 16,
                    width: 16,
                  ),
                  Text(
                    '${provider.sadCount}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          if (provider.angryCount != 0)
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/reactions/angry.png',
                    height: 16,
                    width: 16,
                  ),
                  Text(
                    '${provider.angryCount}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
        ]);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration.zero,
        () =>
            context.read<LikeListProvider>().showLikes(context, widget.postId));
  }

  ListView reactionList({
    required List<User> userList,
    int? anonymousCount,
  }) =>
      ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) => ListTile(
                // TODO: for future build
                onTap: () => goToProfile(
                  users: userList,
                  index: index,
                ),

                leading: Stack(
                  children: [
                    Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: (index < userList.length)
                                ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        userList[index].avatar.toString()))
                                : null),
                        child: userList[index].isUnknown != null
                            ? Center(
                                child: Text(
                                    // "+${provider.likeList!.data!.result!.anonymousCount}",
                                    "+",
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.white),
                                    textAlign: TextAlign.center),
                              )
                            : SizedBox.shrink()),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: userList[index].emotion != null &&
                              userList[index].emotion != "null"
                          ? Image.asset(
                              'assets/reactions/${userList[index].emotion ?? 'like'}.png',
                              height: 15,
                              width: 15,
                              // color: Colors.blue,
                            )
                          : Image.asset(
                              'assets/reactions/like.png',
                              height: 15,
                              width: 15,
                              // color: Colors.blue,
                            ),
                    )
                  ],
                ),
                title: Text(userList[index].name != 'anonymous'
                    ? userList[index].name.toString()
                    : '...and ${anonymousCount} more'),
              ));

  goToProfile({required List<User> users, required int index}) {
    if (users[index].isUnknown == null)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AuthorProfile(
                    authorType: users[index].userType,
                    id: users[index].id!,
                    avatar: users[index].avatar ?? '',
                    userName: users[index].name ?? '',
                  )));
  }
}
