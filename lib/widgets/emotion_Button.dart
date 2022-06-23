import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threekm/Custom_library/flutter_reaction_button.dart';
import 'package:threekm/providers/Global/logged_in_or_not.dart';
import 'package:threekm/providers/main/AthorProfile_Provider.dart';
import 'package:threekm/providers/main/NewsFeed_Provider.dart';
import 'package:threekm/providers/main/newsList_provider.dart';
import 'package:threekm/providers/main/singlePost_provider.dart';
import 'package:threekm/widgets/reactions_assets.dart' as reactionAsset;

class EmotionButton extends StatelessWidget {
  final int postId;
  final bool isLiked;
  final Reaction? initalReaction;
  final Reaction? selectedReaction;
  final List<Reaction> reactions;

  final String providerType;

  EmotionButton(
      {required this.postId,
      required this.reactions,
      required this.isLiked,
      this.initalReaction,
      this.selectedReaction,
      required this.providerType});
  @override
  Widget build(BuildContext context) {
    //super.build(context);
    postlike(label) {
      this.providerType == "NewsListProvider"
          ? context
              .read<NewsListProvider>()
              .postLike(this.postId.toString(), label)
          : providerType == "NewsFeedProvider"
              ? context
                  .read<NewsFeedProvider>()
                  .postLike(this.postId.toString(), label)
              : providerType == "postProvider"
                  ? context
                      .read<SinglePostProvider>()
                      .postLike(this.postId.toString(), label)
                      .whenComplete(() => context
                          .read<NewsListProvider>()
                          .postLike(this.postId.toString(), label))
                      .whenComplete(() => context
                          .read<NewsFeedProvider>()
                          .postLike(this.postId.toString(), label))
                  : context
                      .read<AutthorProfileProvider>()
                      .postLike(this.postId.toString(), label);
    }

    void postUnlike() {
      this.providerType == "NewsListProvider"
          ? context.read<NewsListProvider>().postUnLike(this.postId.toString())
          : providerType == "NewsFeedProvider"
              ? context
                  .read<NewsFeedProvider>()
                  .postUnLike(this.postId.toString())
              : providerType == "postProvider"
                  ? context
                      .read<SinglePostProvider>()
                      .postUnLike(this.postId.toString())
                      .whenComplete(() => context
                          .read<NewsListProvider>()
                          .postUnLike(this.postId.toString()))
                      .whenComplete(
                          () => context.read<NewsFeedProvider>().postUnLike(
                                this.postId.toString(),
                              ))
                  : context
                      .read<AutthorProfileProvider>()
                      .postUnLike(this.postId.toString());
    }

    return FittedBox(
      child: FlutterReactionButtonCheck(
          boxAlignment: Alignment.center,
          boxPosition: Position.TOP,
          onReactionChanged: (reaction, index, isChecked) async {
            print('reaction selected index: $index');
            print("is checked $isChecked");
            if (await getAuthStatus()) {
              print(this.isLiked);
              if (isLiked == true && index == -1) {
                print("remove like");
                // context
                //     .read<NewsListProvider>()
                //     .postUnLike(this.postId.toString());
                postUnlike();
              } else if (isChecked == true && index == -1) {
                print("Like");
                postlike(null);
                // context
                //     .read<NewsListProvider>()
                //     .postLike(this.postId.toString(), null);
              } else {
                print("emotion like");
                print("emotion is : ${reaction!.id}");
                if (reaction.id == null) {
                  postlike('like');
                  // context
                  //     .read<NewsListProvider>()
                  //     .postLike(this.postId.toString(), "like");
                } else if (reaction.id! == 1) {
                  postlike('like');
                  // context
                  //     .read<NewsListProvider>()
                  //     .postLike(this.postId.toString(), "like");
                } else if (reaction.id == 2) {
                  postlike('love');
                  // context
                  //     .read<NewsListProvider>()
                  //     .postLike(this.postId.toString(), "heart");
                } else if (reaction.id == 3) {
                  postlike('care');
                  // context
                  //     .read<NewsListProvider>()
                  //     .postLike(this.postId.toString(), "trust");
                } else if (reaction.id == 4) {
                  postlike('laugh');
                  // context
                  //     .read<NewsListProvider>()
                  //     .postLike(this.postId.toString(), "sad");
                } else if (reaction.id == 5) {
                  postlike('sad');
                  // context
                  //     .read<NewsListProvider>()
                  //     .postLike(this.postId.toString(), "lol");
                } else if (reaction.id == 6) {
                  postlike('angry');
                  // context
                  //     .read<NewsListProvider>()
                  //     .postLike(this.postId.toString(), "wink");
                }
                // context
                //     .read<NewsListProvider>()
                //     .postLike(this.postId.toString(), null);
              }
            } else {
              NaviagateToLogin(context);
            }
          },
          reactions: this.reactions,
          initialReaction: this.initalReaction,
          selectedReaction: this.selectedReaction),
    );
    //   );
    // });
  }
}

