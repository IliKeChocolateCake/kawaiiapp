import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Home extends StatefulWidget{

  const Home ({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home>{

  @override
  Widget build(BuildContext context) {

    return Scaffold(


      appBar: AppBar(

        title: Text('Home', style: GoogleFonts.dynaPuff( color: Colors.white),),
        backgroundColor: const Color(0xFFFFA6C9),
        
      ),

      body: SafeArea(

          child: SingleChildScrollView(


            child: Column(

              children: [



              ],
            ),
          ),

      ),


    );
  }





}