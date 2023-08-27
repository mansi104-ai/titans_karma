import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pec_chat/providers/user_provider.dart';
import 'package:pec_chat/resources/firestore_methods.dart';
import 'package:pec_chat/utils/colors.dart';
import 'package:pec_chat/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);
  
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

Future<void> _selectImage(BuildContext parentContext) async {
  return showDialog(
    context: parentContext,
    builder: (BuildContext context) {
      return SimpleDialog(
        backgroundColor: Colors.transparent,
        children: <Widget>[
          Container(
             // Background color for the "Create a Post" block
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.teal[700]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create a Post',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    Uint8List file = await pickImage(ImageSource.camera);
                    setState(() {
                      _file = file;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white, // Button background color
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Take a photo',
                      style: TextStyle(
                        color: Colors.black, // Button text color
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white, // Button background color
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Choose from Gallery',
                      style: TextStyle(
                        color: Colors.black, // Button text color
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}


  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
        }
        clearImage();
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return _file == null
? Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
  ),
  child: Column(
    children: [
      Container(
        height: 50,
        padding: const EdgeInsets.all(8), // Adjust padding here
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'New Post',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      IconButton(
        icon: const Icon(
          Icons.upload,
          color: Colors.black,
        ),
        onPressed: () => _selectImage(context),
      ),
    ],
  ),
)

        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.teal,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: clearImage,
              ),
              title: const Text(
                'New Post', style: TextStyle(
                  color: Colors.black
                ),
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: () => postImage(
                    userProvider.getUser.uid,
                    userProvider.getUser.username,
                    userProvider.getUser.photoUrl,
                  ),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            ),
            // POST FORM
            body: Container(
              color: Colors.white,
              child: Column(
              children: <Widget>[
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0)),
                const Divider(),
                Container(
                  child: Padding( 
                    padding:  const EdgeInsets.all(16),
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only( right: 10),
                        child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        userProvider.getUser.photoUrl,
                        
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                    child:SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            hintStyle: TextStyle(color: Colors.blueGrey),
                            border: InputBorder.none),
                        maxLines: 8,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),),
                    ],
                    ),
                    ),
                    ),
                    SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(_file!),
                          ),
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),
                ),
                ),
                const Divider(),
              
              ],
              
            ),
            ),
          );
  }
}