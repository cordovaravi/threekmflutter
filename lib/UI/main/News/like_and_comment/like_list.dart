import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            (provider.cryCount != 0 ? 1 : 0) +
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
                    ? LikesLoadingNew()
                    : ListView.builder(
                        itemCount: provider.users.length,
                        itemBuilder: (context, index) => ListTile(
                              onTap: () => goToProfile(
                                provider: provider,
                                index: index,
                              ),
                              leading: Stack(
                                children: [
                                  Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: (index < provider.usersCount!)
                                              ? DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      provider.users[index].avatar.toString()))
                                              : null),
                                      child: provider.users[index].isUnknown != null
                                          ? Center(
                                              child: Text(
                                                  // "+${provider.likeList!.data!.result!.anonymousCount}",
                                                  "+",
                                                  style:
                                                      TextStyle(fontSize: 22, color: Colors.white),
                                                  textAlign: TextAlign.center),
                                            )
                                          : SizedBox.shrink()),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Image.asset(
                                      'assets/reactions/${provider.users[index].isUnknown != null ? 'like' : (provider.users[index].emotion ?? 'like')}.png',
                                      height: 15,
                                      width: 15,
                                      // color: Colors.blue,
                                    ),
                                  )
                                ],
                              ),
                              title: Text(provider.users[index].name != 'anonymous'
                                  ? provider.users[index].name.toString()
                                  : '...and ${provider.likeList?.data?.result?.anonymousCount} more'),
                            )),
                if (provider.likeCount != 0)
                  ListView.builder(
                      itemCount: provider.likeCount,
                      itemBuilder: (context, index) => ListTile(
                            leading: Stack(
                              children: [
                                Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              provider.likeUsers[index].avatar.toString()))),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Image.asset(
                                    'assets/reactions/like.png',
                                    height: 15,
                                    width: 15,
                                    // color: Colors.blue,
                                  ),
                                )
                              ],
                            ),
                            title: Text('${provider.likeUsers[index].name}'),
                          )),
                if (provider.loveCount != 0)
                  ListView.builder(
                      itemCount: provider.loveCount,
                      itemBuilder: (context, index) => ListTile(
                            leading: Stack(
                              children: [
                                Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              provider.loveUsers[index].avatar.toString()))),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Image.asset(
                                    'assets/reactions/love.png',
                                    height: 15,
                                    width: 15,
                                    // color: Colors.blue,
                                  ),
                                )
                              ],
                            ),
                            title: Text('${provider.loveUsers[index].name}'),
                          )),
                if (provider.careCount != 0)
                  ListView.builder(
                      itemCount: provider.careCount,
                      itemBuilder: (context, index) => ListTile(
                            leading: Stack(
                              children: [
                                Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              provider.careUsers[index].avatar.toString()))),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Image.asset(
                                    'assets/reactions/care.png',
                                    height: 15,
                                    width: 15,
                                    // color: Colors.blue,
                                  ),
                                )
                              ],
                            ),
                            title: Text('${provider.careUsers[index].name}'),
                          )),
                if (provider.laughCount != 0)
                  ListView.builder(
                      itemCount: provider.laughCount,
                      itemBuilder: (context, index) => ListTile(
                            leading: Stack(
                              children: [
                                Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              provider.laughUsers[index].avatar.toString()))),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Image.asset(
                                    'assets/reactions/laugh.png',
                                    height: 15,
                                    width: 15,
                                    // color: Colors.blue,
                                  ),
                                )
                              ],
                            ),
                            title: Text('${provider.laughUsers[index].name}'),
                          )),
                if (provider.cryCount != 0)
                  ListView.builder(
                      itemCount: provider.cryCount,
                      itemBuilder: (context, index) => ListTile(
                            leading: Stack(
                              children: [
                                Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              provider.cryUsers[index].avatar.toString()))),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Image.asset(
                                    'assets/reactions/cry.png',
                                    height: 15,
                                    width: 15,
                                    // color: Colors.blue,
                                  ),
                                )
                              ],
                            ),
                            title: Text('${provider.cryUsers[index].name}'),
                          )),
                if (provider.angryCount != 0)
                  ListView.builder(
                      itemCount: provider.angryCount,
                      itemBuilder: (context, index) => ListTile(
                            leading: Stack(
                              children: [
                                Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              provider.angryUsers[index].avatar.toString()))),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Image.asset(
                                    'assets/reactions/angry.png',
                                    height: 15,
                                    width: 15,
                                    // color: Colors.blue,
                                  ),
                                )
                              ],
                            ),
                            title: Text('${provider.angryUsers[index].name}'),
                          )),
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
          if (provider.cryCount != 0)
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/reactions/cry.png',
                    height: 16,
                    width: 16,
                  ),
                  Text(
                    '${provider.cryCount}',
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
        Duration.zero, () => context.read<LikeListProvider>().showLikes(context, widget.postId));
  }

  goToProfile({required LikeListProvider provider, required int index}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AuthorProfile(
                  authorType: provider.users[index].userType,
                  id: provider.users[index].id!,
                  avatar: provider.users[index].avatar ?? '',
                  userName: provider.users[index].name ?? '',
                )));
  }
}
