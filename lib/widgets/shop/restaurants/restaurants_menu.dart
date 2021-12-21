import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/providers/shop/restaurant_menu_provider.dart';
import 'package:threekm/Models/shopModel/restaurants_menu_model.dart';
import 'package:threekm/Models/shopModel/restaurants_model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/widgets/shop/restaurants/checkbox.dart';
import 'package:threekm/widgets/shop/restaurants/restaurant_details.dart';


class RestaurantMenu extends StatefulWidget {
  const RestaurantMenu({Key? key, this.data}) : super(key: key);
  final Creators? data;

  @override
  State<RestaurantMenu> createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<RestaurantMenu> {
  late bool isVeg = true;
  late bool isEgg = true;

  @override
  void initState() {
    context
        .read<RestaurantMenuProvider>()
        .menuDetailsData(mounted, widget.data?.creatorId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = context.watch<RestaurantMenuProvider>().menuDetails;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: ThreeKmScreenUtil.screenWidthDp / 2,
                        child: Text(
                          '${widget.data?.businessName}',
                          style: const TextStyle(
                              color: Color(0xFF0F0F2D),
                              fontSize: 18,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: Text(
                          '${widget.data?.restaurant!.cuisines?.join(", ")}',
                          style: const TextStyle(
                              color: Color(0xFF555C64),
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      Text(
                          '${widget.data?.address?.serviceArea}, ${widget.data?.address?.city}')
                    ],
                  ),
                  Stack(children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return RestaurantDetails(
                            result: data.result,
                            tags: widget.data?.restaurant!.cuisines,
                          );
                        }));
                      },
                      child: Container(
                        width: 150,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20)),
                            image: DecorationImage(
                              image: data.result?.creator.cover != null
                                  ? CachedNetworkImageProvider(
                                      '${data.result?.creator.cover}')
                                  : const AssetImage(
                                          'assets/shopImg/noImage.jpg')
                                      as ImageProvider,
                              //NetworkImage("${data.result?.creator.cover}"),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.6),
                                  BlendMode.colorBurn),
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'About Restaurant',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 50,
                            )
                          ],
                        ),
                      ),
                    ),
                  ])
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              height: 170,
              // width: 200,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DottedBorder(
                          strokeWidth: 3,
                          dashPattern: const [8, 4],
                          color: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: 200,
                            child: const Center(
                              child: Text(
                                'Get 20% discount Code: HAPPYNOW',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          )),
                    );
                  }),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomCheckBox(
                    size: 6,
                    label: Text('VEG'),
                    activeColor: Colors.green,
                    onClick: (status) {
                      setState(() {
                        isVeg = status;
                      });
                    },
                  ),
                  CustomCheckBox(
                    size: 6,
                    label: Text('EGG'),
                    activeColor: Colors.amber,
                    onClick: (status) {
                      isEgg = status;
                    },
                  ),
                  Container(
                    // padding: const EdgeInsets.only(left: 20),
                    width: ThreeKmScreenUtil.screenWidthDp / 2.5,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      // controller: _firstName,
                      validator: (val) {},
                      //maxLength: 16,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: const TextStyle(color: Color(0xFF0F0F2D)),
                        counterText: '',
                        filled: true,
                        prefixIcon:
                            const Icon(Icons.search, color: Color(0xFF0F0F2D)),
                        fillColor: Colors.grey[200],
                        //isDense: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 13, 10, 13),

                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(children: [
                ...?data.result?.menu
                    .map((e) => MenuTile(e: e, isVeg: isVeg, isEgg: isEgg))
                    .toList(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  const MenuTile(
      {Key? key, required this.e, required this.isVeg, required this.isEgg})
      : super(key: key);
  final Menu e;
  final bool isVeg;
  final bool isEgg;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('${e.name}(${e.menus.length})'),
      children: [
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: e.menus.length,
            itemBuilder: (_, i) {
              var menu = e.menus[i];
              return Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[300]!))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.green, width: 2)),
                          width: 20,
                          height: 20,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.green, shape: BoxShape.circle),
                          ),
                        ),
                        Text(menu.name),
                        Text(
                          '\u{20B9}${menu.price}',
                          style: TextStyle(height: 2),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        menu.image != ""
                            ? Image(
                                image: NetworkImage('${menu.image}'),
                                width: ThreeKmScreenUtil.screenWidthDp / 6,
                                height: ThreeKmScreenUtil.screenHeightDp / 6,
                              )
                            : const SizedBox(
                                width: 0,
                                height: 0,
                              ),
                        Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Color(0xFFF4F3F8)),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                              'ADD +',
                              style: TextStyle(color: Colors.green),
                            ))
                      ],
                    )
                  ],
                ),
              );
            })
      ],
    );
  }
}
