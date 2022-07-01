import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/Custom_library/progress_indicator/CircularProgress.dart';
import 'package:threekm/providers/main/AddPost_Provider.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class PostUploadPage extends StatefulWidget {
  final String? Title;
  final String? Story;
  final String? address;
  final double? lat;
  final double? long;
  PostUploadPage(
      {this.Story, this.Title, this.address, this.lat, this.long, Key? key})
      : super(key: key);

  @override
  _PostUploadPageState createState() => _PostUploadPageState();
}

class _PostUploadPageState extends State<PostUploadPage> {
  @override
  void initState() {
    Future.microtask(() {
      context.read<AddPostProvider>().uploadPng(context, widget.Title,
          widget.Story, widget.address, widget.lat, widget.long);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // final addpostProvider = context.watch<AddPostProvider>();
    // if (addpostProvider.ispostUploaded != null &&
    //     addpostProvider.ispostUploaded == true &&
    //     mounted) {
    //   ScaffoldMessenger.of(context).removeCurrentSnackBar();
    //   Future.delayed(Duration(seconds: 1), () {
    //     CustomSnackBar(context, Text("Post has been submmitted"));
    //   }).then((value) => addpostProvider.removeSnack());
    //   //     });
    // } else if (addpostProvider.isUploadError) {
    //   Future.delayed(Duration(seconds: 1), () {
    //     CustomSnackBar(context, Text("Upload Failed!"));
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0F0F2D),
        title: Text(
          "UPLOADING",
          style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
        ),
        leading: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text(
                          "Once start uploading media you cant able to perform operations."),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("ok"))
                      ],
                    );
                  });
              //
            },
            icon: Icon(FeatherIcons.info)),
      ),
      body: Column(
        children: [
          Spacer(
            flex: 1,
          ),
          Center(
            child: Container(
                height: 219,
                width: 219,
                //color: Colors.amber,
                child: Consumer<AddPostProvider>(
                  builder: (context, controller, _) {
                    return CircularPercentIndicator(
                      radius: 80.0,
                      lineWidth: 20.0,
                      backgroundColor: Colors.grey.shade300,
                      circularStrokeCap: CircularStrokeCap.round,
                      percent: double.parse(
                              double.parse(controller.uploadPercent)
                                  .toStringAsFixed(0)) /
                          100,
                      center: Text(
                        "${double.parse(controller.uploadPercent).toStringAsFixed(2)}" +
                            "%",
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    );
                  },
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Uploading..",
            style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold,
          ),
          Text(
            "Your post is being uploaded.",
            style: ThreeKmTextConstants.tk14PXLatoBlackRegular,
          ),
          Spacer(
            flex: 1,
          ),
          // TextButton(
          //     onPressed: () {},
          //     child: Text(
          //       "Cancel Upload",
          //       style: ThreeKmTextConstants.tk14PXPoppinsRedSemiBold,
          //     )),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
