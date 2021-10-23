import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(
        body: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Home',
                  style: TextStyle(fontSize: 40),
                ),
                SizedBox(height: 48),
                Container(
                  height: 200,
                  width: 200,
                  margin: EdgeInsets.fromLTRB(0,0,0,25),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/no_internet.png")
                    )
                  ),
                ),
                Text("No Internet Connection", style: TextStyle(fontSize: 20),
                ),
                Padding(
                  padding:  EdgeInsets.all(15),
                  child: Text(
                    "You are not connected to the internet. Make sure Wi-Fi is on, Airplane Mode is Off",style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}