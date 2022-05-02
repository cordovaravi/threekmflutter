import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/Models/shopModel/cuisines_restaurants_list_model.dart';
import 'package:threekm/Models/shopModel/restaurants_model.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/localization/localize.dart';
import 'package:threekm/main.dart';
import 'package:threekm/providers/shop/cart_provider.dart';
import 'package:threekm/providers/shop/restaurant_menu_provider.dart';
import 'package:threekm/Models/shopModel/restaurants_menu_model.dart';

import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/utils.dart';
import '../../shop/cart/cart_item_list_modal.dart';
import '../../shop/restaurants/checkbox.dart';
import '../../shop/restaurants/restaurant_details.dart';
// import 'package:popover/popover.dart';

final GlobalKey<_RestaurantCuisinesMenu> restaurantMenuKey = GlobalKey();

class RestaurantCuisinesMenu extends StatefulWidget {
  RestaurantCuisinesMenu({Key? key, this.data}) : super(key: key);
  CuisinesRestaurant? data;

  @override
  State<RestaurantCuisinesMenu> createState() => _RestaurantCuisinesMenu();
}

class _RestaurantCuisinesMenu extends State<RestaurantCuisinesMenu> {
  late bool isVeg = true;
  late bool isEgg = true;

  @override
  void initState() {
    context
        .read<RestaurantMenuProvider>()
        .menuDetailsData(mounted, widget.data?.creatorId)
        .whenComplete(() => filterSearchedItems(''));

    super.initState();
  }

  refresh() {
    setState(() {});
  }

  List<Menu> categoriesToShow = <Menu>[];

  void updateCategoriesToShow(List<Menu> value) {
    setState(() {
      categoriesToShow = value;
    });
  }

  isVegFilter() {
    var data =
        context.read<RestaurantMenuProvider>().menuDetails.result?.menu ??
            <Menu>[];

    var tempMenu = <Menu>[];
    if (isVeg && !isEgg) {
      data.forEach((menuHeader) {
        var tempMenus = [...menuHeader.menus];
        tempMenus.retainWhere((product) {
          return product.isVeg;
        });
        if (tempMenus.length > 0) {
          var tempSingleMenu = Menu.fromJson(menuHeader.toJson());
          tempSingleMenu.menus = tempMenus;
          tempMenu.add(tempSingleMenu);
        }
      });
      updateCategoriesToShow(tempMenu);
    } else if (isEgg && !isVeg) {
      data.forEach((menuHeader) {
        var tempMenus = [...menuHeader.menus];
        tempMenus.retainWhere((product) {
          return product.isVeg == false;
        });
        if (tempMenus.length > 0) {
          var tempSingleMenu = Menu.fromJson(menuHeader.toJson());
          tempSingleMenu.menus = tempMenus;
          tempMenu.add(tempSingleMenu);
        }
      });
      updateCategoriesToShow(tempMenu);
    } else if (isVeg && isEgg) {
      updateCategoriesToShow(data);
    } else if (isVeg == false && isEgg == false) {
      updateCategoriesToShow(data);
    }
  }

  filterSearchedItems(String text) {
    var data =
        context.read<RestaurantMenuProvider>().menuDetails.result?.menu ??
            <Menu>[];
    if (text == null || text == "") {
      updateCategoriesToShow(data);
    }

    var tempMenu = <Menu>[];
    data.forEach((menuHeader) {
      if (menuHeader.name.toLowerCase().contains(text.toLowerCase())) {
        tempMenu.add(menuHeader);
      } else {
        var tempMenus = [...menuHeader.menus];
        tempMenus.retainWhere((product) {
          return product.name.toLowerCase().contains(text.toLowerCase());
        });

        if (tempMenus.length > 0) {
          var tempSingleMenu = Menu.fromJson(menuHeader.toJson());
          tempSingleMenu.menus = tempMenus;
          tempMenu.add(tempSingleMenu);
        }
      }
    });
    updateCategoriesToShow(tempMenu);
  }

