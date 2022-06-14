import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/UI/shop/restaurants/creator_card.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/providers/shop/shop_home_provider.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class BiryaniRestro extends StatefulWidget {
  const BiryaniRestro({Key? key}) : super(key: key);

  @override
  State<BiryaniRestro> createState() => _BiryaniRestroState();
}

class _BiryaniRestroState extends State<BiryaniRestro> {
  @override
  void initState() {
    Future.microtask(
        () => context.read<ShopHomeProvider>().BiryaniRestro(mounted));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = context.watch<ShopHomeProvider>().biryaniRestroData?.result;
    var state = context.watch<ShopHomeProvider>().state;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Biryani Fest',
          style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl:
                  "https://bakdocdn.sgp1.cdn.digitaloceanspaces.com/general/0/ad38e580-eada-11ec-838e-bd9a9b233f78.png",
              height: 200,
              // fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                'Restaurants',
                style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium,
              ),
            ),
            state == 'loaded' ? CreatorCard(data: data) : ShowRestroLoading()
          ],
        ),
      ),
    );
  }
}
