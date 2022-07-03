import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class FollowAndFollowingWidget extends StatelessWidget {
const FollowAndFollowingWidget(
      {Key? key, required this.labeltext, required this.count})
      : super(key: key);
  final String labeltext;
  final String count;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(count,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(labeltext,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
        ],
      ),
    );
  }
}
