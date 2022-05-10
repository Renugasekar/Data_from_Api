import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DataApi(),
    );
  }
}
class DataApi extends StatefulWidget {
  const DataApi({ Key key }) : super(key: key);

  @override
  State<DataApi> createState() => _DataApiState();
}

class _DataApiState extends State<DataApi> {

  Future getUserData() async{
    var response = await http.get(Uri.https("jsonplaceholder.typicode.com", "users"));
    var jsonData = jsonDecode(response.body);
    List<User> users=[];
    for( var u in jsonData){
      User user=User(u['name'],u['email'],u['username']);
      users.add(user);
    }
    print(users.length);
    return users;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Center(child: Text('Users Data')),
    ),
    body:Container(
      child:Card(
        child:FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot){
          if(snapshot.data == null){
            return Container(
              child: Center(
                child:Text('Loading..')
                ),);
          }
          else {
            return ListView.builder(
            itemCount: snapshot.data.length, 
            itemBuilder:(context, index){
              return Card(
                elevation:3.0,
                child: ListTile(
                  title: Text(snapshot.data[index].name),
                      subtitle: Text(snapshot.data[index].username),
                          trailing: Text(snapshot.data[index].email),
                ),
              );
            }
            );
          }
        },
        )),)
    );
  }
}

class User{
  final String name,email,username;
  User(this.name, this.email, this.username);
}