import 'package:flutter/material.dart';
class roundbutton extends StatelessWidget {
  final String title;
  final bool loading;
  final Color color;
  final VoidCallback ontap;
  const roundbutton({super.key,required this.title,required this.color, required this.ontap, this.loading=false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color:color,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: loading ? CircularProgressIndicator(strokeWidth: 3,color: Colors.white,) : Text(title,style: TextStyle(color: Colors.white,fontFamily: 'Merienda'),)
        ),
      ),
    );
  }
}
