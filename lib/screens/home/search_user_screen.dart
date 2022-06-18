import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/screens/router.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchUsers extends StatefulWidget {
  const SearchUsers({Key? key}) : super(key: key);

  @override
  State<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 20,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: false,
          title: Form(
            child: TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                  hintText: "search for a user", border: InputBorder.none),
              onFieldSubmitted: (String _) {
                setState(() {
                  isSearch = true;
                  print("ini search: $isSearch");
                });
              },
            ),
          ),
        ),
        body: isSearch == true
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isEqualTo: searchController.text)
                    .get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snaphsot) {
                  if (!snaphsot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final userData = snaphsot.data;
                  return snaphsot.data!.docs.length != 0
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    AppRouter.anotherAccount,
                                    arguments: userData!.docs[index]['uid']);
                              },
                              child: ListTile(
                                title: Text(userData!.docs[index]['username']),
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(snaphsot
                                        .data!.docs[index]['photoUrl'])),
                              ),
                            );
                          },
                          itemCount: snaphsot.data!.docs.length,
                        )
                      : const Center(
                          child: Text("Theres no user"),
                        );
                })
            : Container());
  }
}
