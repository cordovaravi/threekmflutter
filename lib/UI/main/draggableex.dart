import 'package:flutter/material.dart';
import 'package:threekm/Custom_library/draggable_home.dart';
import 'package:threekm/UI/main/News/NewsTab.dart';

class DraggablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      headerExpandedHeight: 0.1,
      //title: Text("News"),
      headerWidget: headerWidget(context),
      //headerBottomBar: headerBottomBarWidget(),
      body: [NewsTab()],
      fullyStretchable: true,
      //alwaysShowLeadingAndAction: true,
      expandedBody: Center(
        child: Text("this is exapnded body"),
      ),
    );
  }

  Container headerBottomBarWidget() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.settings,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Container headerWidget(BuildContext context) => Container(
      child: DefaultTabController(
          length: 3,
          child: TabBar(
            tabs: [
              Tab(
                text: "News",
              ),
              Tab(
                text: "Shopping",
              ),
              Tab(
                text: "Business",
              )
            ],
          )));

  ListView listView() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 0),
      physics: NeverScrollableScrollPhysics(),
      itemCount: 20,
      shrinkWrap: true,
      itemBuilder: (context, index) => Card(
        color: Colors.white70,
        child: ListTile(
          leading: CircleAvatar(
            child: Text("$index"),
          ),
          title: Text("Title"),
          subtitle: Text("Subtitile"),
        ),
      ),
    );
  }
}
