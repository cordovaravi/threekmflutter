import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/Custom_library/draggable_home.dart';
import 'package:threekm/UI/main/AddPost/ImageEdit/editImage.dart';
import 'package:threekm/UI/main/News/NewsTab.dart';
import 'package:threekm/providers/main/AddPost_Provider.dart';
import 'package:threekm/utils/utils.dart';

import 'News/NewsList.dart';

class DraggablePage extends StatelessWidget {
  final ImagePicker _imagePicker = ImagePicker();
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
        expandedBody: Padding(
          padding: EdgeInsets.only(top: 80),
          child: Row(
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      _showImageVideoBottomModalSheet(context);
                      // final image = await _imagePicker.pickImage(
                      //     source: ImageSource.gallery);
                      // if (image != null) {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) =>
                      //               EditImage(images: image)));
                      // }
                      //-----------
                      // List<XFile>? imageFileList = [];
                      // final List<XFile>? images =
                      //     await _imagePicker.pickMultiImage();
                      // if (imageFileList.isEmpty) {
                      //   imageFileList.addAll(images!);
                      // }
                      // imageFileList.forEach((element) {
                      //   print(element.name);
                      //   print(element.path);
                      // });
                      // if (imageFileList != null) {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) =>
                      //               EditImage(images: imageFileList)));
                      // }
                    },
                    child: Container(
                      margin: EdgeInsets.all(16),
                      height: 127,
                      //height: MediaQuery.of(context).size.height * 0.1,
                      width: 161,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/Grouppost.png"),
                                    fit: BoxFit.cover),
                                shape: BoxShape.circle,
                                color: Color(0xffFBA924)),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "New Post",
                            style:
                                ThreeKmTextConstants.tk16PXPoppinsBlackMedium,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
                      //height: MediaQuery.of(context).size.height * 0.1,
                      height: 127,
                      width: 161,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/Groupprofile.png"),
                                ),
                                shape: BoxShape.circle,
                                color: Color(0xffFC5E6A),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xffFC5E6A33),
                                      blurRadius: 0.8)
                                ]),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "My Profile",
                            style:
                                ThreeKmTextConstants.tk16PXPoppinsBlackMedium,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: 16, left: 16, right: 16, top: 0),
                      //height: MediaQuery.of(context).size.height * 0.2,
                      height: 270,
                      width: 161,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/Grouplocation.png"),
                                ),
                                shape: BoxShape.circle,
                                color: Color(0xff43B978),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xff43B97833),
                                      blurRadius: 0.8)
                                ]),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "My Location",
                            style:
                                ThreeKmTextConstants.tk16PXPoppinsBlackMedium,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Baner-Pashan \n Link Road",
                            style:
                                ThreeKmTextConstants.tk16PXPoppinsBlackMedium,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Container(
                            width: 108,
                            height: 36,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: Color(0xff3E7EFF)),
                            child: Center(
                              child: Text(
                                "Change",
                                style:
                                    ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
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

  _showImageVideoBottomModalSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return ClipPath(
                clipper: OvalTopBorderClipper(),
                child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height / 4,
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          List<XFile>? imageFileList = [];
                          final List<XFile>? images =
                              await _imagePicker.pickMultiImage();
                          if (imageFileList.isEmpty) {
                            imageFileList.addAll(images!);
                          }
                          imageFileList.forEach((element) {
                            print(element.name);
                            print(element.path);
                          });
                          if (imageFileList != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditImage(images: imageFileList)));
                          }

                          //final image = await _imagePicker.pickMultiImage();
                          // if (image != null) {
                          //   //context.read<AddPostProvider>().addImages(widget.imageFile);
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //               EditImage(images: image)));
                          // }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Color(0xff0F0F2D),
                              )),
                          child: ListTile(
                            leading: Image.asset(
                              "assets/camera.png",
                              color: Color(0xff0F0F2D),
                            ),
                            title: Text(
                              "Upload Image via Gallery",
                              style: ThreeKmTextConstants.tk14PXLatoBlackBold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Color(0xff0F0F2D),
                              )),
                          child: ListTile(
                            leading: Image.asset(
                              "assets/videocam.png",
                              color: Color(0xff0F0F2D),
                            ),
                            title: Text(
                              "Upload Video via Gallery",
                              style: ThreeKmTextConstants.tk14PXLatoBlackBold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
