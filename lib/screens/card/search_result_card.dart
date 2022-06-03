import 'package:cook_kuy/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SearchResultCard extends StatefulWidget {
  final dynamic snap;
  const SearchResultCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 80
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            offset: const Offset(
              3.0,
              6.0,
            ), //Offset
            blurRadius: 8.0,
            // spreadRadius: 1.0,
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                // fit
                image: NetworkImage(widget.snap['image_url'].toString()),
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                widget.snap['name'].toString(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: abuSkripsi),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          RatingBar.builder(
            ignoreGestures: true,
            initialRating: widget.snap['rating'].toDouble(),
            minRating: 1,
            direction: Axis.horizontal,
            itemSize: 20,
            itemBuilder: ((context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                )),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/step_icon.png',
                width: 20,
                height: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text("5 Langkah", style: TextStyle(color: Colors.grey[500]),)
            ],
          ),
        ],
      ),
    );
  }
}
