import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SinglePostLoading extends StatelessWidget {
  const SinglePostLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      body: Material(
        color: Colors.white,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 44,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        margin: EdgeInsets.only(left: 18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Color(0xFF0F0F2D),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(children: [
                                    Shimmer.fromColors(
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                      ),
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      enabled: true,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 7),
                                      child: Shimmer.fromColors(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        enabled: true,
                                      ),
                                    )
                                  ]),
                                ),
                                Shimmer.fromColors(
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    width: MediaQuery.of(context).size.width,
                                    height: 224,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  enabled: true,
                                )
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
                // Positioned(
                //   bottom: 0,
                //   child: Container(
                //     color: Colors.blueAccent,
                //     height: MediaQuery.of(context).size.height * 0.1,
                //     width: MediaQuery.of(context).size.width,
                //   ),
                // ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.06,
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: ButtonBar(
                        alignment: MainAxisAlignment.center, children: []),
                  ),
                )
              ],
            )),
      ),
    ));
  }
}
