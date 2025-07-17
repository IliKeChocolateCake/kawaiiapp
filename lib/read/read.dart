//download epub files from project gutenberg

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class Read extends StatefulWidget{

  const Read ({super.key});

  @override
  State<Read> createState()=> ReadState();
}

class ReadState extends State<Read>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: Text('Read', style: GoogleFonts.dynaPuff( color: Colors.white),),
        backgroundColor: const Color(0xFFFFA6C9),

      ),



    );
  }


}