class AuthorEmotionButton extends StatelessWidget {
  final int postId;
  final bool isLiked;
  final Reaction? initalReaction;
  final Reaction? selectedReaction;
  final List<Reaction> reactions;

  AuthorEmotionButton(
      {required this.postId,
      required this.reactions,
      required this.isLiked,
      this.initalReaction,
      this.selectedReaction});

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return FittedBox(
      child: FlutterReactionButtonCheck(
          boxAlignment: Alignment.center,
          //boxPosition: Position.TOP,
          onReactionChanged: (reaction, index, isChecked) {
            print('reaction selected index: $index');
            print("is checked $isChecked");
            print(this.isLiked);
            if (isLiked == true && index == -1) {
              print("remove like");
              context
                  .read<AutthorProfileProvider>()
                  .postUnLike(this.postId.toString());
            } else if (isChecked == true && index == -1) {
              print("Like");
              context
                  .read<AutthorProfileProvider>()
                  .postLike(this.postId.toString(), null);
            } else {
              // print("emotion like");
              // print("emotion is : ${reaction!.id}");
              // if (reaction.id! == 1) {
              //   context
              //       .read<NewsListProvider>()
              //       .postLike(this.postId.toString(), "like");
              // } else if (reaction.id == 2) {
              //   context
              //       .read<NewsListProvider>()
              //       .postLike(this.postId.toString(), "heart");
              // } else if (reaction.id == 3) {
              //   context
              //       .read<NewsListProvider>()
              //       .postLike(this.postId.toString(), "trust");
              // } else if (reaction.id == 4) {
              //   context
              //       .read<NewsListProvider>()
              //       .postLike(this.postId.toString(), "sad");
              // } else if (reaction.id == 5) {
              //   context
              //       .read<NewsListProvider>()
              //       .postLike(this.postId.toString(), "lol");
              // } else if (reaction.id == 6) {
              //   context
              //       .read<NewsListProvider>()
              //       .postLike(this.postId.toString(), "wink");
              // }
              // context
              //     .read<NewsListProvider>()
              //     .postLike(this.postId.toString(), null);
            }
          },
          reactions: this.reactions,
          initialReaction: this.initalReaction,
          selectedReaction: this.selectedReaction),
    );
    //   );
    // });
  }
}

class PostAuthorEmotionButton extends StatelessWidget {
  final int postId;
  final bool isLiked;
  final Reaction? initalReaction;
  final Reaction? selectedReaction;
  final List<Reaction> reactions;

  PostAuthorEmotionButton(
      {required this.postId,
      required this.reactions,
      required this.isLiked,
      this.initalReaction,
      this.selectedReaction});

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return FittedBox(
      child: FlutterReactionButtonCheck(
          boxAlignment: Alignment.center,
          //boxPosition: Position.TOP,
          onReactionChanged: (reaction, index, isChecked) {
            print('reaction selected index: $index');
            print("is checked $isChecked");
            print(this.isLiked);
            if (isLiked == true && index == -1) {
              print("remove like");
              context
                  .read<AutthorProfileProvider>()
                  .authorPostUnLike(this.postId.toString());
            } else if (isChecked == true && index == -1) {
              print("Like");
              context
                  .read<AutthorProfileProvider>()
                  .authorPostLike(this.postId.toString(), null);
            } else {
              // print("emotion like");
              // print("emotion is : ${reaction!.id}");
              // if (reaction.id! == 1) {
              //   context
              //       .read<NewsListProvider>()
              //       .postLike(this.postId.toString(), "like");
              // } else if (reaction.id == 2) {
              //   context
              //       .read<NewsListProvider>()
              //       .postLike(this.postId.toString(), "heart");
              // } else if (reaction.id == 3) {
              //   context
              //       .read<NewsListProvider>()
              //       .postLike(this.postId.toString(), "trust");
              // } else if (reaction.id == 4) {
              //   context
              //       .read<NewsListProvider>()
              //       .postLike(this.postId.toString(), "sad");
              // } else if (reaction.id == 5) {
              //   context
              //       .read<NewsListProvider>()
              //       .postLike(this.postId.toString(), "lol");
              // } else if (reaction.id == 6) {
              //   context
              //       .read<NewsListProvider>()
              //       .postLike(this.postId.toString(), "wink");
              // }
              // context
              //     .read<NewsListProvider>()
              //     .postLike(this.postId.toString(), null);
            }
          },
          reactions: this.reactions,
          initialReaction: this.initalReaction,
          selectedReaction: this.selectedReaction),
    );
    //   );
    // });
  }
}
