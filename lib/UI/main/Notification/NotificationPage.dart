import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threekm/Models/Notification/NotificationModel.dart';
import 'package:threekm/UI/Animation/AnimatedSizeRoute.dart';
import 'package:threekm/UI/main/News/PostView.dart';
import 'package:threekm/providers/Notification/Notification_Provider.dart';
import 'package:threekm/utils/util_methods.dart';
import 'package:threekm/utils/utils.dart';

class Notificationpage extends StatefulWidget {
  const Notificationpage({Key? key}) : super(key: key);

  @override
  _NotificationpageState createState() => _NotificationpageState();
}

class _NotificationpageState extends State<Notificationpage> {
  @override
  void initState() {
    Future.microtask(
        () => context.read<NotificationProvider>().getNotificationData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = context.watch<NotificationProvider>();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Notifications",
              style: ThreeKmTextConstants.tk14PXPoppinsWhiteMedium),
        ),
        // backgroundColor: Colors.green,
        body: RefreshIndicator(
            child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: notificationProvider.NotificationDataList?.data?.result
                            ?.notifications !=
                        null
                    ? ListView.builder(
                        itemCount: notificationProvider.NotificationDataList!
                            .data!.result!.notifications!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => Navigator.push(
                                context,
                                AnimatedSizeRoute(
                                    page: Postview(
                                        postId: notificationProvider
                                            .NotificationDataList!
                                            .data!
                                            .result!
                                            .notifications![index]
                                            .data!
                                            .postId
                                            .toString()))),
                            child: buildNotificationItems(notificationProvider
                                .NotificationDataList!
                                .data!
                                .result!
                                .notifications![index]),
                          );
                        },
                      )
                    : Center(
                        child: CupertinoActivityIndicator(),
                      )),
            onRefresh: () => context.read<NotificationProvider>().onRefresh()));
  }

  Widget buildNotificationItems(NotificationClass notification) {
    return Stack(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Color(0x1A0F0F2D),
                  offset: Offset(0, 3),
                  blurRadius: 4),
            ],
          ),
          child: Row(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: notification.image != null
                    ? CachedNetworkImage(
                        imageUrl: notification.image.toString(),
                        fit: BoxFit.fill,
                      ).size(height: 97, width: 146)
                    : Container(
                        color: Colors.grey.shade200,
                      ).size(height: 97, width: 146),
              ),
              space(width: 12),
              Expanded(
                child: Column(
                  children: [
                    space(height: 12),
                    Text(
                      "${notification.title}",
                      style: generateStyles(
                        type: StylesEnum.POPPINS,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F0F2D),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    space(height: 8),
                    Text(
                      notification.body != null
                          ? notification.body.toString()
                          : "",
                      style: generateStyles(
                        type: StylesEnum.LATO,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F0F2D),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              space(width: 15),
            ],
          ),
        )
            .size(height: 97, width: double.infinity)
            .paddingX(18)
            .padding(bottom: 24),
        Positioned(
          top: 0,
          left: 18,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              "${notification.date}",
              style: generateStyles(
                type: StylesEnum.POPPINS,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
