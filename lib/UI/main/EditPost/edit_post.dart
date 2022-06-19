// author: Prateek Aher
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/threekm_textstyles.dart';

class EditPost extends StatelessWidget {
  const EditPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Edit Post", style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          Center(
            child: Container(
              height: 40,
              width: 88,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: const Color(0xff3E7EFF), //Colors.grey.shade300,
              ),
              alignment: Alignment.center,
              child: Text(
                'Save',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              ),
            ),
          )
        ],
        bottom: PreferredSize(
            child: Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: Color(0xffc7c7c7),
            ),
            preferredSize: Size(MediaQuery.of(context).size.width * 0.8, 10)),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
