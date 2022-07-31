import 'dart:developer';

slugUrl({headLine, postId}) {
  String head =
      headLine.replaceAll(RegExp(r"[(),\s?!]+", multiLine: true), "-");
  String slugUrl;
  if (RegExp(r"[A-Za-z0-9_.,-\s]").allMatches(head).length ==
      head.toString().length) {
    log('$head-------------------------');
    slugUrl = head;
  } else {
    slugUrl = "3-km-post-detail";
  }

  return 'https://3km.in/post-detail/$slugUrl/$postId';
}
