import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/UI/main/Profile/MyProfilePost.dart';
import 'package:threekm/UI/main/Profile/Profilepage.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/UI/shop/cart/cart_item_list_modal.dart';
import 'package:threekm/UI/shop/cart/wishlist.dart';
import 'package:threekm/UI/walkthrough/splash_screen.dart';
import 'package:threekm/providers/ProfileInfo/ProfileInfo_Provider.dart';
import 'package:threekm/providers/main/AthorProfile_Provider.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/utils/util_methods.dart';
import 'package:threekm/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../Help_Supportpage.dart';

class DrawerScreen extends StatefulWidget {
  final String userName;
  final String avatar;
  DrawerScreen({required this.avatar, required this.userName, Key? key})
      : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  void initState() {
    //context.read<AutthorProfileProvider>().getAuthorProfile();
    Future.delayed(Duration.zero, () {
      context.read<AutthorProfileProvider>().getSelfProfile();
    });
    getWishBoxData();
    super.initState();
  }

  getWishBoxData() async {
    await Hive.openBox('shopWishListBox');
  }

  @override
  Widget build(BuildContext context) {
    //final authorPostProvider = context.watch<AutthorProfileProvider>();
    //final selfProfileProvider = context.watch<AutthorProfileProvider>();
    return Scaffold(
      body:
          // RotatedBox(
          //   quarterTurns: 1,
          //   child:
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Color(0xff645AFF), Color(0xffA573FF)],
              )),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 19),
                    child: CustomDrawer(
                        iconUrl: widget.avatar,
                        // selfProfileProvider
                        //     .selfProfile!.data.result.author.image,
                        //"https://www.pngall.com/wp-content/uploads/12/Avatar-Profile-Vector-PNG-File.png",
                        name: widget.userName //"Raviraj"
                        ),
                  ),
                  Positioned(
                    bottom: 45,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                color: Colors.white,
                                onPressed: () => drawerController.close!(),
                                icon: Icon(
                                  Icons.cancel_rounded,
                                  size: 55,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
      //),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  final AnimationController? animationController2;
  final String iconUrl;
  final String name;

  CustomDrawer(
      {this.animationController2, required this.iconUrl, required this.name});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> logout() async {
    bool navigate = await showDialog(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            actionsPadding: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              "Logout",
              style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
                  .copyWith(fontSize: 20),
            ),
            content: Text(
              "Are you sure you want to logout?, you'll be unable to use specific features.",
              style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
                  .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            actions: [
              CustomButton(
                color: ThreeKmTextConstants.red1,
                onTap: () async {
                  Navigator.of(context).pop(false);
                },
                width: 100,
                height: 40,
                borderRadius: BorderRadius.circular(5),
                child: Text(
                  "Cancel",
                  style: ThreeKmTextConstants.tk14PXWorkSansWhiteMedium,
                ),
              ),
              CustomButton(
                color: ThreeKmTextConstants.blue1,
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop(true);
                },
                width: 100,
                height: 40,
                borderRadius: BorderRadius.circular(5),
                child: Text(
                  "Logout",
                  style: ThreeKmTextConstants.tk14PXWorkSansWhiteMedium,
                ),
              ),
            ],
          );
        });
    return navigate;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDrawerHeader(
          image: widget.iconUrl,
          name: widget.name,
        ),

        DrawerDivider(),
        GestureDetector(
          onTap: () {
            // var _ = Get.put(MyPostController());
            // Navigator.of(context).pushNamed(MyPost.path);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyProfilePost(
                        isFromSelfProfileNavigate: true,
                        page: 1,
                        authorType: "user",
                        id: 2,
                        avatar: widget.iconUrl,
                        userName: widget.name)));
          },
          child: CustomDrawerItem(
            image: "assets/feed.png",
            label: "My Post".toUpperCase(),
          ),
        ),
        // SizedBox(
        //   height: 24,
        // ),
        // InkWell(
        //   // onTap: () => Navigator.of(context).pushNamed(SavedPost.path),
        //   child: CustomDrawerItem(
        //     icon: Icons.bookmark_outline_rounded,
        //     label: "Saved Post".toUpperCase(),
        //   ),
        // ),
        DrawerDivider(),
        CustomDrawerItem(
          icon: Icons.shopping_cart_outlined,
          label: "Shopping Cart".toUpperCase(),
        ).onTap(() {
          viewCart(context, "shop");
          // widget.animationController2!
          //     .reverse()
          //     .then((value) => viewCart(context, "shop"));
        }),
        SizedBox(
          height: 24,
        ),
        InkWell(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => WishList())),
          child: CustomDrawerItem(
            icon: CupertinoIcons.heart,
            label: "Wishlist".toUpperCase(),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        CustomDrawerItem(
          image: "assets/inventory.png",
          label: "Past Orders".toUpperCase(),
        ),
        SizedBox(
          height: 24,
        ),
        InkWell(
          onTap: () async {
            // var accepted = await getLocationPermission();
            // if (!accepted) {
            //   // dynamic openAddressPage =
            //   //     await Navigator.of(context).pushNamed(LocationBasePage.path);
            //   if (openAddressPage != null && openAddressPage == true) {
            //    // Navigator.of(context).pushNamed(LocationBasePage.path);
            //   }
            // } else {
            //   //Navigator.of(context).pushNamed(LocationBasePage.path);
            // }
          },
          child: CustomDrawerItem(
            icon: Icons.place_outlined,
            label: "Saved Addresses".toUpperCase(),
          ),
        ),
        DrawerDivider(),
        InkWell(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HelpAndSupport())),
          child: CustomDrawerItem(
            icon: Icons.contact_support_outlined,
            label: "Help and Support".toUpperCase(),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        CustomDrawerItem(
          icon: Icons.g_translate_outlined,
          label: "Change language".toUpperCase(),
        ).onTap(() {
          // Navigator.of(context)
          //     .pushNamedAndRemoveUntil(SelectLanguage.path, (route) => false);
        }),
        SizedBox(
          height: 24,
        ),
        InkWell(
          onTap: () async {
            bool log = await logout();
            print("$log");
            if (log) {
              var prefs = await SharedPreferences.getInstance();
              prefs.clear();
              //widget.animationController2!.reverse();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                  (route) => false);
            }
          },
          child: CustomDrawerItem(
            icon: Icons.logout,
            label: "Logout".toUpperCase(),
          ),
        ),
      ],
    ));
  }
}

class CustomDrawerHeader extends StatelessWidget {
  final String image;
  final String name;
  CustomDrawerHeader({required this.image, required this.name});
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileInfoProvider>(builder: (context, controller, _) {
      return Container(
        margin: EdgeInsets.only(top: 67),
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: controller.Avatar != null
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(controller.Avatar!))
                      : DecorationImage(
                          image: AssetImage("assets/avatar.png"),
                        ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                    Text(
                      "My Profile",
                      style: ThreeKmTextConstants.tk12PXPoppinsWhiteRegular
                          .copyWith(
                        color: Color(0xFFD5D5D5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class CustomDrawerItem extends StatelessWidget {
  final String? image;
  final String label;
  final IconData? icon;
  CustomDrawerItem({this.image, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        image != null
            ? Image.asset("$image", height: 24, width: 24)
            : Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
        SizedBox(
          width: 16,
        ),
        Text(
          label,
          style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold
              .copyWith(fontWeight: FontWeight.normal, fontSize: 14),
        ),
      ],
    );
  }
}

class DrawerDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 17),
      width: MediaQuery.of(context).size.width * 0.65,
      child: Divider(
        thickness: 0.5,
        color: Colors.white.withOpacity(0.8),
      ),
    );
  }
}
