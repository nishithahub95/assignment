import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {

  //final String title;

  //final String image;
  final Function callback;
  final int selected;
  final List category=['All','Pizza','meal','burger','salad'];
   RoundButton({Key? key, required this.callback, required this.selected,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index)=> GestureDetector(
          onTap: ()=>callback(index),
           child: Container(
             height: 50,
             width: 100,
             decoration: BoxDecoration(
                 color:selected==index?Color(0xfffe4164):Colors.white,
                 //Color(0xfffe4164)
                 borderRadius: BorderRadius.all(Radius.circular(30)),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.2),
                     spreadRadius: 4,
                     blurRadius: 7,
                     offset: Offset(2, 3),
                   )
                 ]
             ),
             child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(category[index]),
                // SizedBox(width: 2,),
                // Image(
                //   height: 40,
                //     width: 30,
                //     image: AssetImage(image))
              ],
        ),
           ),
         ),
        separatorBuilder: (_,index)=>SizedBox(width: 20,),
        itemCount: category.length,
      ),
    );
  }
}
