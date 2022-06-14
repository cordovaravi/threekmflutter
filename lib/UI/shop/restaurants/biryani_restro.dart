import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:threekm/UI/shop/restaurants/creator_card.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/providers/shop/shop_home_provider.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class BiryaniRestro extends StatefulWidget {
  const BiryaniRestro({Key? key}) : super(key: key);

  @override
  State<BiryaniRestro> createState() => _BiryaniRestroState();
}

class _BiryaniRestroState extends State<BiryaniRestro> {
  @override
  void initState() {
    Future.delayed(Duration.zero,
        () => context.read<ShopHomeProvider>().BiryaniRestro(mounted));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ShopHomeProvider>();
    var data = provider.biryaniRestroData?.result;
    var state = provider.state;
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
              imageUrl: "${data?.banner.first}",
              height: 200,
              errorWidget: (context, url, error) => Container(
                color: Color(0xFFf2f2f2),
                height: 200,
                width: MediaQuery.of(context).size.width,
              ),
              // fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                'Restaurants',
                style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium,
              ),
            ),
            state == 'loaded' && data != null
                ? CreatorCard(data: data)
                : ShowRestroLoading()
          ],
        ),
      ),
    );
  }
}
