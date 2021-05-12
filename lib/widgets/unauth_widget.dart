// import 'package:flutter/material.dart';
// import 'package:woocommerce_app/pages/home_page.dart';
// import 'package:woocommerce_app/pages/login_page.dart';

// class UnAuthWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         margin: EdgeInsets.only(top: 100),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.max,
//           children: <Widget>[
//             Stack(
//               children: <Widget>[
//                 Container(
//                   width: 150,
//                   height: 150,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                       begin: Alignment.bottomLeft,
//                       end: Alignment.topRight,
//                       colors: [
//                         Color(0xff2ba9e1),
//                         Color(0xff0e71b8),
//                       ],
//                     ),
//                   ),
//                   child: Icon(
//                     Icons.lock,
//                     color: Colors.white,
//                     size: 90,
//                   ),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             Opacity(
//               opacity: 0.6,
//               child: Text(
//                 "Vous devez vous connecter !",
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.headline3,
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             FlatButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => LoginPage(),
//                   ),
//                 );
//               },
//               child: Text('Se Connecter'),
//               padding: EdgeInsets.all(15),
//               color: Color(0xffafcaec),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
