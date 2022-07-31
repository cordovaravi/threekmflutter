import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_webservice/directions.dart' as directions;
import 'package:html/dom.dart' as html;
import 'package:provider/provider.dart';
import 'package:threekm/Models/deepLinkPost.dart';
import 'package:threekm/UI/main/CommonWidgets/app_bar_util.dart';
import 'package:threekm/UI/main/CommonWidgets/insert_post_location.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/providers/main/EditPost_Provider.dart';
import 'package:threekm/providers/main/singlePost_provider.dart';
import 'package:threekm/utils/utils.dart';

class EditPost extends StatefulWidget {
  const EditPost({Key? key, this.postId}) : super(key: key);
  final int? postId;
  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  TextEditingController _tagsController = TextEditingController();
  TextEditingController _storyController = TextEditingController();
  TextEditingController _headLineController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    print("POST ID = ${widget.postId}");
    Future.microtask(() async {
      final editPost = context.read<EditPostProvider>();
      if (widget.postId != null)
        await context.read<SinglePostProvider>().getPostDetails(widget.postId, true, 'en');
      final location = context.read<LocationProvider>();
      final post = context.read<SinglePostProvider>().postDetails!.data!.result!.post!;

      editPost
        // pre-populate postId
        ..postId = post.postId

        // pre-populate post location
        ..geometry = (post.latitude != null && post.longitude != null)
            ? directions.Geometry(
                location: directions.Location(lat: post.latitude!, lng: post.longitude!))
            : directions.Geometry(
                location: directions.Location(
                    lat: location.getLatitude ?? 0.0, lng: location.getLongitude ?? 0.0))
        ..selectedAddress = post.location
        // (post.latitude != null && post.longitude != null)
        //   ? await getAddressFromKlatlong(post.latitude!, post.longitude!)
        //   : location.AddressFromCordinate

        // pre-populate tags
        ..tagsList.clear();
      post.tags?.forEach((element) {
        editPost.addTag(element);
      });

      // pre-populate headline
      editPost.headline = (post.submittedHeadline ?? '').trim();
      _headLineController.text = (post.submittedHeadline ?? '').trim();

      // pre-populate description
      final text = htmlToText(post.submittedStory ?? '');
      editPost.description = text ?? '';
      _storyController.text = text ?? '';

      //pre-populate images and videos
      editPost
        ..imageList.clear()
        ..imageList.addAll(post.images ?? <String>[])
        ..videoList.clear()
        ..videoList.addAll(post.videos ?? <Video>[]);
    });
  }

  @override
  void dispose() {
    _tagsController.dispose();
    _storyController.dispose();
    _headLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final imageList = context.watch<AddPostProvider>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          bool? x = await showWarningDialog(context);
          return x ?? false;
        },
        child: Scaffold(
          appBar: AppBarUtil.appBar(
            title: "Edit Post",
            primaryActionWidget: _savePostButton(context),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                SizedBox(height: 20),
                _locationFieldTitle,
                SizedBox(height: 5),
                locationSection(context),
                Divider(color: Color(0xFFa7abad).withOpacity(0.5), thickness: 1),
                SizedBox(height: 20),
                buildMediaHeading,
                SizedBox(height: 2),
                buildImageGrid(),
                SizedBox(height: 30),
                builddescriptionHeading,
                buildDescriptionField(),
                SizedBox(height: 20),
                buildPostTitleHeading,
                buildPostTitleField(),
                SizedBox(height: 20),
                buildTagsHeading,
                SizedBox(height: 6),
                buildTags,
                // SizedBox(height: 16),
                Divider(color: Color(0xff7c7c7c).withOpacity(0.5), thickness: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> showWarningDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: ThreeKmTextConstants.black,
              ),
              titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              title: Text("Discard changes?"),
              contentTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: ThreeKmTextConstants.grey,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              content: Text("Are you sure you want to leave without saving your changes?"),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actionsPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              actions: [
                LayoutBuilder(builder: (context, constraints) {
                  return Row(
                    children: [
                      Container(
                        width: constraints.maxWidth * 0.57,
                        height: 46,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(), primary: const Color(0xFF3E7EFF)),
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                "Continue Editing",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: constraints.maxWidth * 0.35,
                        height: 46,
                        child: OutlinedButton(
                            onPressed: () {
                              context.read<EditPostProvider>().clear();
                              Navigator.pop(context, true);
                            },
                            style: OutlinedButton.styleFrom(
                              shape: StadiumBorder(),
                              primary: const Color(0xFF3E7EFF),
                              side: BorderSide(color: const Color(0xFF3E7EFF), width: 1),
                            ),
                            child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text("Discard",
                                    style: TextStyle(fontWeight: FontWeight.w400)))),
                      )
                    ],
                  );
                }),
              ],
            ));
  }

  Center _savePostButton(BuildContext context) {
    return Center(
      child: Consumer<EditPostProvider>(builder: (_, provider, __) {
        return ElevatedButton(
          onPressed: (provider.description.trim().isEmpty &&
                  (provider.imageList.isEmpty && provider.videoList.isEmpty))
              ? null
              : () async {
                  if (!provider.isLoading) {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState?.validate() ?? false) {
                      if (provider.geometry == null ||
                          (provider.selectedAddress?.isEmpty ?? false) ||
                          provider.selectedAddress == null) {
                        Fluttertoast.showToast(msg: "Location required");
                        return;
                      }

                      await provider.savePost();
                      provider.clear();
                      Navigator.pop(context, true);
                      // provider.dispose();
                    }
                  }
                },
          child: provider.isLoading
              ? CircularProgressIndicator(color: ThreeKmTextConstants.white)
              : Text(
                  "Save",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
                ),
          style: ElevatedButton.styleFrom(
            primary: provider.selectedAddress != null
                ? const Color(0xFF3E7EFF)
                : const Color(0xffF1F2F6),
            elevation: 0,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          ),
        );
      }),
    );
  }

  TextFormField buildDescriptionField() {
    final provider = context.read<EditPostProvider>();
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlignVertical: TextAlignVertical.top,
      controller: _storyController,
      onChanged: (String text) {
        provider.description = text;
      },
      // validator: (v) {
      //   if ((v?.length ?? 0) > 2000) return "Character count exceeded";
      //   return null;
      // },
      maxLines: null,
      // minLines: 2,
      maxLength: 2000,
      style: ThreeKmTextConstants.tk16PXLatoBlackRegular.copyWith(
        color: Color(0xFF0F0F2D),
        fontWeight: FontWeight.w400,
      ),
      decoration: buildInputDecoration.copyWith(hintText: "Enter your text here"),
    );
  }

  Text get builddescriptionHeading => Text("Description", style: _titleStyle);

  get buildMediaHeading => Consumer<EditPostProvider>(builder: (_, provider, __) {
        return Visibility(
            visible: provider.imageList.isNotEmpty || provider.videoList.isNotEmpty,
            child: Text("Media", style: _titleStyle));
      });

  TextFormField buildPostTitleField() {
    final provider = context.read<EditPostProvider>();
    return TextFormField(
      controller: _headLineController,
      onChanged: (String text) {
        provider.headline = text;
      },
      // validator: (v) {
      //   if ((v?.length ?? 0) > 100) return "Character count exceeded";
      //   return null;
      // },
      maxLength: 100,
      textAlignVertical: TextAlignVertical.top,
      style: ThreeKmTextConstants.tk16PXLatoBlackRegular.copyWith(
        color: Color(0xFF0F0F2D),
        fontWeight: FontWeight.w400,
      ),
      minLines: 1,
      maxLines: null,
      decoration: buildInputDecoration.copyWith(hintText: "Enter your Headline/Title"),
    );
  }

  Column get buildPostTitleHeading {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          Text("Headline/Title ", style: _titleStyle),
          Text("(optional)", style: _titleStyle.copyWith(fontSize: 12)),
        ]),
        SizedBox(height: 2),
        Text(
          "Adding a Headline will help your post to stand out",
          style: _titleStyle.copyWith(fontSize: 11, color: ThreeKmTextConstants.grey2),
        ),
      ],
    );
  }

  Consumer<EditPostProvider> locationSection(BuildContext context) {
    return Consumer<EditPostProvider>(
      builder: (_, provider, __) {
        addOrChangeLocation() async {
          FocusScope.of(context).unfocus();
          if (context.read<LocationProvider>().ispermitionGranted) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => InsertPostLocation(isEditing: true)));
          }
        }

        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Text(
              "${provider.selectedAddress ?? ''} ",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            // SizedBox(width: 10),
            InkWell(
              onTap: addOrChangeLocation,
              child: Text(
                provider.selectedAddress == null ? "Add Post location" : "Change Location",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: const Color(0xFF3E7EFF), fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  Consumer<EditPostProvider> buildImageGrid() {
    return Consumer<EditPostProvider>(builder: (context, provider, _) {
      return Visibility(
        visible: provider.imageList.isNotEmpty || provider.videoList.isNotEmpty,
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            ...provider.imageList.asMap().entries.map((e) => Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        height: 82,
                        width: 82,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            color: const Color(0xffD9D9D9), borderRadius: BorderRadius.circular(8)),
                        child: CachedNetworkImage(imageUrl: e.value, fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                          height: 20,
                          width: 20,
                          // margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Color(0xffFF5858), borderRadius: BorderRadius.circular(8)),
                          child: InkWell(
                            onTap: () {
                              context.read<EditPostProvider>().removeImage(e.key);
                            },
                            child: Icon(
                              FeatherIcons.x,
                              size: 12,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ],
                )),
            ...provider.videoList.asMap().entries.map((e) => Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        height: 82,
                        width: 82,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            color: const Color(0xffD9D9D9), borderRadius: BorderRadius.circular(8)),
                        child: e.value.thumbnail != null && (e.value.thumbnail?.isNotEmpty ?? false)
                            ? CachedNetworkImage(imageUrl: e.value.thumbnail!, fit: BoxFit.cover)
                            : Image.asset(
                                "assets/ring_icon.png",
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                          height: 20,
                          width: 20,
                          // margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Color(0xffFF5858), borderRadius: BorderRadius.circular(8)),
                          child: InkWell(
                            onTap: () {
                              context.read<EditPostProvider>().removeVideo(e.key);
                            },
                            child: Icon(
                              FeatherIcons.x,
                              size: 12,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ],
                ))
          ],
        ),
      );
    });
  }

  Row get _locationFieldTitle {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(
          Icons.location_on_rounded,
          size: 24,
          color: const Color(0xFF7c7c7c).withOpacity(0.5),
        ),
        // SizedBox(width: 1),
        Text(
          "Post Location ",
          style: _titleStyle,
        ),
        Text(
          "(required)",
          style: _titleStyle.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  InputDecoration get buildInputDecoration {
    return InputDecoration(
        border: _underlineInputBorder,
        focusedErrorBorder: _underlineInputBorder,
        focusedBorder: _underlineInputBorder,
        enabledBorder: _underlineInputBorder);
  }

  UnderlineInputBorder get _underlineInputBorder =>
      UnderlineInputBorder(borderSide: BorderSide(color: const Color(0xff7c7c7c)));

  Widget get buildTagsHeading => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text("Tags ", style: _titleStyle),
              Text("(optional)", style: _titleStyle.copyWith(fontSize: 12))
            ]),
            SizedBox(height: 2),
            Text(
              "Adding tags will help your post reach more people",
              style: _titleStyle.copyWith(fontSize: 11, color: ThreeKmTextConstants.grey2),
            ),
          ],
        ),
      );

  TextStyle get _titleStyle => GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF7c7c7c));

  Widget get buildTags {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Consumer<EditPostProvider>(
        builder: (context, provider, _) {
          return Wrap(
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            runSpacing: -5,
            spacing: 5,
            children: [
              ...provider.tagsList.asMap().entries.map((entry) {
                return Chip(
                  label: Text(entry.value.toString()),
                  backgroundColor: Colors.white,
                  shape: StadiumBorder(),
                  side: BorderSide(color: const Color(0xFF8E8A8A)),
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8E8A8A),
                  ),
                  deleteButtonTooltipMessage: 'Remove tag',
                  useDeleteButtonTooltip: true,
                  onDeleted: () {
                    context.read<EditPostProvider>().removeTag(entry.key);
                  },
                  deleteIconColor: const Color(0xFF8E8A8A),
                  deleteIcon: Icon(Icons.cancel_rounded),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                );
              }).toList(),
              ActionChip(
                label: Text('+ Add'),
                onPressed: () => addTag(context),
                backgroundColor: Colors.white,
                shape: StadiumBorder(),
                labelStyle: GoogleFonts.poppins(
                    fontSize: 14, color: const Color(0xff3e7eff), fontWeight: FontWeight.w700),
                elevation: 0,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                side: BorderSide(width: 1, color: const Color(0xFF3E7EFF)),
              ),
            ],
          );
        },
      ),
    );
  }

  addTag(BuildContext context) async {
    String? tag = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            "Add Tag",
            style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold
                .copyWith(color: Colors.black, fontWeight: FontWeight.w900),
          ),
          content: TextField(
            controller: _tagsController,
            decoration: InputDecoration(
                hintText: "Tag",
                hintStyle: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold
                    .copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold.copyWith(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
              },
            ),
            TextButton(
              child: Text(
                "Continue",
                style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold.copyWith(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop(_tagsController.text.trim());
                FocusScope.of(context).unfocus();
              },
            )
          ],
        );
      },
    );
    if (tag != null && _tagsController.text.trim().isNotEmpty) {
      context.read<EditPostProvider>().addTag(_tagsController.text.trim());
      _tagsController.clear();
    }
  }
}

String? htmlToText(String htmlText) {
  String elementToText(html.Element? e) {
    if (e?.localName == "ul") {
      return "\n" + (e?.children.map((e1) => e1.text + "\n").join("\n") ?? '') + "\n";
    } else if (e?.localName == "span" || e?.children.length == 0) {
      return (e?.text ?? '') + ((e?.localName == "b" || e?.localName == "br") ? "\n" : "");
    } else {
      return (e?.children.map((e2) => elementToText(e2)).join("\n") ?? '');
    }
  }

  return (elementToText(html.Document.html(htmlText).body)).trim();
}
