import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:threekm/Models/shopModel/all_category_model.dart';
import 'package:threekm/localization/localize.dart';
import '../shop/product_listing.dart';

class SubCategoryList extends StatelessWidget {
  const SubCategoryList({
    Key? key,
    required this.data,
  }) : super(key: key);

  final List<Childs>? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          AppLocalizations.of(context)!.translate('SUBCATEGORIES') ??
              'SUBCATEGORIES',
        ),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        actions: [
          Stack(
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                      color: Colors.grey[200], shape: BoxShape.circle),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.shopping_cart_rounded,
                        size: 30,
                      ))),
              ValueListenableBuilder(
                  valueListenable: Hive.box('cartBox').listenable(),
                  builder: (context, Box box, snapshot) {
                    return Positioned(
                        top: 0,
                        right: 6,
                        child: box.length != 0
                            ? Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    '${box.length}',
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.white),
                                  ),
                                ))
                            : Container());
                  }),
            ],
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: data!.length,
          itemBuilder: (context, i) {
            return ListTile(
              onTap: () {
                print('${data?[i].name}///////////////');
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (context, animaton, secondaryAnimation) {
                          return ProductListing(
                            query: '${data?[i].name}',
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 800),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          animation = CurvedAnimation(
                              parent: animation, curve: Curves.easeInOut);
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        }));
              },
              minVerticalPadding: 30.0,
              dense: true,
              leading: Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                    color: Color(0xFFF4F3F8), shape: BoxShape.circle),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
              title: Text(
                '${data?[i].name}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            );
          },
          separatorBuilder: (_, __) => const Divider(),
        ),
      ),
    );
  }
}
