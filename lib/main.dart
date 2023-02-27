import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Count It',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Count It'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var total;
  var left;

  Future<void> totalsCount() async {
    final response = await http.get(Uri.parse('https://ykumar.scweb.ca/countit/readCount.php'));
    final jsonResponse = json.decode(response.body);
    final totals = jsonResponse[0]['totals'];
    total = int.parse(totals);
    return totals;
  }

  Future<void> leftsCount() async {
      final response = await http.get(Uri.parse('https://ykumar.scweb.ca/countit/readCount.php'));
      final jsonResponse = json.decode(response.body);
      final lefts = jsonResponse[0]['lefts'];
      left = int.parse(lefts);
  }


  Future<void> updateCounts() async {
    final url = Uri.parse('https://ykumar.scweb.ca/countit/incrementtotal.php');
    final response = await http.post(url, body: {
      'increment_totals': '1',
    });
    if (response.statusCode == 200) {
      print('Counts updated successfully');
    } else {
      print('Error updating counts');
    }
  }


  Future<void> updateCountsLefts() async {
    final url = Uri.parse('https://ykumar.scweb.ca/countit/incrementleft.php');
    final response = await http.post(url, body: {
      'increment_lefts': '1',
    });
    if (response.statusCode == 200) {
      print('Counts updated successfully');
    } else {
      print('Error updating counts');
    }
  }

  Future<void> decreaseTotal() async {
    final url = Uri.parse('https://ykumar.scweb.ca/countit/decreaseTotal.php');
    final response = await http.post(url, body: {
      'decrease_totals': '1',
    });
    if (response.statusCode == 200) {
      print('Total decreased successfully');
    } else {
      print('Error decreasing total');
    }
  }
  Future<void> decreaseLeft() async {
    final url = Uri.parse('https://ykumar.scweb.ca/countit/decreaseLeft.php');
    final response = await http.post(url, body: {
      'decrease_lefts': '1',
    });
    if (response.statusCode == 200) {
      print('Total decreased successfully');
    } else {
      print('Error decreasing left');
    }
  }

  void resetCounts() async {
    final url = 'https://ykumar.scweb.ca/countit/resetCounts.php';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('Counts reset successfully');
    } else {
      print('Error resetting counts');
    }
  }


  @override
  void initState() {
    super.initState();
    total = 0;
    left = 0;
    setState(() {
      totalsCount();
      leftsCount();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  total = 0;
                  left = 0;
                  resetCounts();
                });
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: FutureBuilder(
        future: totalsCount(), // replace with your actual asynchronous function
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text("How many times do you have to read?",style: TextStyle(color: Colors.white, fontSize: 20),),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xff53a99a),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 27),
                                        blurRadius: 33,
                                        color: Color(0x3827ae96),
                                      )
                                    ],
                                  ),
                                  height: 200.0,
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                                    alignment: Alignment.center,
                                    child: Text("$total",
                                      style: TextStyle(
                                        fontFamily: 'Helvetica',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 120,
                                        color: Colors.white,
                                      ),
                                    )
                                ),
                              ],
                            )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(color: Colors.white)
                                        )
                                    )
                                ),
                                onPressed: (){
                                  setState(()  {
                                    updateCounts();
                                    totalsCount();
                                    leftsCount();
                                    total += 1;;
                                  });
                                },
                                child: Text("+",style: TextStyle(color: Colors.red,fontSize: 50),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(color: Colors.white)
                                        )
                                    )
                                ),
                                onPressed: (){
                                  setState(() {
                                    if(total == 0){
                                      total = 0;
                                    }else{
                                      total -= 1;
                                      decreaseTotal();
                                    }
                                  });
                                },
                                child: Text("-",style: const TextStyle(color: Colors.red,fontSize: 50),),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text("Times Completed?",style: TextStyle(color: Colors.white, fontSize: 20),),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xff53a99a),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 27),
                                        blurRadius: 33,
                                        color: Color(0x3827ae96),
                                      )
                                    ],
                                  ),
                                  height: 200.0,
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                                    alignment: Alignment.center,
                                    child: Text("$left",
                                      style: TextStyle(
                                        fontFamily: 'Helvetica',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 120,
                                        color: Colors.white,
                                      ),
                                    )
                                ),
                              ],
                            )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.white)
                                    ),
                                  ),
                                ),
                                onPressed: (){
                                  setState(() {
                                    if(total>=1){
                                      updateCountsLefts();
                                      leftsCount();
                                      decreaseTotal();
                                      left +=1;
                                      total -=1;
                                    }
                                  });
                                },
                                child: Text("+",style: TextStyle(color: Colors.red,fontSize: 50),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(color: Colors.white)
                                        )
                                    )
                                ),
                                onPressed: (){
                                  setState(() {
                                    if(left == 0){
                                      left = 0;
                                    }else{
                                      left -=1;
                                      decreaseLeft();
                                    }
                                  });
                                },
                                child: Text("-",style: const TextStyle(color: Colors.red,fontSize: 50),),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
          } else {
            // return a loading indicator or some other temporary widget
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
