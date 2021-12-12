// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:threekm/models/cart_controller.dart';
// import 'package:threekm/setup/model/cart.dart';
// import 'package:threekm/utils/utils.dart';

// class CartPopUp extends StatefulWidget {
//   const CartPopUp({Key? key}) : super(key: key);

//   @override
//   _CartPopUpState createState() => _CartPopUpState();
// }

// class _CartPopUpState extends State<CartPopUp> {
//   @override
//   void initState() {
//     super.initState();
//     Get.put(CartController());
//   }

//   @override
//   void dispose() {
//     Get.delete<CartController>();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF0F0F2D).withOpacity(0.75),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               Spacer(),
//               Container(
//                 alignment: Alignment.bottomCenter,
//                 width: double.infinity,
//                 height: MediaQuery.of(context).size.height - 269,
//                 decoration: BoxDecoration(color: Colors.white),
//                 child: Column(
//                   children: [
//                     space(height: 40),
//                     buildSummary(),
//                     space(height: 17),
//                     buildDivider(),
//                     Expanded(
//                       child: GetBuilder<CartController>(
//                         builder: (_controller) => ListView.builder(
//                           padding: EdgeInsets.only(top: 23),
//                           itemBuilder: (context, _index) {
//                             Cart item = _controller.cartItems[_index];
//                             return buildCartItem(item, _controller);
//                           },
//                           itemCount: _controller.cartItems.length,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 36,
//                       width: 237,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(18),
//                         color: Color(0xFF3E7EFF),
//                         boxShadow: [
//                           BoxShadow(
//                             offset: Offset(0, 10),
//                             blurRadius: 50,
//                             color: Color(0xFFFFF),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.shopping_cart,
//                             color: Colors.white,
//                             size: 18,
//                           ),
//                           space(width: 12),
//                           Text(
//                             "Proceed to Checkout",
//                             style: GoogleFonts.poppins(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     space(height: 34),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           buildCloseButton(context),
//         ],
//       ),
//     );
//   }

//   Stack buildCartItem(Cart item, CartController controller) {
//     return Stack(
//       children: [
//         Container(
//           padding: EdgeInsets.only(top: 12),
//           margin: EdgeInsets.only(bottom: 56),
//           child: Row(
//             children: [
//               Container(
//                 height: 45,
//                 width: 60,
//                 margin: EdgeInsets.only(left: 19),
//                 clipBehavior: Clip.antiAlias,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(7),
//                   color: ThreeKmTextConstants.lightBlue,
//                 ),
//                 child: CachedNetworkImage(
//                   imageUrl: item.data!["image"],
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   padding: EdgeInsets.only(
//                     left: 8,
//                     right: 16,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "${item.data!['name']}",
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF232629),
//                         ),
//                       ),
//                       space(height: 4),
//                       Text(
//                         "\u20b9${item.data!['price']}.00",
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF3E7EFF),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(right: 19),
//                 padding: EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   color: Color(0xFFF4F3F8),
//                 ),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () => controller.reduceAmount(item),
//                       child: Icon(
//                         Icons.remove,
//                         size: 20,
//                         color: Colors.blueGrey,
//                       ),
//                     ),
//                     space(width: 8),
//                     Text(
//                       "${item.amount!}",
//                       style: GoogleFonts.poppins(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF232629),
//                       ),
//                     ),
//                     space(width: 8),
//                     GestureDetector(
//                       onTap: () => controller.addAmount(item),
//                       child: Icon(
//                         Icons.add,
//                         size: 20,
//                         color: Colors.blueGrey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Positioned(
//           top: 2,
//           left: 8,
//           child: Container(
//               padding: EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.red,
//               ),
//               child: GestureDetector(
//                 onTap: () => controller.deleteItem(item),
//                 child: Icon(
//                   Icons.close,
//                   color: Colors.white,
//                   size: 14,
//                 ),
//               )),
//         ),
//       ],
//     );
//   }

//   Container buildDivider() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: Divider(
//         color: Color(0xFFF4F3F8),
//         thickness: 1,
//       ),
//     );
//   }

//   Widget buildSummary() {
//     return GetBuilder<CartController>(
//       builder: (_controller) => Container(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Cart Summary",
//               style: GoogleFonts.poppins(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF232629),
//               ),
//             ),
//             Text(
//               "\u20b9${_controller.amount}.00",
//               style: GoogleFonts.lato(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF979EA4),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildCloseButton(context) {
//     return Positioned(
//       top: 244,
//       left: MediaQuery.of(context).size.width / 2 - 28,
//       child: Container(
//         height: 56,
//         width: 56,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.white,
//         ),
//         child: Center(
//           child: GestureDetector(
//             onTap: () => Navigator.of(context).pop(),
//             child: Container(
//               height: 40,
//               width: 40,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.grey.withOpacity(0.3),
//               ),
//               child: Icon(
//                 Icons.close,
//                 size: 25,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CartClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     double width = size.width;
//     double height = size.height;
//     var path = Path();
//     path.moveTo(width, height);
//     path.lineTo(0, height);
//     path.lineTo(0, 28);
//     path.lineTo((width / 2) - 24, 28);
//     path.quadraticBezierTo(width / 2, 0, (width / 2) + 28, 28);
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }
