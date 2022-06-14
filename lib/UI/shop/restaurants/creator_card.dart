import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:threekm/Models/shopModel/restaurants_model.dart';
import 'package:threekm/UI/shop/restaurants/restaurants_menu.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/localization/localize.dart';
import 'package:threekm/main.dart';

class CreatorCard extends StatelessWidget {
  const CreatorCard({
    Key? key,
    required this.data,
    this.SearchController,
  }) : super(key: key);

  final data;
  final TextEditingController? SearchController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.only(bottom: 100),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: data?.creators?.length,
        itemBuilder: (_, i) {
          return InkWell(
            onTap: () {
              if (data?.creators?[i].restaurant?.status == false) {
                CustomSnackBar(
                    navigatorKey.currentContext!,
                    Text(AppLocalizations.of(context)!
                            .translate('Restaurant_offline') ??
                        "Restaurant is Currentlly not accepting orders"));
              }
              FocusScope.of(context).unfocus();
              SearchController?.clear();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => RestaurantMenu(
                            data: data!.creators![i],
                          )));
            },
            child: Container(
              // padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFFE2E4E6))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                data?.creators?[i].restaurant?.status != false
                                    ? Colors.transparent
                                    : Colors.grey,
                                BlendMode.color),
                            child: CachedNetworkImage(
                              alignment: Alignment.topCenter,
                              //placeholder: (context, url) =>
                              //     Transform.scale(
                              //   scale: 0.5,
                              //   child: CircularProgressIndicator(
                              //     color: Colors.grey[400],
                              //   ),
                              // ),
                              imageUrl: '${data?.creators?[i].cover}',
                              //height: MediaQuery.of(context).size.height / 5,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     Container(
                        //       padding: EdgeInsets.all(10),
                        //       margin: EdgeInsets.all(10),
                        //       decoration: BoxDecoration(
                        //           borderRadius:
                        //               BorderRadius.circular(15),
                        //           color: Colors.white),
                        //       child: const Text(
                        //         'Best Safety',
                        //         style: TextStyle(
                        //             color: Color(0xFF3E7EFF)),
                        //       ),
                        //     ),
                        //     Container(
                        //       padding: EdgeInsets.all(10),
                        //       margin: EdgeInsets.all(10),
                        //       decoration: BoxDecoration(
                        //           borderRadius:
                        //               BorderRadius.circular(15),
                        //           gradient: const LinearGradient(
                        //               colors: [
                        //                 Color(0xFFFF5C3D),
                        //                 Color(0xFFFF2A5F)
                        //               ])),
                        //       child: const Text(
                        //         '50% off',
                        //         style: TextStyle(color: Colors.white),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${data?.creators?[i].businessName}',
                      style: const TextStyle(
                          fontSize: 17,
                          color: Color(0xFF0F0F2D),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.9,
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '${data?.creators?[i].restaurant!.cuisines?.join(", ")}',
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7572ED),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (data?.creators?[i].address?.serviceArea != null)
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                              '${data?.creators?[i].address?.serviceArea}'),
                        )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
