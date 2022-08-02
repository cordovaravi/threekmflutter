import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:threekm/Custom_library/Reaction2.0/src/models/reaction.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

final defaultInitialReaction = Reaction(
    id: 0,
    icon: _buildReactionsIcon('assets/un_like_icon.png',
        Text("Like", style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold)),
    value: "Like",
    title:
        Text('like', style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold));

final defaulLikeReaction = Reaction(
    id: 0,
    icon: _buildReactionsIcon('assets/like_icon.png',
        Text("Like", style: TextStyle(color: Colors.black))),
    value: "Like",
    title: Text('like'));

getReaction(String type) {
  return Reaction(
      id: 99,
      icon: _buildReactionsIcon('assets/$type.png',
          Text("$type", style: TextStyle(color: Colors.black))),
      value: "$type",
      title: Text('$type'));
}

final reactions = [
  Reaction(
      id: 1,
      previewIcon: _buildReactionsPreviewIcon('assets/lottie/like.json'),
      icon: _buildReactionsIcon('assets/like_icon.png',
          Text("Like", style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold)),
      value: "Like",
      title: Text('like')),
  Reaction(
    id: 2,
    title: _buildTitle('Love'),
    previewIcon: _buildReactionsPreviewIcon(
      'assets/lottie/love.json',
    ),
    icon: _buildReactionsIcon('assets/love.png',
        Text("Love", style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold)),
    value: "Love",
  ),
  Reaction(
    id: 3,
    title: _buildTitle('Care'),
    previewIcon: _buildReactionsPreviewIcon('assets/lottie/care.json'),
    icon: _buildReactionsIcon('assets/care.png',
        Text("Care", style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold)),
    value: "Care",
  ),
  Reaction(
    id: 4,
    title: _buildTitle('laugh'),
    previewIcon: _buildReactionsPreviewIcon('assets/lottie/laugh.json'),
    icon: _buildReactionsIcon('assets/laugh.png',
        Text("Laugh", style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold)),
    value: "Laugh",
  ),
  Reaction(
    id: 5,
    title: _buildTitle('sad'),
    previewIcon: _buildReactionsPreviewIcon('assets/lottie/sad.json'),
    icon: _buildReactionsIcon('assets/sad.png',
        Text("Sad", style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold)),
    value: "Sad",
  ),
  Reaction(
    id: 6,
    title: _buildTitle('angry'),
    previewIcon: _buildReactionsPreviewIcon('assets/lottie/angry.json'),
    icon: _buildReactionsIcon('assets/angry.png',
        Text("Angry", style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold)),
    value: "Angry",
  ),
];

Padding _buildReactionsPreviewIcon(String path) {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 5),
      child: Lottie.asset(path, height: 40)
      //Image.asset(path, height: 40),
      );
}

Container _buildTitle(String title) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Container _buildReactionsIcon(String path, Text text) {
  return Container(
    color: Colors.transparent,
    child: Row(
      children: <Widget>[
        Image.asset(path, height: 20),
        const SizedBox(width: 5),
        text,
      ],
    ),
  );
}
