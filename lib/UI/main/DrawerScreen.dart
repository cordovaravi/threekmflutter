import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/UI/main/News/NewsList.dart';
import 'package:threekm/UI/main/Profile/MyProfilePost.dart';
import 'package:threekm/UI/main/Profile/Profilepage.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/UI/shop/address/saved_address.dart';
import 'package:threekm/UI/shop/cart/cart_item_list_modal.dart';
import 'package:threekm/UI/shop/cart/wishlist.dart';
import 'package:threekm/UI/shop/checkout/past_order.dart';
import 'package:threekm/UI/walkthrough/splash_screen.dart';
import 'package:threekm/providers/ProfileInfo/ProfileInfo_Provider.dart';
import 'package:threekm/providers/main/AddPost_Provider.dart';
import 'package:threekm/providers/main/AthorProfile_Provider.dart';
import 'package:threekm/utils/screen_util.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/utils/util_methods.dart';
import 'package:threekm/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../Help_Supportpage.dart';
import 'AddPost/ImageEdit/editImage.dart';

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
    Future.microtask(
        () => context.read<ProfileInfoProvider>().getProfileBasicData());
    super.initState();
  }

  getWishBoxData() async {
    await Hive.openBox('shopWishListBox');
    await Hive.openBox('businessWishListBox');
  }

  @override
  Widget build(BuildContext context) {
    //final authorPostProvider = context.watch<AutthorProfileProvider>();
    //final selfProfileProvider = context.watch<AutthorProfileProvider>();
    final ProfileData = context.watch<ProfileInfoProvider>();
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
                        iconUrl: ProfileData.Avatar ?? widget.avatar,
                        // selfProfileProvider
                        //     .selfProfile!.data.result.author.image,
                        //"https://www.pngall.com/wp-content/uploads/12/Avatar-Profile-Vector-PNG-File.png",
                        name:
                            ProfileData.UserName ?? widget.userName //"Raviraj"
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
  final ImagePicker _imagePicker = ImagePicker();

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
        SizedBox(
          height: 24,
        ),
        InkWell(
          onTap: () {
            context.read<AddPostProvider>().deletImages();
            _showImageVideoBottomModalSheet(context);
          },
          child: CustomDrawerItem(
            icon: Icons.add,
            label: "Add Post".toUpperCase(),
          ),
        ),
        DrawerDivider(),
        CustomDrawerItem(
          icon: Icons.shopping_cart_outlined,
          label: "Shopping Cart".toUpperCase(),
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
            label: "Wishlist".toUpperCase(),
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
            label: "Past Orders".toUpperCase(),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        InkWell(
          onTap: () {
            Future.microtask(() => ThreeKmScreenUtil().init(context)).then(
                (value) => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SavedAddress())));
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
        CustomDrawerItem(
          icon: Icons.policy,
          label: "Privacy Policy".toUpperCase(),
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
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
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

  _showImageVideoBottomModalSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return ClipPath(
                clipper: OvalTopBorderClipper(),
                child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height / 4,
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          List<XFile>? imageFileList = [];
                          final List<XFile>? images =
                              await _imagePicker.pickMultiImage();
                          if (imageFileList.isEmpty) {
                            imageFileList.addAll(images!);
                          }
                          imageFileList.forEach((element) {
                            print(element.name);
                            print(element.path);
                          });

                          if (imageFileList != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditImage(images: imageFileList)));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Color(0xff0F0F2D),
                              )),
                          child: ListTile(
                            leading: Image.asset(
                              "assets/camera.png",
                              color: Color(0xff0F0F2D),
                            ),
                            title: Text(
                              "Upload Image via Gallery",
                              style: ThreeKmTextConstants.tk14PXLatoBlackBold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          final pickedVideo = await _imagePicker.pickVideo(
                              source: ImageSource.gallery);
                          //final file = XFile(pickedVideo!.path);
                          Navigator.pop(context);
                          if (pickedVideo != null) {
                            // context
                            //     .read<AddPostProvider>()
                            //     .addImages(File(pickedVideo.path));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditImage(
                                        images: [XFile(pickedVideo.path)])));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Color(0xff0F0F2D),
                              )),
                          child: ListTile(
                            leading: Image.asset(
                              "assets/videocam.png",
                              color: Color(0xff0F0F2D),
                            ),
                            title: Text(
                              "Upload Video via Gallery",
                              style: ThreeKmTextConstants.tk14PXLatoBlackBold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
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
