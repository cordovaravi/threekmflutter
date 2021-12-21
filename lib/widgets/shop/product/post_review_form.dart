import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import 'package:threekm/providers/shop/user_review_provider.dart';


import 'package:image_picker/image_picker.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class PostReview extends StatefulWidget {
  PostReview({Key? key, required this.name, required this.catalogId})
      : super(key: key);
  final String name;
  final int catalogId;

  @override
  _PostReviewState createState() => _PostReviewState();
}

class _PostReviewState extends State<PostReview> {
  TextEditingController _reviewTitle = TextEditingController();
  TextEditingController _reviewDetailed = TextEditingController();
  final picker = ImagePicker();

  List<XFile> img = [];

  @override
  void initState() {
    _reviewTitle.addListener(() {
      setState(() {});
    });
    _reviewDetailed.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _reviewTitle.dispose();
    _reviewDetailed.dispose();
    super.dispose();
  }

  showOption(i) {
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height / 4,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                          //imageQuality: 50
                        );

                        image != null
                            ? setState(() {
                                img.add(image);
                              })
                            : null;
                        print(
                            '${image?.name}==================================');
                      },
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  // color: Colors.orange[50],
                                  color: Color(0xFFF8D8AE),
                                  borderRadius: BorderRadius.circular(15)),
                              margin: const EdgeInsets.only(
                                  top: 20, bottom: 5, left: 20, right: 20),
                              padding: EdgeInsets.all(15),
                              //color: Colors.orange[200],
                              child: const Icon(
                                Icons.image_outlined,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                            const Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                'Pick Image From Gallery',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'Metropolis'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {},
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  // color: Colors.orange[50],
                                  color: Color(0xFFC5D9FF),
                                  borderRadius: BorderRadius.circular(15)),
                              margin: const EdgeInsets.only(
                                  top: 20, bottom: 10, left: 20, right: 20),
                              padding: EdgeInsets.all(15),
                              //color: Colors.orange[200],
                              child: const Icon(
                                Icons.camera_outlined,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                'Pick Image From Camera',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'Metropolis'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  List<bool> isSelected = [true, false, false, false, false];
  List<bool> isSelectedDelivery = [true, false, false, false, false];
  int productRating = 1;
  int deliveryRating = 1;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: ThreeKmScreenUtil.screenHeightDp / 1.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.clear_rounded,
                size: 30,
              ),
              //padding: const EdgeInsets.all(20),
            ),
          ),
          Container(
            height: ThreeKmScreenUtil.screenHeightDp / 1.2,
            width: ThreeKmScreenUtil.screenWidthDp,
            padding: const EdgeInsets.all(20),
            //alignment: Alignment.bottomCenter,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 30),
                      child: Text(
                        widget.name,
                        style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold,
                      ),
                    ),
                     Text(
                      '1.   Select a rating',
                      style:ThreeKmTextConstants.tk14PXPoppinsBlackMedium,
                    ),
                    SizedBox(
                      width: ThreeKmScreenUtil.screenWidthDp,
                      height: 70,
                      //color: Colors.blue,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                            5,
                            (j) => InkWell(
                                  onTap: () {
                                    setState(() {
                                      productRating = j + 1;
                                      for (int i = 0;
                                          i < isSelected.length;
                                          i++) {
                                        isSelected[i] = i == j;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 60,
                                    // height: 30,
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSelected[j]
                                              ? Color(0xFFFBA924)
                                              : Colors.grey[350]!,
                                        ),
                                        color: isSelected[j]
                                            ? Color(0xFFFBA924)
                                            : Color(0xFFF4F3F8),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star_rate_rounded,
                                          color: isSelected[j]
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                        Text(
                                          '${j + 1}',
                                          style: TextStyle(
                                            color: isSelected[j]
                                                ? Colors.white
                                                : Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text(
                            '2.   Add Review Title',
                            style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium,
                          ),
                          Text("(${_reviewTitle.text.length}/20)"),
                        ],
                      ),
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Title is required';
                        }
                      },
                      controller: _reviewTitle,
                      maxLength: 20,
                      decoration: InputDecoration(
                          counterText: '',
                          hintText: '    Write here…',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text(
                            '3.   Detailed Review',
                            style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium,
                          ),
                          Text("(${_reviewDetailed.text.length}/140)"),
                        ],
                      ),
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Review Detailed is required';
                        }
                      },
                      controller: _reviewDetailed,
                      maxLength: 140,
                      maxLines: 4,
                      decoration: InputDecoration(
                          counterText: '',
                          hintText: '    Write here…',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                     Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text(
                        '4.   Add a Photo(optional)',
                        style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium,
                      ),
                    ),
                    Row(
                      children: [
                        img.length <= 2
                            ? InkWell(
                                onTap: () {
                                  showOption(0);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF4F3F8),
                                      border:
                                          Border.all(color: Color(0xFF3E7EFF)),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Color(0xFF3E7EFF),
                                    size: ThreeKmScreenUtil.screenWidthDp / 7,
                                  ),
                                ),
                              )
                            : const SizedBox(
                                width: 0,
                                height: 0,
                              ),
                        ...List.generate(
                            img.length,
                            (index) => Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      margin:
                                          EdgeInsets.only(top: 10, left: 10),
                                      //padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFF4F3F8),
                                          border: Border.all(
                                              color: Color(0xFF3E7EFF)),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.file(
                                          File(img[index].path),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          img.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red[400]),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                      ],
                    ),
                     Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text(
                        '5.   Rate Delivery Experience',
                        style: ThreeKmTextConstants.tk14PXPoppinsBlackMedium,
                      ),
                    ),
                    SizedBox(
                      width: ThreeKmScreenUtil.screenWidthDp,
                      height: 70,
                      //color: Colors.blue,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                            5,
                            (j) => InkWell(
                                  onTap: () {
                                    setState(() {
                                      deliveryRating = j + 1;
                                      for (int i = 0;
                                          i < isSelectedDelivery.length;
                                          i++) {
                                        isSelectedDelivery[i] = i == j;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 60,
                                    // height: 30,
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSelectedDelivery[j]
                                              ? Color(0xFFFBA924)
                                              : Colors.grey[350]!,
                                        ),
                                        color: isSelectedDelivery[j]
                                            ? Color(0xFFFBA924)
                                            : Color(0xFFF4F3F8),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star_rate_rounded,
                                          color: isSelectedDelivery[j]
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                        Text(
                                          '${j + 1}',
                                          style: TextStyle(
                                            color: isSelectedDelivery[j]
                                                ? Colors.white
                                                : Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                      ),
                    ),
                    _formKey.currentState != null &&
                            _formKey.currentState!.validate()
                        ? Center(
                            heightFactor: 2,
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  print(_reviewTitle.text);
                                  print(_reviewDetailed.text);
                                  print('$productRating========');
                                  print('$deliveryRating-------');
                                  context
                                      .read<UserReviewProvider>()
                                      .postUserReview(
                                          mounted,
                                          widget.catalogId,
                                          productRating,
                                          _reviewTitle.text,
                                          _reviewDetailed.text,
                                          img,
                                          deliveryRating);
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        const StadiumBorder()),
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF3E7EFF)),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    elevation: MaterialStateProperty.all(5),
                                    shadowColor: MaterialStateProperty.all(
                                        Color(0xFFFC5E6A33)),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.only(
                                            left: 30,
                                            right: 30,
                                            top: 15,
                                            bottom: 15))),
                                icon: const Icon(Icons.adjust_rounded),
                                label: const Text(
                                  'Save Review',
                                  style: TextStyle(fontSize: 18),
                                )),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
