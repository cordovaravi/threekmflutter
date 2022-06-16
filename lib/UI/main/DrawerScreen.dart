import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/UI/main/AddPost/AddNewPost.dart';
import 'package:threekm/UI/main/Profile/MyProfilePost.dart';
import 'package:threekm/UI/main/Profile/Profilepage.dart';
import 'package:threekm/UI/shop/address/saved_address.dart';
import 'package:threekm/UI/shop/cart/cart_item_list_modal.dart';
import 'package:threekm/UI/shop/cart/wishlist.dart';
import 'package:threekm/UI/shop/checkout/past_order.dart';
import 'package:threekm/UI/walkthrough/splash_screen.dart';
import 'package:threekm/localization/localize.dart';
import 'package:threekm/providers/ProfileInfo/ProfileInfo_Provider.dart';
import 'package:threekm/providers/main/AthorProfile_Provider.dart';
import 'package:threekm/utils/screen_util.dart';
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
    //getWishBoxData();
    Future.microtask(
        () => context.read<ProfileInfoProvider>().getProfileBasicData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final authorPostProvider = context.watch<AutthorProfileProvider>();
    //final selfProfileProvider = context.watch<AutthorProfileProvider>();
    final ProfileData = context.watch<ProfileInfoProvider>();
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 19),
                child: CustomDrawer(
                    iconUrl: ProfileData.Avatar ?? widget.avatar,
                    // selfProfileProvider
                    //     .selfProfile!.data.result.author.image,
                    //"https://www.pngall.com/wp-content/uploads/12/Avatar-Profile-Vector-PNG-File.png",
                    name: ProfileData.UserName ?? widget.userName //"Raviraj"
                    ),
              ),
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
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            actionsPadding: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              AppLocalizations.of(context)?.translate("profile_logout_text") ??
                  "",
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
                  context.read<ProfileInfoProvider>().resetAll();
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  await _prefs.remove("gender");
                  await _prefs.remove("dob");
                  await _prefs.clear();

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
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomDrawerHeader(
              image: widget.iconUrl,
              name: widget.name,
            ),
            DrawerDivider(),
            InkWell(
              onTap: () {
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
                label: AppLocalizations.of(context)
                        ?.translate("my_post")
                        ?.toUpperCase() ??
                    "",
              ),
            ),
            SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: () {
                //context.read<AddPostProvider>().deletImages();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            //VideoCompress()
                            AddNewPost()));
              },
              child: CustomDrawerItem(
                icon: Icons.add,
                label: AppLocalizations.of(context)
                        ?.translate("add_post")
                        ?.toUpperCase() ??
                    "",
              ),
            ),
            DrawerDivider(),
            CustomDrawerItem(
              icon: Icons.shopping_cart_outlined,
              label: AppLocalizations.of(context)
                      ?.translate("shopping_cart")
                      ?.toUpperCase() ??
                  "",
            ).onTap(() {
              Future.microtask(() => ThreeKmScreenUtil().init(context))
                  .then((value) => viewCart(context, "shop"));
            }),
            SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => WishList())),
              child: CustomDrawerItem(
                icon: CupertinoIcons.heart,
                label: AppLocalizations.of(context)
                        ?.translate("profile_wishlist_text")
                        ?.toUpperCase() ??
                    "",
              ),
            ),
            SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => PastOrder())),
              child: CustomDrawerItem(
                image: "assets/inventory.png",
                label: AppLocalizations.of(context)
                        ?.translate("Orders")
                        ?.toUpperCase() ??
                    "",
              ),
            ),
            SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: () {
                Future.microtask(() => ThreeKmScreenUtil().init(context)).then(
                    (value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SavedAddress())));
              },
              child: CustomDrawerItem(
                icon: Icons.place_outlined,
                label: AppLocalizations.of(context)
                        ?.translate("profile_addresses_desc")
                        ?.toUpperCase() ??
                    "",
              ),
            ),
            DrawerDivider(),
            InkWell(
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HelpAndSupport())),
              child: CustomDrawerItem(
                icon: Icons.contact_support_outlined,
                label: AppLocalizations.of(context)
                        ?.translate("profile_help_support")
                        ?.toUpperCase() ??
                    "",
              ),
            ),
            // SizedBox(
            //   height: 24,
            // ),
            // CustomDrawerItem(
            //   icon: Icons.g_translate_outlined,
            //   label: AppLocalizations.of(context)
            //           ?.translate("profile_change_language")
            //           ?.toUpperCase() ??
            //       "",
            // ).onTap(() {
            //   Navigator.pushAndRemoveUntil(
            //       context,
            //       MaterialPageRoute(builder: (context) => SelectLanguage()),
            //       (route) => false);
            // }),
            SizedBox(
              height: 24,
            ),
            CustomDrawerItem(
              icon: Icons.policy,
              label: AppLocalizations.of(context)
                      ?.translate("privacy_policy")
                      ?.toUpperCase() ??
                  "",
            ).onTap(() {
              InAppBrowser.openWithSystemBrowser(
                  url: Uri.parse("https://bulbandkey.com/privacy-policy"));
            }),
            SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: () async {
                bool log = await logout();
                print("$log");
                if (log) {
                  FirebaseAuth.instance.signOut();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                      (route) => false);
                }
              },
              child: CustomDrawerItem(
                icon: Icons.logout,
                label: AppLocalizations.of(context)
                        ?.translate("logout")
                        ?.toUpperCase() ??
                    "",
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Text("version: 5.1.2"),
            SizedBox(
              height: 15,
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
        // color: Colors.amber,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 20),
        child: Column(
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
              // margin: EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()));
                    },
                    child: Container(
                      width: 142,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        "Edit Profile",
                        // AppLocalizations.of(context)
                        //         ?.translate("profile_header_name") ??
                        //     "",
                        style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold
                            .copyWith(
                          color: Color(0xFFD5D5D5),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
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
            ? Image.asset(
                "$image",
                height: 24,
                width: 24,
                color: Colors.black,
              )
            : Icon(
                icon,
                color: Colors.black,
                size: 24,
              ),
        SizedBox(
          width: 16,
        ),
        Text(
          label,
          style: ThreeKmTextConstants.tk16PXLatoBlackRegular
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
      width: MediaQuery.of(context).size.width * 0.9,
      child: Divider(
        thickness: 0.5,
        color: Colors.black.withOpacity(0.8),
      ),
    );
  }
}
