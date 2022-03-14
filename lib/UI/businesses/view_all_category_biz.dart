import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threekm/UI/Search/SearchPage.dart';
import 'package:threekm/UI/businesses/businesses_detail.dart';
import 'package:threekm/providers/Search/Search_Provider.dart';

class ViewAllBiz extends StatefulWidget {
  final String query;
  const ViewAllBiz({Key? key, required this.query}) : super(key: key);

  @override
  State<ViewAllBiz> createState() => _ViewAllBizState();
}

class _ViewAllBizState extends State<ViewAllBiz> {
  @override
  void initState() {
    context.read<SearchBarProvider>().getBusinessSearch(query: widget.query);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.query),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Consumer<SearchBarProvider>(builder: (context, controller, _) {
        return controller.BusinessSearchData?.data?.result?.creators?.length !=
                null
            ? controller.isbusinnessLoading
                ? CupertinoActivityIndicator()
                : controller.BusinessSearchData!.data!.result!.creators!
                            .length >
                        0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: controller
                            .BusinessSearchData!.data!.result!.creators!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BusinessDetail(
                                          id: controller
                                              .BusinessSearchData!
                                              .data!
                                              .result!
                                              .creators![index]
                                              .creatorId)));
                            },
                            child: BizCategoryCardSearch(
                                image: controller.BusinessSearchData!.data!
                                    .result!.creators![index].image
                                    .toString(),
                                name: controller.BusinessSearchData!.data!
                                    .result!.creators![index].businessName
                                    .toString(),
                                tags: controller
                                            .BusinessSearchData!
                                            .data!
                                            .result!
                                            .creators![index]
                                            .tags
                                            ?.length !=
                                        0
                                    ? "${controller.BusinessSearchData!.data!.result!.creators![index].tags?.first.toString()},  ${controller.BusinessSearchData!.data!.result!.creators![index].tags?.last.toString()}"
                                    : "",
                                ownername:
                                    "${controller.BusinessSearchData!.data!.result!.creators![index].firstname} ${controller.BusinessSearchData!.data!.result!.creators![index].lastname}",
                                id: controller.BusinessSearchData!.data!.result!
                                    .creators![index].creatorId!
                                    .toInt()),
                          );
                        })
                    : Center(
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image(
                            image: AssetImage(
                                'assets/BusinessesImg/nodataFound.gif'),
                            width: MediaQuery.of(context).size.width,
                          ),
                          Text(
                            'No Data Found ...',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ))
            : Container();
      }),
    );
  }
}
