import 'package:flutter/material.dart';
import 'package:threekm/Custom_library/flutter_reaction_button.dart';

final defaultInitialReaction = Reaction(
  id: null,
  icon: _buildIcon('assets/thumbs-up.png'),
);

final defaulLikeReaction = Reaction(
  id: 9,
  icon: _buildIcon('assets/thumbs_up_red.png'),
);

final reactions = [
  Reaction(
    id: 1,
    //title: _buildTitle('Like'),
    previewIcon: _buildReactionsPreviewIcon('assets/fblike2x.png'),
    icon: _buildReactionsIcon(
      'assets/fblike2x.png',
    ),
  ),
  Reaction(
    id: 2,
    title: _buildTitle('Heart'),
    previewIcon: _buildReactionsPreviewIcon('assets/heart2x.png'),
    icon: Image.asset(
      'assets/heart2x.png',
      height: 30,
      width: 30,
    ),
  ),
  Reaction(
    id: 3,
    title: _buildTitle('Trust'),
    previewIcon: _buildReactionsPreviewIcon('assets/trust2x.png'),
    icon: _buildReactionsIcon(
      'assets/trust2x.png',
    ),
  ),
  Reaction(
    id: 4,
    title: _buildTitle('Sad'),
    previewIcon: _buildReactionsPreviewIcon('assets/sad2x.png'),
    icon: _buildReactionsIcon(
      'assets/sad2x.png',
    ),
  ),
  Reaction(
    id: 6,
    title: _buildTitle('Lol'),
    previewIcon: _buildReactionsPreviewIcon('assets/lol2x.png'),
    icon: _buildReactionsIcon(
      'assets/lol2x.png',
    ),
  ),
];

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

Padding _buildReactionsPreviewIcon(String path) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 5),
    child: Image.asset(path, height: 40),
  );
}

Image _buildIcon(String path) {
  return Image.asset(
    path,
    height: 30,
    width: 30,
  );
}

Container _buildReactionsIcon(String path) {
  return Container(
    height: 30,
    width: 30,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: AssetImage(path), fit: BoxFit.contain)),
  );
}