  @override
  Widget build(BuildContext context) {
    var data = context.watch<RestaurantMenuProvider>().menuDetails;
    var state = context.watch<RestaurantMenuProvider>().state;

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
                        Container(
                          constraints: BoxConstraints(
                              minWidth: 40,
                              maxWidth:
                                  MediaQuery.of(context).size.width / 1.7),
                          child: Text(
                            '${widget.data?.cuisines.join(", ")}',
                            style: const TextStyle(
                                color: Color(0xFF555C64),
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        Text(
                            '${widget.data?.address.serviceArea}, ${widget.data?.address.city}')
                      ],
                    ),
                    Stack(children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return RestaurantDetails(
                              result: data.result,
                              tags: widget.data?.cuisines,
                            );
                          }));
                        },
                        child: Container(
                          width: 130,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    '${data.result?.creator.cover}'),
                                //NetworkImage("${data.result?.creator.cover}"),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.6),
                                    BlendMode.colorBurn),
                              )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                        .translate('About_Restaurant') ??
                                    'About Restaurant',
                                style: ThreeKmTextConstants
                                    .tk14PXPoppinsBlackSemiBold
                                    .copyWith(color: Colors.white),
                              ),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                    ])
                  ],
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.all(10),
              //   height: 170,
              //   // width: 200,
              //   child: ListView.builder(
              //       scrollDirection: Axis.horizontal,
              //       shrinkWrap: true,
              //       itemCount: 3,
              //       itemBuilder: (_, i) {
              //         return Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: DottedBorder(
              //               strokeWidth: 3,
              //               dashPattern: const [8, 4],
              //               color: Colors.primaries[
              //                   Random().nextInt(Colors.primaries.length)],
              //               child: Container(
              //                 padding: const EdgeInsets.all(10),
              //                 width: 200,
              //                 child: const Center(
              //                   child: Text(
              //                     'Get 20% discount Code: HAPPYNOW',
              //                     style: TextStyle(fontSize: 18),
              //                   ),
              //                 ),
              //               )),
              //         );
              //       }),
              // ),
              Container(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 20, left: 15, right: 15),
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  // controller: _firstName,

                  onChanged: (val) {
                    filterSearchedItems(val);
                  },
                  //maxLength: 16,
                  decoration: InputDecoration(
                    hintText: 'What would you like to have ...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    counterText: '',
                    filled: true,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    fillColor: Colors.grey[100],
                    //isDense: true,
                    contentPadding: const EdgeInsets.fromLTRB(10, 13, 10, 13),

                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomCheckBox(
                      backgroundColor: Colors.green[100],
                      size: 6,
                      label: Text(
                        'VEG',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[700]),
                      ),
                      activeColor: Colors.green,
                      onClick: (status) {
                        setState(() {
                          isVeg = status;
                          isVegFilter();
                        });
                      },
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    CustomCheckBox(
                      backgroundColor: Colors.red[100],
                      size: 6,
                      label: Text(
                        'NON-VEG',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[700]),
                      ),
                      activeColor: Colors.red,
                      onClick: (status) {
                        setState(() {
                          isEgg = status;
                          isVegFilter();
                        });
                      },
                    ),
                  ],
                ),
              ),
              state == 'loaded'
                  ? Container(
                      padding: EdgeInsets.only(top: 20, bottom: 140),
                      color: Colors.white,
                      child: Column(children: [
                        //...?data.result?.menu
                        ...categoriesToShow
                            .map((e) => MenuTile(
                                e: e,
                                creatorName: data.result?.creator.businessName,
                                status:
                                    data.result!.creator.restaurant!.status))
                            .toList(),
                        if (categoriesToShow.length == 0)
                          Column(
                            children: [
                              Image(
                                  image: AssetImage(
                                      'assets/shopImg/search-not-found.gif')),
                              Text(
                                'No Food Found',
                                style:
                                    ThreeKmTextConstants.tk14PXLatoGreyRegular,
                              )
                            ],
                          )
                      ]),
                    )
                  : Container(),
            ],
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Container(
            //     padding:
            //         EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            //     margin: EdgeInsets.only(bottom: 10),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(20),
            //         color: Color(0xFF0F0F2D)),
            //     child: Text(
            //       'View Menu',
            //       style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
            //           .copyWith(color: Colors.white),
            //     )),
            ValueListenableBuilder(
                valueListenable: Hive.box('restroCartBox').listenable(),
                builder: (context, Box box, widget) {
                  return box.length > 0
                      ? Container(
                          width: double.infinity,
                          height: 90,
                          color: Color(0xFF0F0F2D),
                          padding: const EdgeInsets.only(
                              left: 20, top: 20, right: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${Hive.box('restroCartBox').values.length} ITEM',
                                    style: ThreeKmTextConstants
                                        .tk12PXPoppinsWhiteRegular,
                                  ),
                                  Wrap(children: [
                                    Text(
                                      '₹${context.read<CartProvider>().getBoxTotal(Hive.box('restroCartBox'))}',
                                      style: ThreeKmTextConstants
                                          .tk16PXPoppinsBlackMedium
                                          .copyWith(color: Colors.white),
                                    ),
                                    Text('  '),
                                    Text(
                                      '+ TAXES',
                                      style: ThreeKmTextConstants
                                          .tk12PXPoppinsBlackSemiBold
                                          .copyWith(
                                        color: Color(0xFF979EA4),
                                      ),
                                    )
                                  ])
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  viewCart(context, 'restro');
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Color(0xFF3E7EFF),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'View Cart',
                                        style: ThreeKmTextConstants
                                            .tk16PXPoppinsBlackMedium
                                            .copyWith(color: Colors.white),
                                      ),
                                      const Image(
                                        image: AssetImage(
                                            'assets/shopImg/leftArrow.png'),
                                        width: 30,
                                        height: 30,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container();
                }),
          ],
        ));
  }
}

