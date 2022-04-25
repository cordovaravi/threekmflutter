import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/UI/shop/cart/cart_item_list_modal.dart';
import 'package:threekm/localization/localize.dart';
import 'package:threekm/providers/shop/all_category_provider.dart';
import 'package:threekm/Models/shopModel/all_category_model.dart';
import '../shop/sub_categorylist.dart';

class AllCategoryList extends StatefulWidget {
  const AllCategoryList({Key? key}) : super(key: key);

  @override
  State<AllCategoryList> createState() => _AllCategoryListState();
}

class _AllCategoryListState extends State<AllCategoryList> {
  @override
  void initState() {
    context.read<AllCategoryListProvider>().getAllCategory(mounted);
    super.initState();
  }

  @override
  void dispose() {
    context.read<AllCategoryListProvider>().oncleardata();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allCategoryProvider = context.watch<AllCategoryListProvider>();
    final data = allCategoryProvider.allCategoryListData.data?.result;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            AppLocalizations.of(context)!.translate('all_cat_text') ??
                'ALL CATEGORIES',
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
                        onPressed: () {
                          viewCart(context, 'shop');
                        },
                        icon: const Icon(
                          Icons.shopping_cart_rounded,
                          size: 28,
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
                                      shape: BoxShape.circle,
                                      color: Colors.red),
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
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return context
              .read<AllCategoryListProvider>()
              .getAllCategory(mounted);
        },
        child: Builder(builder: (context) {
          if (allCategoryProvider.state == 'loading') {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (allCategoryProvider.state == "error") {
            context.read<AllCategoryListProvider>().getAllCategory(mounted);
            return const Center(
              child: Text("error"),
            );
          } else if (allCategoryProvider.state == "loaded") {
            return allCategoryProvider.allCategoryListData != null
                ? AllCategoryWidget(
                    data: data,
                    // setsubcat: setSubCategory,
                  )
                : const Text("null");
          }
          return Container();
        }),
      ),
    );
  }
}

class AllCategoryWidget extends StatefulWidget {
  const AllCategoryWidget({
    Key? key,
    this.data,
    // required this.setsubcat
  }) : super(key: key);
  final List<Result>? data;
  // final void Function(List<Childs>?, bool) setsubcat;

  @override
  State<AllCategoryWidget> createState() => _AllCategoryWidgetState();
}

class _AllCategoryWidgetState extends State<AllCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: widget.data!.length,
        itemBuilder: (context, i) {
          return ListTile(
            onTap: () {
              print('${widget.data?[i].childs}===');
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animaton, secondaryAnimation) {
                        return SubCategoryList(data: widget.data?[i].childs);
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
                      })).whenComplete(() => setState(() {}));
              // SubCategoryList(data: _subCategoryData)
              // subCategoryData =data?[i].childs;
              // widget.setsubcat(widget.data?[i].childs, true);
            },
            // minVerticalPadding: 30.0,
            contentPadding: EdgeInsets.all(20),
            dense: true,
            leading: Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                  color: Color(0xFFF4F3F8), shape: BoxShape.circle),
            ),
            trailing: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.black,
            ),
            title: Text(
              '${widget.data?[i].name}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          );
        },
        separatorBuilder: (_, __) => const Divider(),
      ),
    );
  }
}
