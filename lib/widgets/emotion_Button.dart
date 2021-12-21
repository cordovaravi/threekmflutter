import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threekm/Custom_library/flutter_reaction_button.dart';
import 'package:threekm/providers/main/newsList_provider.dart';
import 'package:threekm/widgets/reactions_assets.dart' as reactionAsset;

class EmotionButton extends StatelessWidget {
  final int postId;
  final bool isLiked;
  final Reaction? initalReaction;
  final Reaction? selectedReaction;
  final List<Reaction> reactions;

  EmotionButton(
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
                  .read<NewsListProvider>()
                  .postUnLike(this.postId.toString());
            } else if (isChecked == true && index == -1) {
              print("Like");
              context
                  .read<NewsListProvider>()
                  .postLike(this.postId.toString(), null);
            } else {
              print("emotion like");
              print("emotion is : ${reaction!.id}");
              if (reaction.id! == 1) {
                context
                    .read<NewsListProvider>()
                    .postLike(this.postId.toString(), "like");
              } else if (reaction.id == 2) {
                context
                    .read<NewsListProvider>()
                    .postLike(this.postId.toString(), "heart");
              } else if (reaction.id == 3) {
                context
                    .read<NewsListProvider>()
                    .postLike(this.postId.toString(), "trust");
              } else if (reaction.id == 4) {
                context
                    .read<NewsListProvider>()
                    .postLike(this.postId.toString(), "sad");
              } else if (reaction.id == 5) {
                context
                    .read<NewsListProvider>()
                    .postLike(this.postId.toString(), "lol");
              } else if (reaction.id == 6) {
                context
                    .read<NewsListProvider>()
                    .postLike(this.postId.toString(), "wink");
              }
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
