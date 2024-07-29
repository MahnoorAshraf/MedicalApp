  import 'package:flutter/material.dart';
class Containers extends StatelessWidget {
  final Color clr;
  final String txt;
 final VoidCallback onTap;
 final bool loading;
const Containers(
      {Key? key, required this.clr, required this.txt,required this.onTap,this.loading=false,  bool ?disable, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
           
 width: MediaQuery.of(context).size.width *0.8,
       height:  MediaQuery.of(context).size.height *0.07,
          decoration: BoxDecoration(
            color: clr,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child:loading? CircularProgressIndicator(strokeWidth: 3,color: Colors.white,) : Text(
             txt,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ));
  }
}