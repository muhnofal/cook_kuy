import 'package:cook_kuy/utils/colors.dart';
import 'package:flutter/material.dart';

class IngredientCard extends StatefulWidget {
  // final Ingredient ingredient;
  // final bool isSelected;
  // final ValueChanged<Ingredient> onSelectedIngredients;
  final dynamic snap;
  final bool isSelected;
  // final ValueChanged onSelectedIngredients;

  const IngredientCard(
      {Key? key,
      required this.snap,
      required this.isSelected,})
      : super(key: key);

  @override
  State<IngredientCard> createState() => _IngredientCardState();
}

class _IngredientCardState extends State<IngredientCard> {
  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;

    return ListTile(
        leading: SizedBox(
            width: 60, child: Image.network(widget.snap['image_url'].toString())),
        title: Text(
          widget.snap['name'].toString(),
          // style: style,
        ),
        // trailing: isSelected
        //     ? Icon(
        //         Icons.check,
        //         color: ColorConst.ijoskripsi,
        //         size: 25,
        //       )
        //     : null,
        trailing: isSelected
            ? const Icon(
                Icons.check,
                color: ijoSkripsi,
                size: 25,
              )
            : null
        // leading: SizedBox(
        //   width: 60,
        //   child: Image.asset('assets/images/ing_apel.png'),
        // ),
        );
  }
}
