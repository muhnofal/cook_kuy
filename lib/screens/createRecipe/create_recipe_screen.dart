import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({Key? key}) : super(key: key);

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Center(
              child: Text("Logout"),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final resepMakanan = ['roti burger', 'bawang bombai', 'becon', 'daging sapi'];
              final inputanUser = ['dagin'];
              resepMakanan.sort((item1, item2) => item1.compareTo(item2));
              
              print("resep makanan: $resepMakanan");
            },
            child: Text("Test"),
          )
        ],
      ),
    );
  }
}
