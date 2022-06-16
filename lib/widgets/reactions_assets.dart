import 'package:flutter/material.dart';
import 'package:threekm/Custom_library/flutter_reaction_button.dart';

final defaultInitialReaction = Reaction(
  id: null,
  icon: _buildIcon('assets/un_like_icon.png'),
);

final defaulLikeReaction = Reaction(
  id: 9,
  icon: _buildIcon('assets/like_icon.png'),
);

final reactions = [
  Reaction(
      id: 1,
      previewIcon: _buildReactionsPreviewIcon('assets/like_icon.png'),
      icon: _buildReactionsIcon(
        'assets/like_icon.png',
      ),
      title: Text('likes')),
  Reaction(
    id: 2,
    title: _buildTitle('Love'),
    previewIcon: _buildReactionsPreviewIcon('assets/love.png'),
    icon: Image.asset(
      'assets/love.png',
      height: 30,
      width: 30,
    ),
  ),
  Reaction(
    id: 3,
    title: _buildTitle('Care'),
    previewIcon: _buildReactionsPreviewIcon('assets/care.png'),
    icon: _buildReactionsIcon(
      'assets/care.png',
    ),
  ),
  Reaction(
    id: 4,
    title: _buildTitle('laugh'),
    previewIcon: _buildReactionsPreviewIcon('assets/laugh.png'),
    icon: _buildReactionsIcon(
      'assets/laugh.png',
    ),
  ),
  Reaction(
    id: 5,
    title: _buildTitle('sad'),
    previewIcon: _buildReactionsPreviewIcon('assets/sad.png'),
    icon: _buildReactionsIcon(
      'assets/sad.png',
    ),
  ),
  Reaction(
    id: 6,
    title: _buildTitle('angry'),
    previewIcon: _buildReactionsPreviewIcon('assets/angry.png'),
    icon: _buildReactionsIcon(
      'assets/angry.png',
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
