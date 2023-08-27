import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pec_chat/utils/colors.dart';
import 'package:pec_chat/utils/global_variable.dart';
import 'package:pec_chat/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: width > webScreenSize
      //     ? null
//       : AppBar(
//             backgroundColor: Color.fromARGB(255, 16, 113, 7),
//             centerTitle: false,
//             elevation: 5,
//             title: SvgPicture.asset(
//               'assets/pec_chat.svg',
//               height: 30,
//             ),
      
//             actions: [
//               IconButton(
//                 icon: const Icon(
//                   Icons.messenger_outline,
//                   color: primaryColor,
//                 ),
//                 onPressed: () {},
//               ),
//             ],
//               bottom: PreferredSize(
//     preferredSize: Size.fromHeight(4.0), // Height of the border
//     child: Container(
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: Colors.black, // Color of the border
//             width: 2.0, // Width of the border
//           ),
//         ),
//       ),
//     ),
//   ),
// ),

          
        
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize ? width * 0.3 : 0,
                vertical: width > webScreenSize ? 15 : 0,
              ),
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}