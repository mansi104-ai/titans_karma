import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pec_chat/resources/auth_methods.dart';
import 'package:pec_chat/resources/firestore_methods.dart';
import 'package:pec_chat/screens/login_screen.dart';
import 'package:pec_chat/utils/colors.dart';
import 'package:pec_chat/utils/utils.dart';
import 'package:pec_chat/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
              child: CircularProgressIndicator(),
             )
        : Scaffold(

           appBar: PreferredSize(
             preferredSize: Size.fromHeight(kToolbarHeight),
             child: Container(
             decoration: BoxDecoration(

            color: Colors.blue
            ),
              child: AppBar(
                backgroundColor: Colors.transparent,
              // Set transparent background color
               // Remove shadow
                 title: Text(
              'PEC chat', style: TextStyle(
                   fontStyle: FontStyle.italic,
                 ) ,
                 ),
                centerTitle: false,
          ),
        ),
      ),
              backgroundColor: Colors.white,

              body:ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                          color: Colors.blue
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                           Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.black,
                                backgroundImage: NetworkImage(
                                userData['photoUrl'],
                                ),
                                radius: 40,
                              ),
                              Expanded(
                                flex: 1,
                                child:Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                   buildStatColumn(postLen, "Posts"),
                                   buildStatColumn(followers, "Followers"),
                                   buildStatColumn(following, "Following"),
                                ],
                               ),
                              )
                            ],
                          ),




                          Container(
                              //alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(
                                top: 15, left: 20
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [ Column(
                                  children: [
                                    Text(
                                    userData['username'],
                                      style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 15
                                      ),
                                    ),
                                     Container(
                                        alignment: Alignment. topLeft,
                                        padding: const EdgeInsets.only(
                                        top: 1,
                                          ),
                                          child: Text(
                                             userData['bio'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13
                                            ),
                                          ),
                                        ),
                                      ],
                                      ),
                                  Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                      FirebaseAuth.instance.currentUser!.uid ==
                                         widget.uid
                                       ?  FollowButton(
                                          text: 'Sign Out',
                                          backgroundColor:Colors.blue,
                                          textColor: Colors.white,
                                          borderColor: Colors.black,
                                          function: () async {
                                          await AuthMethods().signOut();
                                            if (context.mounted) {
                                            Navigator.of(context)
                                            .pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen(),
                                              ),
                                            );
                                          }
                                        },
                                        )
                                      : isFollowing
                                        ? FollowButton(
                                            text: 'Unfollow',
                                            backgroundColor: Colors.blue,
                                            textColor: Colors.white,
                                            borderColor: Colors.black,
                                            function: () async {
                                            await FireStoreMethods()
                                            .followUser(
                                            FirebaseAuth.instance
                                            .currentUser!.uid,
                                            userData['uid'],
                                            );

                                          setState(() {
                                          isFollowing = false;
                                          followers--;
                                                }
                                              );
                                            },
                                          )
                                        : FollowButton(
                                           text: 'Follow',
                                           backgroundColor: Colors.blue,
                                           textColor: Colors.white,
                                           borderColor: Colors.black,
                                           function: () async {
                                           await FireStoreMethods()
                                           .followUser(
                                            FirebaseAuth.instance
                                           .currentUser!.uid,
                                            userData['uid'],
                                          );

                                          setState(() {
                                            isFollowing = true;
                                            followers++;
                                              }
                                            );
                                          },
                                        )
                                      ],
                                  ),//
                                ],
                               ),
                                ),//
                              ],
                          ),
                    ),),

                        const Divider(),
                       FutureBuilder(
                          future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                          builder: (context, snapshot) {
                           if (snapshot.connectionState == ConnectionState.waiting) {
                           return const Center(
                              child: CircularProgressIndicator(),
                );
              }

                           return GridView.builder(
                                 shrinkWrap: true,
                                 itemCount: (snapshot.data! as dynamic).docs.length,
                                 gridDelegate:
                                 const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1,
                             ),
                                itemBuilder: (context, index) {
                                   DocumentSnapshot snap =
                                 (snapshot.data! as dynamic).docs[index];

                               return SizedBox(
                                   child: Image(
                      image: NetworkImage(snap['postUrl']),
                      fit: BoxFit.cover,
                    ),
                   );
                  },
                 );
                },
                    )
        ],
      ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}