class MenuTile extends StatelessWidget {
  const MenuTile(
      {Key? key,
      required this.e,
      required this.creatorName,
      required this.status})
      : super(key: key);
  final Menu e;
  final String? creatorName;
  final bool? status;

  isProductExist(box, id) {
    var existingItem =
        box.values.toList().firstWhere((dd) => dd.id == id, orElse: () => null);
    return existingItem;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        '${e.name}(${e.menus.length})',
        style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold,
      ),
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
                              border: Border.all(
                                  color: status != false
                                      ? menu.isVeg
                                          ? Colors.green
                                          : Colors.red
                                      : Colors.grey,
                                  width: 2)),
                          width: 20,
                          height: 20,
                          child: Container(
                            decoration: BoxDecoration(
                                color: status != false
                                    ? menu.isVeg
                                        ? Colors.green
                                        : Colors.red
                                    : Colors.grey,
                                shape: BoxShape.circle),
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width / 1.6),
                          child: Text(
                            menu.name,
                            style:
                                ThreeKmTextConstants.tk14PXPoppinsBlackMedium,
                          ),
                        ),
                        Text(
                          '₹${menu.price}',
                          style: ThreeKmTextConstants.tk14PXLatoBlackMedium
                              .copyWith(height: 2),
                        ),
                      ],
                    ),
                    ValueListenableBuilder(
                        valueListenable: Hive.box('restroCartBox').listenable(),
                        builder: (context, Box<dynamic> box, Widget? child) {
                          return isProductExist(box, menu.menuId) == null
                              ? InkWell(
                                  onTap: () {
                                    if (status != false) {
                                      context
                                          .read<CartProvider>()
                                          .addItemToRestroCart(
                                              context: context,
                                              creatorId: menu.creatorId,
                                              image: menu.image,
                                              name: menu.name,
                                              price: menu.displayPrice,
                                              quantity: 1,
                                              id: menu.menuId,
                                              variationId: 0,
                                              weight: menu.weight,
                                              creatorName: creatorName);
                                    } else {
                                      CustomSnackBar(
                                          navigatorKey.currentContext!,
                                          Text(
                                              "Restaurant is currently not Accepting Order"));
                                    }
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Color(0xFFF4F3F8)),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        'ADD +',
                                        style: ThreeKmTextConstants
                                            .tk14PXLatoBlackBold
                                            .copyWith(
                                          color: status != false
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                      )),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.green),
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    //mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (isProductExist(box, menu.menuId)
                                                  .quantity <
                                              2) {
                                            isProductExist(box, menu.menuId)
                                                .delete();
                                          }
                                          if (isProductExist(
                                                  box, menu.menuId) !=
                                              null) {
                                            isProductExist(box, menu.menuId)
                                                    .quantity =
                                                isProductExist(box, menu.menuId)
                                                        .quantity -
                                                    1;

                                            if (isProductExist(box, menu.menuId)
                                                .isInBox) {
                                              isProductExist(box, menu.menuId)
                                                  .save();
                                            }
                                          }
                                        },
                                        child: const Image(
                                          image: AssetImage(
                                              'assets/shopImg/del.png'),
                                          width: 50,
                                          height: 20,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: Text(
                                          '${isProductExist(box, menu.menuId).quantity}',
                                          style: ThreeKmTextConstants
                                              .tk12PXPoppinsBlackSemiBold
                                              .copyWith(color: Colors.black),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          isProductExist(box, menu.menuId)
                                                  .quantity =
                                              isProductExist(box, menu.menuId)
                                                      .quantity +
                                                  1;
                                          isProductExist(box, menu.menuId)
                                              .save();
                                        },
                                        child: const Image(
                                          image: AssetImage(
                                              'assets/shopImg/add.png'),
                                          width: 50,
                                          height: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        })
                  ],
                ),
              );
            })
      ],
    );
  }
}
