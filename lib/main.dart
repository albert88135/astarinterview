import 'dart:convert';

import 'package:a_star/todo_model.dart';
import 'package:flutter/material.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> todos = [];
  TextEditingController userInput = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getTodo();
    super.initState();
  }

  void getTodo() async {
    http.Response response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/todos/'));
    // print(jsonDecode(response.body));
    List data = jsonDecode(response.body);
    data.forEach((element) {
      todos.add(Todo.fromMap(element));
    });

    setState(() {});
  }

  List<Todo> searchResults() {
    if (userInput.text.length > 3) {
      return todos
          .where((element) => element.title.contains(userInput.text))
          .toList();
    } else {
      return todos;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: SafeArea(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Search',
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              userInput.text = value;
                            });
                            print(value);
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      'Here are the todos!',
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ),
                  ...searchResults().map(
                    (e) => Container(
                      padding: EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 4,
                              spreadRadius: 2,
                            )
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Title: ${e.title}'),
                          const SizedBox(
                            height: 4,
                          ),
                          Text('id: ${e.id}'),
                          const SizedBox(
                            height: 4,
                          ),
                          Text('UserId: ${e.userId}'),
                          Row(
                            children: [
                              Text('Completed?'),
                              Checkbox(
                                  value: e.completed,
                                  onChanged: (onChangedValue) {
                                    e.completed = onChangedValue!;
                                    setState(() {});
                                  }),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                  // ...todos.map(
                  //   (e) => Container(
                  //     padding: EdgeInsets.all(16),
                  //     margin: const EdgeInsets.all(16),
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(20),
                  //         boxShadow: const [
                  //           BoxShadow(
                  //             color: Colors.grey,
                  //             blurRadius: 4,
                  //             spreadRadius: 2,
                  //           )
                  //         ]),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text('Title: ${e.title}'),
                  //         const SizedBox(
                  //           height: 4,
                  //         ),
                  //         Text('id: ${e.id}'),
                  //         const SizedBox(
                  //           height: 4,
                  //         ),
                  //         Text('UserId: ${e.userId}'),
                  //         Row(
                  //           children: [
                  //             Text('Completed?'),
                  //             Checkbox(
                  //                 value: e.completed,
                  //                 onChanged: (onChangedValue) {
                  //                   e.completed = onChangedValue!;
                  //                 }),
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ));
  }
}
