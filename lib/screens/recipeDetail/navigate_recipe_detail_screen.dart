import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class NavRecipeDetail extends StatefulWidget {
  final dynamic snap;

  const NavRecipeDetail({Key? key, this.snap}) : super(key: key);

  @override
  State<NavRecipeDetail> createState() => _NavRecipeDetailState();
}

class _NavRecipeDetailState extends State<NavRecipeDetail> {
  final TextEditingController _commentController = TextEditingController();
  var userData = {};
  getData() async {
    var snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['uid'])
        .get();
    userData = snap.data()!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = widget.snap;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Step by step",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [stepByStep(snapshot)],
        ),
      ),
    );
  }

  Widget stepByStep(final snapshot) {
    final List step = snapshot['step'];
    return Padding(
      // padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      padding: const EdgeInsets.only(top: 25, bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 350,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              separatorBuilder: (context, index) => const SizedBox(
                width: 12,
              ),
              scrollDirection: Axis.vertical,
              // shrinkWrap: true,
              itemCount: step.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                // fit
                                image: NetworkImage(step[index]['image'])),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Step ${index + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        step[index]['description'].toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
