import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threekm/Models/comment_model.dart';
import 'package:threekm/UI/main/News/Widgets/comment_Loading.dart';
import 'package:threekm/providers/main/comment_Provider.dart';

import '../../../../commenwidgets/CustomSnakBar.dart';

class CommentSection extends StatefulWidget {
  const CommentSection({Key? key, required int this.postId}) : super(key: key);
  final int postId;

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late FocusNode _node;
  late TextEditingController _controller;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Comments',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(16, 24, 16, MediaQuery.of(context).size.height * 0.1),
            child: Consumer<CommentProvider>(
                builder: (context, provider, _) => provider.isGettingComments
                    ? CommentsLoadingEffectsNew()
                    : provider.commentCount == 0
                        ? NoCommentsWidget()
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              children: provider.allComments
                                  .map((e) => CommentWidget(e, widget.postId))
                                  .toList(),
                            ),
                          ))),
        bottomSheet: BottomAppBar(
            elevation: 0,
            child: Container(
                margin: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: const Color(0xfffafafa)),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (v) {
                      if (v == null || v.isEmpty || v.trim().isEmpty)
                        return '';
                      else
                        return null;
                    },
                    focusNode: _node,
                    controller: _controller,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    textAlignVertical: TextAlignVertical.center,
                    // cursorHeight: 18,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'Leave your comment here',
                      hintStyle: TextStyle(color: const Color(0xffa7a6a6), fontSize: 18),
                      suffix: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate() &&
                              !(context.read<CommentProvider>().isLoading)) {
                            context
                                .read<CommentProvider>()
                                .postCommentApi(widget.postId, _controller.text.trim())
                                .then((value) {
                              _controller.clear();
                              FocusScope.of(context).unfocus();
                            });
                          } else {
                            CustomSnackBar(context, Text("Comment cant be blank"));
                          }
                        },
                        child: Container(
                          height: 20,
                          child: Icon(Icons.send),
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ))),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _node = FocusNode();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _node.dispose();
    _controller.dispose();
    super.dispose();
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget(this.comment, this.postId, {Key? key}) : super(key: key);
  final int postId;
  final Comment comment;
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 8,
      leading: Container(
        height: h * 0.05,
        width: h * 0.05,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.cover, image: CachedNetworkImageProvider(comment.avatar.toString()))),
      ),
      title: Container(
        padding: EdgeInsets.only(left: 10, right: 0, top: 0, bottom: 8),
        decoration: BoxDecoration(
            color: const Color(0xfffafafa), borderRadius: BorderRadius.circular(h * 0.01)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  comment.username.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(width: 5),
                Text(
                  comment.timeLapsed ?? '',
                  style: TextStyle(
                      color: const Color(0xffa7a6a6), fontWeight: FontWeight.normal, fontSize: 12),
                ),
                Spacer(),
                PopupMenuButton<String>(
                    color: const Color(0xfffafafa),
                    icon: FittedBox(fit: BoxFit.fitHeight, child: Icon(Icons.more_vert)),
                    itemBuilder: (context) => [
                          //TODO: implement in future build
                          // PopupMenuItem<String>(
                          //     child: Text('Report comment', style: TextStyle(color: Colors.grey)),
                          //     onTap: null),
                          PopupMenuItem<String>(
                            child: Text(
                              'Delete comment',
                              style: TextStyle(
                                  color:
                                      (comment.isself != true) ? Colors.grey.shade400 : Colors.red),
                            ),
                            onTap: (comment.isself != true)
                                ? null
                                : () {
                                    context
                                        .read<CommentProvider>()
                                        .removeComment(comment.commentId!, postId);
                                  },
                          ),
                        ])
              ],
            ),
            // comment.isself != true ? SizedBox(height: 14) : SizedBox.shrink(),
            Text(
              comment.comment.toString(),
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}

class NoCommentsWidget extends StatelessWidget {
  const NoCommentsWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double sw = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/chat.png', width: sw * 0.3),
          SizedBox(height: 17),
          Text(
            'No Comments Yet',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 20, color: Color(0xffA7A6A6)),
          ),
          SizedBox(height: 6),
          Text(
            'Be the first one to comment',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xffA7A6A6)),
          ),
        ],
      ),
    );
  }
}
