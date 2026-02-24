import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: MyApp1(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp1 extends StatefulWidget { // Изменил на StatefulWidget, чтобы экран мог обновляться
  @override
  State<MyApp1> createState() => _MyApp1State();
}

class _MyApp1State extends State<MyApp1> {
  double myOpacity = 0.5;
  double myopacity1 = 0.5;
  double myopacity2 = 0.5;
  String textlight = "";

  void _stop() {
    setState( (){
      myOpacity = 1.0;
      myopacity1 = 0.5;
      myopacity2 = 0.5;
      textlight = "STOP!";


    } );

    
  }


  void _ready() {
    setState( (){
      myopacity1 = 1.0;
      myOpacity = 0.5;
      myopacity2 = 0.5;
      textlight = "BE READY!";

    } );

    
  }

  void _GO() {
    setState( (){
      myopacity2 = 1.0;
      myOpacity = 0.5;
      myopacity1 = 0.5;
      textlight = "GO!";

    } );

    
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(textlight, style: TextStyle(fontSize: 24)),
            
          
            
           
           
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(myOpacity),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: _stop, // Подключаем функцию
              child: Text(''),
            ),
           
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.withOpacity(myopacity1),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: _ready, // Подключаем функцию
              child: Text(''),
            ),     



            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.withOpacity(myopacity2),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: _GO, // Подключаем функцию
              child: Text(''),
            ), 
            
          
            
           
          ],
        ),
      ),
    );
  }
}