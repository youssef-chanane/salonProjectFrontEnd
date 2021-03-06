import 'dart:io';
// import 'dart:js';
import 'package:flutter/material.dart';
import 'package:flutter_laravel/screens/views/navBottom.dart';
import 'package:flutter_laravel/services/auth.dart';
import 'package:flutter_laravel/services/reserver.dart';
import 'package:provider/provider.dart';


class ReservationScreen extends StatelessWidget {
  final stylist;
  final reservationList;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _namecontroller = TextEditingController();



  ReservationScreen(this.stylist,this.reservationList);
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color.fromARGB(255, 215, 215, 235),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.all(70.0),
            child: Text(
              'Tourn List',
              style: TextStyle(
                  color: Color.fromARGB(255, 120, 89, 146),
                  fontFamily: 'Cursive',
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          ),
        ),
        body:SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 30),
                          
                          child: Column(
                            
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(this.reservationList.length,(i)=> ReserveTile(reservationList[i],stylist)),
                          ),
                        ),
              // buildList(),
              Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your name',
              ),
              controller: _namecontroller,

              validator: (String value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  //user id is the id of salon owner
                  Map creds = {
                            'name': _namecontroller.text,
                            'user_id': stylist["user_id"],
                            };
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState.validate()) {
                    // print(creds);
                    await Provider.of<Reserver>(context, listen: false)
                      .store(creds: creds);
                    var reservationList=Provider.of<Reserver>(context, listen: false).reservations;

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ReservationScreen(stylist,reservationList)));                  }
                },
                child: const Text('Reserver'),
              ),
            ),
          ],
        ),
      ),
    )
              // ReserveForm()
            ],
          ),
        ),
        bottomNavigationBar: NavBottom(stylist),
      );
}



class ReserveTile extends StatelessWidget {
  final reservation;
  final stylist;

  ReserveTile(this.reservation,this.stylist);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 60,
                child: Text(
                  reservation['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
          (Auth.role==2)?
          IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                     await Provider.of<Reserver>(context, listen: false)
                      .destroy(reservation["id"]);
                      await Provider.of<Reserver>(context, listen: false)
                      .show(reservation["user_id"]);
                    var reservationList= await Provider.of<Reserver>(context, listen: false).reservations;

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ReservationScreen(stylist,reservationList)));  
                      print("ok");
                  }):Container(width: 0.0, height: 0.0)
        ],
      ),
    );
  }
}

