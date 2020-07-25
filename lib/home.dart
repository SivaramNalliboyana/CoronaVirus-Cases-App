import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String confirmed = '';
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  String active = '';
  String recovered = '';
  String death = '';
  String title = 'Corona Cases World';
  TextEditingController inputcontroller = TextEditingController();
  buildcase(String title, Color textcolor, String cases) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.montserrat(
                fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Text(
            cases,
            style: GoogleFonts.montserrat(
                fontSize: 18, fontWeight: FontWeight.w700, color: textcolor),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getdata('http://covid2019-api.herokuapp.com/v2/total');
  }

  getdata(String url) async {
    try {
      var response = await http.get(url);
      var result = jsonDecode(response.body);
      setState(() {
        confirmed = result['data']['confirmed'].toString();
        death = result['data']['deaths'].toString();
        recovered = result['data']['recovered'].toString();
        active = result['data']['active'].toString();
        if (url != 'http://covid2019-api.herokuapp.com/v2/total') {
          title = inputcontroller.text;
        } else {
          title = 'World';
        }
      });
    } catch (e) {
      SnackBar snackBar = SnackBar(content: Text("No such country"));
      scaffoldkey.currentState.showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      backgroundColor: Color(0xffF2F3F5),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                  color: Color(0xffEF5416),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0))),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 140),
              child: Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text("Stay home, Stay safe!",
                          style: GoogleFonts.montserrat(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w700))),
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextField(
                      controller: inputcontroller,
                      onSubmitted: (string) => getdata(
                          'http://covid2019-api.herokuapp.com/v2/country/$string'),
                      decoration: InputDecoration(
                          filled: true,
                          hintText: "Search for country",
                          labelStyle: GoogleFonts.montserrat(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3 + 60,
                    margin: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 120,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0))),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  title,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  confirmed,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 50,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ),
                        ),
                        buildcase("Recovered", Colors.green, recovered),
                        buildcase("Deaths", Colors.red, death),
                        buildcase("Active", Colors.black, active),
                      ],
                    ),
                  ),
                  RaisedButton(
                      onPressed: () => getdata(
                          'http://covid2019-api.herokuapp.com/v2/total'),
                      color: Colors.purple,
                      child: Text("Show world Cases",
                          style: GoogleFonts.montserrat(
                              fontSize: 20, color: Colors.white)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
