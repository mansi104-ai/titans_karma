import 'package:flutter/material.dart';

void main() => runApp(ProductivityApp());

class ProductivityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String userName = "Gopal Verma";
  final String avatarImageURL =
      "https://example.com/avatar.jpg"; // Replace with the actual URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Navigation Bar
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            color: Colors.blue,
            child: Row(
              children: [
                // Welcome Text
                Text(
                  "WELCOME",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Spacer to push the Avatar to the right
                Spacer(),
                // User Name
                Text(
                  userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                // Avatar
                CircleAvatar(
                  radius: 24.0,
                  backgroundImage: NetworkImage(avatarImageURL), // Load image from URL
                ),
              ],
            ),
          ),
          // Add other widgets for the main content of the home screen below
          // ...
          
        ],
      ),
    );
  }
}
