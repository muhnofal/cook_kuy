import 'package:cook_kuy/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:readmore/readmore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 4,
          elevation: 1,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(48),
              child: Image.asset(
                "assets/images/person.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: const Text(
            "Hi, Ravy Aryo Pratama",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  // color:Colors.black,
                  border: Border.all(
                      color: const Color.fromARGB(255, 165, 165, 165)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(48),
                            child: Image.asset(
                              "assets/images/cook_kuy_logo.png",
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text("Naufal")
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Image.asset(
                      "assets/images/makanan.png",
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: const Text("Omelette"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/Star.png",
                            height: 15,
                            width: 15,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 5),
                          const Text("5.0"),
                          const SizedBox(width: 5),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(48),
                            child: Image.asset(
                              "assets/images/iconn.png",
                              height: 15,
                              width: 15,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text("3 Langkah"),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ReadMoreText(
                        "Ini ada menu pertama kita yang terbuat dari telur, menu ini kita namakan omelette terenak didunia",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        trimCollapsedText: "more",
                        trimExpandedText: "show less",
                        trimLines: 1,
                        trimMode: TrimMode.Line,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
