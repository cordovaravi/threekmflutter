import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

class VimeoPlayerPage extends StatefulWidget {
  final String VimeoUri;
  VimeoPlayerPage({required this.VimeoUri});
  @override
  _VimeoPlayerPageState createState() => _VimeoPlayerPageState();
}

class _VimeoPlayerPageState extends State<VimeoPlayerPage> {
  String? vimeoId;

  @override
  void initState() {
    vimeoId = Uri.parse(widget.VimeoUri).pathSegments.last;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: vimeoId != null
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: Container(
                  color: Colors.black,
                  child: VimeoPlayer(
                    videoId: vimeoId!,
                  ),
                ),
              ),
            )
          : CupertinoActivityIndicator(),
    ));
  }
}
