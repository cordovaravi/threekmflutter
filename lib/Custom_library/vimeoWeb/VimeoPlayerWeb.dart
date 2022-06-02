import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VimeoPlayerWeb extends StatelessWidget {
  final String videoId;

  const VimeoPlayerWeb({
    Key? key,
    required this.videoId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: WebView(
        initialUrl: _videoPage(videoId),
        javascriptMode: JavascriptMode.unrestricted,
      ),
      // child: VimeoIframe(
      //   height: 300,
      //   width: MediaQuery.of(context).size.width,
      //   vimoeId: videoId,
      // ),
    );
  }

  // iframe of the vimeo video
  String _videoPage(String videoId) {
    final html = '''
            <html>
              <head>
                <style>
                  body {
                   background-color: white;
                   margin: 0px;
                   }
                </style>
                <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
                <meta http-equiv="Content-Security-Policy"
                content="default-src * gap:; script-src * 'unsafe-inline' 'unsafe-eval'; connect-src *;
                img-src * data: blob: android-webview-video-poster:; style-src * 'unsafe-inline';">
             </head>
             <body>



                <iframe src="https://player.vimeo.com/video/$videoId?h=168d86508b" width=100%; height=100%; frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe>
             </body>
            </html>
            ''';

    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(html));
    return 'data:text/html;base64,$contentBase64';
  }
}

class VimeoIframe extends StatefulWidget {
  const VimeoIframe({
    Key? key,
    this.width,
    this.height,
    this.vimoeId,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? vimoeId;

  @override
  _VimeoIframeState createState() => _VimeoIframeState();
}

class _VimeoIframeState extends State<VimeoIframe> {
  @override
  Widget build(BuildContext context) {
    String htmlData = r"""<iframe src='https://player.vimeo.com/video/""" +
        widget.vimoeId! +
        """?badge=0&amp;autopause=0&amp;player_id=0' width='""" +
        widget.width.toString() +
        """' height='""" +
        widget.height.toString() +
        """' frameborder='0' allow='autoplay; fullscreen; picture-in-picture' allowfullscreen style='aspect-ratio: 16 / 9;height:100%;width:100%;'></iframe>""";

    return Container(
        child: Html(
      data: htmlData,
      //shrinkWrap: true,
    ));
  }
}
